import 'package:flutter/material.dart';
import 'package:otp_input_editor/otp_input_editor.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTP INPUT FIELD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: OtpInputField(),
    );
  }
}

class OtpInputField extends StatelessWidget {
  OtpInputField({super.key});
  String otpData = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "OTP Input Editor",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: StatefulBuilder(builder: (
            BuildContext context,
            StateSetter setState,
          ) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      text: "Entered Otp:",
                      children: [
                        TextSpan(
                          text: otpData,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  OtpInputEditor(
                    otpLength: 6,
                    onOtpChanged: (String otp) {
                      setState(() => otpData = otp);
                    },
                    invalid: false,
                    otpTextFieldBackgroundColor: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 2.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                    fieldWidth: 40.0,
                    fieldHeight: 40.0,
                    cursorWidth: 2.0,
                    cursorHeight: 20.0,
                    textInputStyle: const TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    boxDecoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ],
              ),
            );
          }),
        ));
  }
}
