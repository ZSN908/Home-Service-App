import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker_plus/country_code_picker_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '/providers/auth_provider.dart';
import '/screens/auths/otp_screen.dart';
import '/widgets/custom_text_field.dart';
import '/widgets/tiles_cards_buttons.dart';
import '/utils/alert_utils.dart';
import '/utils/auth_utils.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool agreeTerms = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  String _selectedCountryCode = '+92';
  String? _completePhoneNumber;
  bool _isLoading = false;

  Future<void> _handleSignUp() async {
    setState(() {
      _completePhoneNumber = AuthUtils.formatPhoneNumber(
          _phoneController.text.trim(), _selectedCountryCode);
    });

    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      alert("All fields are required. Please fill all fields! ");

      return;
    } else if (_phoneController.text.trim().length < 10 ||
        _phoneController.text.trim().length > 12) {
      alert("Please provide a valid phone number.");
      return;
    }

    if (!agreeTerms) {
      alert("Please agree to the Terms and Conditions.");
      return;
    }

    if (!AuthUtils.isValidEmail(_emailController.text)) {
      alert("Invalid email address!");
      return;
    }

    if (_passwordController.text.length < 6) {
      alert("Password must be at least 6 characters!");
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      alert("Passwords do not match.");
      return;
    }

    try {
      if (_completePhoneNumber != null &&
          AuthUtils.isValidPhoneNumber(_completePhoneNumber!)) {
        setState(() {
          _isLoading = true;
        });
        final verificationId = await ref
            .read(authProvider.notifier)
            .startPhoneLogin(
                resendOtp: false,
                newRegistration: true,
                phoneNumber: _completePhoneNumber!);

        switch (verificationId) {
          case 'Not registered':
            alert("You are already registered.");
            break;
          case 'Auto verification':
            alert("Auto Verification successful!");
            break;
          case 'Verification failed':
            alert(
                "Verification failed, Something went wrong, try again later.");
            break;
          case 'Timeout':
            alert("Code auto-retrieval timed out.");
            break;
          case 'verification timeout':
            alert("Registration check timed out");
            break;
          default:
            if (verificationId != null) {
              _navigateTo(verId: verificationId);
            } else {
              alert("Unexpected error: Verification ID is null.");
            }
        }
      } else {
        alert("Please enter a valid phone number.");
        return;
      }
    } catch (e) {
      alert("Signup failed: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateTo({required String verId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpScreen(
          registeration: true,
          phone: _completePhoneNumber!,
          verificationId: verId,
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        ),
      ),
    );
  }

  void alert(String message) {
    AlertUtils.showAlertDialog(
        context: context, title: 'Alert', message: message, buttonName: 'Ok');
  }

  @override
  void initState() {
    super.initState();

    // Show the alert box after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      alert(
          'Firebase messages are not free, So only those testing numbers can sign up '
          'that were manually added at Firebase Phone Auth!');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(19.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.067),
              child: const Center(
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextField(
                  controller: _nameController,
                  hintText: 'Username',
                ),
                buildTextField(
                  controller: _emailController,
                  hintText: 'Email',
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    children: [
                      CountryCodePicker(
                        onChanged: (country) {
                          setState(() {
                            _selectedCountryCode = country.dialCode;
                          });
                        },
                        initialSelection: 'PK',
                        favorite: const ['+92'],
                        showFlag: false,
                        textStyle:
                            const TextStyle(color: Colors.blue, fontSize: 14),
                        showCountryOnly: false,
                        showDropDownButton: false,
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: 'Enter mobile number',
                            hintStyle: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                color: Colors.grey.withOpacity(0.5),
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                buildTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: _passwordVisible ? false : true,
                  icon: _passwordVisible
                      ? Icons.remove_red_eye_rounded
                      : Icons.visibility_off,
                  onIconPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
                buildTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Re-enter Password',
                  obscureText: _confirmPasswordVisible ? false : true,
                  icon: _confirmPasswordVisible
                      ? Icons.remove_red_eye_rounded
                      : Icons.visibility_off,
                  onIconPressed: () {
                    setState(() {
                      _confirmPasswordVisible = !_confirmPasswordVisible;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 17.0),
                  child: CheckboxListTile(
                    value: agreeTerms,
                    activeColor: Colors.black,
                    onChanged: (value) {
                      setState(() {
                        agreeTerms = value!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      "I agree to the Terms and Conditions",
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                _isLoading
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 7.0),
                        child: Center(
                            child:
                                CircularProgressIndicator(color: Colors.black)),
                      )
                    : CustomButton(
                        title: "Sign Up",
                        vertpadd: 12,
                        textStyle: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 15.7,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: _handleSignUp,
                      ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                            color: Colors.black.withOpacity(0.7),
                            fontSize: 17.5,
                          )),
                          children: <TextSpan>[
                            const TextSpan(
                              text: "Have an account? ",
                            ),
                            TextSpan(
                              text: "Sign In",
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacementNamed(
                                      context, '/LoginScr');
                                  // Navigator.pop(context);
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
