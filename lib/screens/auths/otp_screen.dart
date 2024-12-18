import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:google_fonts/google_fonts.dart';
import '/widgets/tiles_cards_buttons.dart';
import '/providers/auth_provider.dart';
import '/providers/items_provider.dart';
import '/utils/alert_utils.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final bool registeration;
  final String phone;
  final String verificationId;
  final String name;
  final String email;
  final String password;
  const OtpScreen({
    super.key,
    required this.registeration,
    required this.phone,
    required this.verificationId,
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  late String verificationId = widget.verificationId;
  String otpCode = '';
  int _resendCountdown = 50;
  late Timer _timer;
  bool isLoading = false;
  bool isResendEnabled = true;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startCountdown() {
    setState(() {
      _resendCountdown = 50;
      isResendEnabled = false;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown == 0) {
        setState(() {
          isResendEnabled = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _resendCountdown--;
        });
      }
    });
  }

  Future<void> _resendOtp() async {
    if (!isResendEnabled) return;
    try {
      setState(() {
        isResendEnabled = false; // Disable immediately
        isLoading = true;
      });
      // Trigger resend logic
      final verifId = await ref.read(authProvider.notifier).startPhoneLogin(
          resendOtp: true, newRegistration: false, phoneNumber: widget.phone);
      switch (verifId) {
        case 'Auto verification':
          alert("Auto verification", "Auto Verification successful!");
          break;
        case 'Verification failed':
          alert(
              "Verification failed", "Something went wrong, try again later.");
          break;
        case 'Timeout':
          alert("Timeout", "Code auto-retrieval timed out.");
          break;
        case 'verification timeout':
          alert("verification timeout", "Please try again!");
          break;
        default:
          if (verifId != null) {
            setState(() {
              verificationId = verifId;
            });
            // Restart countdown
            startCountdown();
          } else {
            alert("Error", "Unexpected error: Verification ID is null.");
          }
      }
    } catch (err) {
      alert("Error:", "$err");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _submitOtp() async {
    if (otpCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid 6-digit OTP")),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      String result = await ref.read(authProvider.notifier).otpValidation(
            otp: otpCode,
            verifId: verificationId,
            registeration: widget.registeration,
            role: 'user',
            name: widget.name,
            email: widget.email,
            phone: widget.phone,
            ref: ref,
          );
      if (result == 'Validation successful' ||
          result == 'Registration successful') {
        alert("Welcome", result);

        // Fetch and set the initial data
        final servicePeopleState = ref.watch(servicePeopleProvider);
        final showcaseState = ref.watch(showcaseProvider);
        final packagesState = ref.watch(packagesProvider);

        if (servicePeopleState.isEmpty ||
            showcaseState.isEmpty ||
            packagesState.isEmpty) {
          await fetchInitialCollections(ref);
        }

        _goToScr('/');
      } else {
        alert("Alert", result);
      }
    } catch (err) {
      alert("Invalid OTP", "$err");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchInitialCollections(WidgetRef ref) async {
    await ref
        .read(servicePeopleProvider.notifier)
        .fetchAndSetServicePeopleCollection();
    await ref.read(showcaseProvider.notifier).fetchAndSetShowcaseCollection();
    await ref.read(packagesProvider.notifier).fetchAndSetPackagesCollection();
  }

  void _goToScr(String scrIndex) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      scrIndex,
      (Route<dynamic> route) => false,
    );
  }

  void alert(String heading, String message) {
    AlertUtils.showAlertDialog(
        context: context, title: heading, message: message, buttonName: 'Ok');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(19.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.073),
              child: const Column(
                children: [
                  Text(
                    "OTP Verification",
                    style: TextStyle(
                      fontSize: 32,
                      height: 1.7,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "We have sent OTP to your mobile number",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.017,
                  ),
                  child: PinCodeTextField(
                    appContext: context,
                    length: 6,
                    // onChanged: (value) => otpCode = value,
                    onCompleted: (value) {
                      setState(() {
                        otpCode = value;
                      });
                      // _submitOtp();
                    },
                    keyboardType: TextInputType.number,
                    textStyle: const TextStyle(color: Colors.black),
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderWidth: 0.8,
                      activeBorderWidth: 0.8,
                      selectedBorderWidth: 0.8,
                      inactiveBorderWidth: 0.8,
                      borderRadius: BorderRadius.circular(9),
                      errorBorderColor: Colors.red,
                      fieldHeight: 47,
                      fieldWidth: 47,
                      activeColor: Colors.black,
                      inactiveColor: Colors.black45,
                      selectedColor: Colors.grey.withOpacity(0.1),
                      activeFillColor: Colors.grey.withOpacity(0.1),
                      inactiveFillColor: Colors.grey.withOpacity(0.1),
                      selectedFillColor: Colors.grey.withOpacity(0.1),
                    ),
                    enableActiveFill: true,
                    cursorColor: Colors.black,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: isResendEnabled
                            ? TextSpan(
                                style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                    color: Colors.grey.withOpacity(0.5),
                                    fontSize: 18.5,
                                  ),
                                ),
                                children: <TextSpan>[
                                  const TextSpan(
                                    text: "Didn't receive OTP? ",
                                  ),
                                  TextSpan(
                                    text: "Resend OTP",
                                    style: const TextStyle(
                                        color: Colors.orange,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w600),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _resendOtp();
                                      },
                                  )
                                ],
                              )
                            : TextSpan(
                                text: "Try again in $_resendCountdown seconds",
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 18,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                isLoading
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 7.0),
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.black),
                        ),
                      )
                    : CustomButton(
                        title: "Submit",
                        vertpadd: 12,
                        textStyle: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 15.7,
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: _submitOtp,
                      ),
              ],
            ),
            const SizedBox(height: 23),
          ],
        ),
      ),
    );
  }
}
