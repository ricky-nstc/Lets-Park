import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lets_park/services/user_services.dart';

class OTPVerification extends StatefulWidget {
  final String phoneNumber;
  const OTPVerification({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<OTPVerification> createState() => OTPVerificationState();
}

class OTPVerificationState extends State<OTPVerification> {
  String pinput = "";
  String verifId = "";
  bool visible = false;
  bool canResend = false;
  String message = "";
  final controller = TextEditingController();
  @override
  initState() {
    verifyPhoneNumber();
    wait();
    super.initState();
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OTP Verification"),
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                "Verify phone number",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Enter the six digit code sent to the number",
                style: TextStyle(
                  color: Colors.black26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.phoneNumber,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              buildPinput(),
              const SizedBox(height: 5),
              Visibility(
                visible: visible,
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "Didn't receive the code?",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: canResend
                    ? () async {
                        verifyPhoneNumber();
                        await wait();
                      }
                    : null,
                child: canResend
                    ? const Text(
                        "Resend code",
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      )
                    : const Text(
                        "Resend code",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Pinput buildPinput() {
    final defaultPinTheme = PinTheme(
      width: 40,
      height: 40,
      textStyle: const TextStyle(
        fontSize: 15,
        color: Color.fromRGBO(
          30,
          60,
          87,
          1,
        ),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Pinput(
      length: 6,
      androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsRetrieverApi,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: true,
      onCompleted: (pin) async {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        try {
          await FirebaseAuth.instance.currentUser!
              .linkWithCredential(PhoneAuthProvider.credential(
            verificationId: verifId,
            smsCode: pin,
          ));
          await UserServices.updateUserPhoneNumber(widget.phoneNumber);
          Navigator.pop(context);
          Navigator.pop(context, "non-null-callback");
        } on FirebaseAuthException catch (e) {
          setState(() {
            if (e.code == 'invalid-verification-code') {
              message = "Invalid verification code.";
            } else if (e.code == 'credential-already-in-use') {
              message = "Phone number is already linked to different account.";
            } else {
              debugPrint("Err: ${e.code}:${e.message}");
            }
            visible = true;
          });

          Navigator.pop(context);
        }
      },
    );
  }

  verifyPhoneNumber() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      timeout: const Duration(minutes: 2),
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) async {
        setState(() {
          if (e.code == 'invalid-verification-code') {
            message = "Invalid verification code.";
          } else if (e.code == 'credential-already-in-use') {
            message = "Phone number is already linked to different account.";
          } else {
            debugPrint("Err: ${e.code}");
          }
          visible = true;
        });
      },
      codeSent: (String verificationId, int? resendToken) {
        verifId = verificationId;
        debugPrint("Code sent!");
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  Future<void> wait() async {
    if (mounted) {
      setState(() {
        canResend = false;
      });

      await Future.delayed(
        const Duration(seconds: 20),
      );

      setState(() {
        canResend = true;
      });
    }
  }
}
