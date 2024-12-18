import 'dart:async';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_service/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum AuthState { loading, loggedOut, user, admin }

class AuthNotifier extends StateNotifier<AuthState> {
  String? userId;

  late Future<void> initialized;

  AuthNotifier() : super(AuthState.loading) {
    initialized = _loadAuthState();
  }

  // Load auth state from SharedPreferences
  Future<void> _loadAuthState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authStateString = prefs.getString('authState');
      userId = prefs.getString('userId');

      if (authStateString != null) {
        state = authStateString == 'AuthState.user'
            ? AuthState.user
            : authStateString == 'AuthState.admin'
                ? AuthState.admin
                : AuthState.loggedOut;
      } else {
        state = AuthState.loggedOut;
      }
      log("Loaded userId: $userId, authState: $authStateString");
    } catch (e) {
      log("Error loading auth state: $e");
      state = AuthState.loggedOut;
    }
  }

  // Save auth state and userId to SharedPreferences
  Future<void> _saveAuthState(AuthState authState) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('authState', authState.toString());
      if (userId != null) {
        await prefs.setString('userId', userId!);
      }
      log("Saved authState: ${authState.toString()}, userId: $userId");
    } catch (e) {
      log("Error saving auth state: $e");
    }
  }

  // Login as user
  void loginAsUser(String userId) {
    log('User State Set!');
    this.userId = userId;
    state = AuthState.user;
    _saveAuthState(state);
  }

  // Login as admin
  void loginAsAdmin(String userId) {
    log('Admin State Set!');
    this.userId = userId;
    state = AuthState.admin;
    _saveAuthState(state);
  }

  // Sign out from Firebase and clear local data
  Future<String> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('authState');
      await prefs.remove('userId');
      state = AuthState.loggedOut;
      userId = null;
      log("User logged out successfully");
      return "User logged out successfully";
    } catch (e) {
      log("Logout failed: $e");
      return "Logout failed: $e";
    }
  }

  Future<bool> _registerUser({
    required User? user,
    required String role,
    required String name,
    required String email,
    required String phone,
  }) async {
    if (user == null) {
      log('Registration failed: User is null.');
      return false;
    }

    userId = user.uid;
    final usersRef = FirebaseFirestore.instance.collection('Users');

    try {
      // Check if the user already exists in Firestore
      DocumentSnapshot userSnapshot = await usersRef.doc(userId).get();

      if (!userSnapshot.exists) {
        // Create a new user document
        await usersRef.doc(userId).set({
          'role': role,
          'name': name,
          'email': email,
          'phone': phone,
          'profilePictureUrl': '',
          'about': 'Write about you!',
          'favorites': [],
          'bookings': [],
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        log('User registered successfully with ID: $userId');

        // Automatically log the user in based on role
        if (role == 'user') {
          loginAsUser(userId!);
          log('Logged in as user with ID: $userId');
        } else if (role == 'admin') {
          loginAsAdmin(userId!);
          log('Logged in as admin with ID: $userId');
        }

        return true;
      } else {
        log('User already exists in Firestore with ID: $userId');
        return false;
      }
    } catch (e) {
      log('Error during user registration: $e');
      return false;
    }
  }

  Future<String> otpValidation({
    required WidgetRef ref,
    required String otp,
    required String verifId,
    required bool registeration,
    required String role,
    required String name,
    required String email,
    required String phone,
  }) async {
    try {
      // Create phone auth credential
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verifId,
        smsCode: otp,
      );

      // Sign in with the credential
      final cred = await FirebaseAuth.instance.signInWithCredential(credential);

      // Ensure user is valid
      if (cred.user == null) {
        return 'Validation failed: No user found after OTP verification.';
      }

      if (registeration) {
        // Register the user if in registration mode
        bool registrationResult = await _registerUser(
          user: cred.user,
          role: role,
          name: name,
          email: email,
          phone: phone,
        );

        if (!registrationResult) {
          return 'Registration failed.';
        }
      }

      // Fetch user role and handle login
      final userRole = await ref.read(userProvider.notifier).fetchUserData();
      if (userRole == 'user') {
        loginAsUser(cred.user!.uid);
      } else if (userRole == 'admin') {
        loginAsAdmin(cred.user!.uid);
      } else {
        log('Unknown role received: $userRole');
        return 'Validation successful but role assignment failed.';
      }

      return 'Validation successful';
    } catch (err) {
      return 'OTP Validation failed: $err';
    }
  }

  Future<String?> startPhoneLogin({
    required bool resendOtp,
    required bool newRegistration,
    required String phoneNumber,
  }) async {
    try {
      log('Starting phone login for: $phoneNumber');

      // Check if user is registered with a timeout
      bool isUserRegister = true;
      if (resendOtp) {
        try {
          isUserRegister = await _isUserRegistered(phoneNumber)
              .timeout(const Duration(seconds: 10));
        } catch (e) {
          if (e is TimeoutException) {
            log('Registration check timed out');
            return 'verification timeout';
          }
          log('Error during registration check: $e');
          throw Exception('Error during registration check: $e');
        }
      }

      // Adjust registration flag
      if (newRegistration) {
        isUserRegister = !isUserRegister;
      }
      bool setResponse = false;
      final completer = Completer<String?>();

      if (isUserRegister || resendOtp) {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            log('Auto verification completed. Credential: $credential');
            if (!setResponse) {
              completer.complete('Auto verification');
              setResponse = true;
            }
          },
          verificationFailed: (FirebaseAuthException e) {
            log('Verification failed: ${e.message}');
            if (!setResponse) {
              completer.complete('Verification failed');
              setResponse = true;
            }
          },
          codeSent: (String verificationId, int? resendToken) {
            log('Verification code sent: $verificationId');
            if (!setResponse) {
              completer.complete(verificationId);
              setResponse = true;
            }
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            log('Code retrieval timeout');
            if (!setResponse) {
              completer.complete('Timeout');
              setResponse = true;
            }
          },
        );
      } else {
        completer.complete('Not registered');
      }

      return await completer.future;
    } catch (e) {
      log('Phone login failed: $e');
      throw Exception('Phone login failed: $e');
    }
  }

  /// Checks if the user is registered in Firestore
  Future<bool> _isUserRegistered(String phone) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('phone', isEqualTo: phone)
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      log('Registration validation failed: $e');
      return false;
    }
  }

// // Sign up a new user and save to Firestore if necessary
//   Future<String> signUpByEmailPassword({
//     required String role,
//     required String image,
//     required String name,
//     required String email,
//     required String password,
//     required String phone,
//   }) async {
//     try {
//       UserCredential userCredential;
//       bool result = false;
//       // Email/password authentication
//       userCredential = await FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: password);
//       if (userCredential.user != null) {
//         result = await _registerUser(
//             userCredential.user, role, image, name, email, phone);
//       }

//       return result ? 'Signup Successful' : 'Signup failed';
//     } catch (e) {
//       log('Signup failed: $e');
//       return 'Signup failed: ${e.toString()}';
//     }
//   }

//   Future<String> loginByEmailPassword({
//     required String email,
//     required String password,
//   }) async {
//     try {
//       UserCredential userCredential = await FirebaseAuth.instance
//           .signInWithEmailAndPassword(email: email, password: password);

//       if (userCredential.user != null) {
//         userId = userCredential.user!.uid;

//         DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
//             .collection("Users")
//             .doc(userId)
//             .get();

//         if (userSnapshot.exists) {
//           final role = userSnapshot['role'];
//           if (role == 'user') {
//             loginAsUser(userId!);
//           } else if (role == 'admin') {
//             loginAsAdmin(userId!);
//           }
//           return 'Login successful';
//         } else {
//           logout();
//           return 'User role not found';
//         }
//       }
//       return 'Login failed';
//     } catch (e) {
//       log('Login failed: $e');
//       return 'Login failed: ${e.toString()}';
//     }
//   }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
