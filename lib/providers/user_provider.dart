import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

final userProvider =
    StateNotifierProvider<UserNotifier, UserModel?>((ref) => UserNotifier());

class UserNotifier extends StateNotifier<UserModel?> {
  UserNotifier() : super(null);

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> initialize() async {
    await _loadLocalUserData();
    if (state == null) {
      await fetchUserData();
    }
  }

  // Load user data from SharedPreferences
  Future<void> _loadLocalUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getStringList('user_data');
    final favorites = prefs.getStringList('favorites') ?? [];
    if (userData != null && userData.length == 6) {
      state = UserModel(
        name: userData[0],
        email: userData[1],
        phone: userData[2],
        profilePictureUrl: userData[3],
        about: userData[4],
        role: userData[5],
        favorites: favorites,
      );
    }
  }

  // Save user data to SharedPreferences
  Future<void> _saveLocalUserData(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('user_data', [
      user.name,
      user.email,
      user.phone,
      user.profilePictureUrl,
      user.about,
      user.role,
    ]);
    await prefs.setStringList('favorites', user.favorites);
  }

  // Fetch user data based on current user's ID and update the state and local storage
  Future<String> fetchUserData() async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      log('No user ID found in FirebaseAuth. User might not be logged in.');
      return '';
    }
    try {
      final snapshot = await _firestore.collection('Users').doc(userId).get();
      if (!snapshot.exists) {
        log('No document found for userId: $userId in Users collection.');
        return '';
      }

      final data = snapshot.data();
      if (data != null) {
        final user = UserModel.fromMap(data);
        state = user;
        await _saveLocalUserData(user);
        log('Fetched and saved user data for userId: $userId');
        return data['role'] ?? 'user';
      }

      log('Document exists but data is null for userId: $userId');
      return '';
    } catch (e) {
      log('Error fetching user data: $e');
      return '';
    }
  }

// Toggle favorite item (add or remove)
  Future<void> toggleFavorite(String itemId) async {
    if (state == null) return;

    final currentFavorites = state!.favorites;
    final updatedFavorites = List<String>.from(currentFavorites);

    if (updatedFavorites.contains(itemId)) {
      updatedFavorites.remove(itemId);
    } else {
      updatedFavorites.add(itemId);
    }

    final updatedUser = state!.copyWith(favorites: updatedFavorites);
    state = updatedUser;

    // Update local storage
    await _saveLocalUserData(updatedUser);

    // Update Firestore
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      try {
        await _firestore
            .collection('Users')
            .doc(userId)
            .update({'favorites': updatedFavorites});
        log('Favorites updated successfully in Firestore.');
      } catch (e) {
        log('Error updating favorites in Firestore: $e');
        // Optionally revert the local favorites in case of error
      }
    }
  }

  // Update user profile
  Future<String> updateProfile({
    String? userId,
    String? name,
    String? email,
    String? about,
    String? profilePictureUrl,
  }) async {
    if (userId == null) {
      return 'Null UserId';
    }

    try {
      final userRef =
          FirebaseFirestore.instance.collection('Users').doc(userId);

      Map<String, dynamic> updates = {};
      if (name != null) updates['name'] = name;
      if (email != null) updates['email'] = email;
      if (about != null) updates['about'] = about;
      if (profilePictureUrl != null && profilePictureUrl != "error") {
        updates['profilePictureUrl'] = profilePictureUrl;
      }

      updates['updatedAt'] = FieldValue.serverTimestamp();

      // Update Firestore with the new profile information
      await userRef.update(updates);
      log("Profile updated successfully in Firestore");

      // Now update the local state and SharedPreferences
      if (state != null) {
        final updatedUser = state!.copyWith(
          name: name ?? state!.name,
          email: email ?? state!.email,
          about: about ?? state!.about,
          profilePictureUrl: profilePictureUrl ?? state!.profilePictureUrl,
        );
        state = updatedUser;

        // Also update local storage with the updated user data
        await _saveLocalUserData(updatedUser);
        log("Local user state and SharedPreferences updated successfully");
      }

      return 'Profile updated successfully';
    } catch (e) {
      log("Profile update failed: $e");
      return "Profile update failed: ${e.toString()}";
    }
  }

  // Function to set user data in Firestore and local state
  Future<void> setUser(Map<String, dynamic> userData) async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      try {
        await _firestore.collection('Users').doc(userId).set(userData);
        final user = UserModel.fromMap(userData);
        state = user;
        await _saveLocalUserData(user);
      } catch (e) {
        log('Error setting user data: $e');
      }
    }
  }

  // Function to get user data directly from Firestore
  Future<void> getUserData() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      try {
        final userDoc = await _firestore.collection('Users').doc(userId).get();
        if (userDoc.exists) {
          final user = UserModel.fromMap(userDoc.data()!);
          state = user;
          await _saveLocalUserData(user);
        }
      } catch (e) {
        log('Error getting user data: $e');
      }
    }
  }
}

// --------------------[ User Model ]---------------------
class UserModel {
  final String name;
  final String email;
  final String phone;
  final String profilePictureUrl;
  final String about;
  final String role;
  final List<String> favorites;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.profilePictureUrl,
    required this.about,
    required this.role,
    required this.favorites,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      name: data['name'] ?? 'empty',
      email: data['email'] ?? 'empty',
      phone: data['phone'] ?? 'empty',
      profilePictureUrl: data['profilePictureUrl'] ?? 'empty',
      about: data['about'] ?? 'empty',
      role: data['role'] ?? 'empty',
      favorites: List<String>.from(data['favorites'] ?? []),
    );
  }

  UserModel copyWith(
      {String? name,
      String? email,
      String? phone,
      String? profilePictureUrl,
      String? about,
      String? role,
      List<String>? favorites}) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      about: about ?? this.about,
      role: role ?? this.role,
      favorites: favorites ?? this.favorites,
    );
  }
}
