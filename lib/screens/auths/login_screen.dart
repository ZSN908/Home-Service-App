import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:country_code_picker_plus/country_code_picker_plus.dart';
import 'package:home_service/providers/auth_provider.dart';
import 'package:home_service/utils/alert_utils.dart';
import 'package:home_service/utils/auth_utils.dart';
import 'otp_screen.dart';
import '../../widgets/tiles_cards_buttons.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = '+92';
  String? _completePhoneNumber;
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (_phoneController.text.trim().isEmpty) {
      alert("Please provide a phone number.");
      return;
    } else if (_phoneController.text.trim().length < 10 ||
        _phoneController.text.trim().length > 12) {
      alert("Please provide a valid phone number.");
      return;
    }

    setState(() {
      _completePhoneNumber = AuthUtils.formatPhoneNumber(
          _phoneController.text.trim(), _selectedCountryCode);
    });

    if (_completePhoneNumber != null) {
      try {
        setState(() {
          _isLoading = true;
        });
        final verificationId = await ref
            .read(authProvider.notifier)
            .startPhoneLogin(
                resendOtp: false,
                newRegistration: false,
                phoneNumber: _completePhoneNumber!);

        switch (verificationId) {
          case 'Not registered':
            alert(
                "You are not registered. Please sign up to create an account.");
            break;
          case 'Auto verification':
            alert("Auto Verification successful!");
            break;
          case 'Verification failed':
            alert("Verification failed, Something went wrong.");
            break;
          case 'Timeout':
            alert("Code auto-retrieval timed out.");
            break;
          case 'verification timeout':
            alert("Registration check timed out.");
            break;
          default:
            if (verificationId != null) {
              _navigateTo(verId: verificationId);
            } else {
              alert("Unexpected error: Verification ID is null.");
            }
        }
      } catch (e) {
        alert("An error occurred: $e");
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      alert("Invalid phone number.");
    }
  }

  void alert(String message) {
    AlertUtils.showAlertDialog(
        context: context, title: 'Alert', message: message, buttonName: 'Ok');
  }

  void _navigateTo({required String verId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpScreen(
          registeration: false,
          phone: _completePhoneNumber!,
          verificationId: verId,
          name: '',
          email: '',
          password: '',
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // Show the alert box after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AlertUtils.showAlertDialog(
          context: context,
          title: 'Try this:',
          message: 'Firebase wants billing plan for sending OTP messages, '
              'So i manually added some testing numbers and related otps.\n\n'
              'Try with:\n           +92 321 4567890\n'
              'related otp:\n           123456',
          buttonName: 'Ok');
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
                  vertical: MediaQuery.of(context).size.height * 0.073),
              child: Column(
                children: [
                  Column(
                    children: [
                      // const SizedBox(height: 10),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.012),
                      const Text("Welcome back!",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            // height: 1.9,
                          )),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.0127),
                      const Text(
                        "Please Login to your account",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.037),
                      Opacity(
                        opacity: 0.83,
                        child: Image.asset(
                          height: 87,
                          'hs_assets/images/home_service.png',
                        ),
                      ),
                      const SizedBox(height: 17),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                        showFlag: true,
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
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.013),
                  child: const SizedBox(height: 5),
                ),
                _isLoading
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 7.0),
                        child: Center(
                            child:
                                CircularProgressIndicator(color: Colors.black)),
                      )
                    : CustomButton(
                        title: "Log In",
                        vertpadd: 12,
                        textStyle: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 15.7,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: _handleLogin,
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 35.0),
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
                              text: "Don't have account? ",
                            ),
                            TextSpan(
                              text: "Sign Up",
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacementNamed(
                                      context, '/SignUpScr');
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
