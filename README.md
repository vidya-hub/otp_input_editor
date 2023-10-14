# otp_input_editor

A customizable OTP (One Time Password) input field package for Flutter that allows editing from any position within the OTP text fields with Clear and Hide features.

[![Watch the video](https://github.com/vidya-hub/otp_input_editor/assets/59490902/03fc85d2-dfbf-4ccb-8e38-8bc1a550505b)](https://github.com/vidya-hub/otp_input_editor/assets/59490902/d266d638-e890-4725-8ea2-0969833776e5)

### Features

- Supports customization of OTP input field appearance.
- Allows editing of OTP from any position within the input field.
- Provides callback for OTP changes.
- Option to specify OTP length.

### Installation

Add the following line to your `pubspec.yaml` file:

```yaml
dependencies:
  otp_input_editor: ^0.0.5 # Replace with the latest version
```

Run `flutter pub get` to install the package.

## Usage

Import the package:

```dart
import 'package:otp_input_editor/otp_input_editor.dart';
```

Use the `OtpInputEditor` widget in your Flutter app, providing the necessary parameters:

```dart
  OtpInputEditor get _getOtpEditor {
    return OtpInputEditor(
      obscureText: !_showOtp,
      otpLength: 6,
      onOtpChanged: (value) {
        print(value);
        setState(() {
          _otpData = value;
        });
      },
      onInitialization: (OtpInputController otpInputController) {
        setState(() {
          _otpInputController = otpInputController;
        });
      },
      invalid: false,
      otpTextFieldBackgroundColor: Colors.white,
      cursorHeight: 25,
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 2.0,
          spreadRadius: 1.0,
        ),
      ],
      fieldWidth: 40.0,
      fieldHeight: 40.0,
      cursorWidth: 1.5,
      textInputStyle: const TextStyle(
        fontSize: 20.0,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      boxDecoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
  );

```

## Parameters

- `otpLength` (required): The length of the OTP.
- `onOtpChanged` (optional): A callback function that is triggered when the OTP changes.
- `invalid` (optional): Whether the OTP input is in an invalid state.
- `otpTextFieldBackgroundColor` (optional): Background color of the OTP input field.
- `boxShadow` (optional): List of box shadows for styling.
- `fieldWidth` (optional): Width of each OTP input field.
- `fieldHeight` (optional): Height of each OTP input field.
- `cursorWidth` (optional): Width of the cursor in the OTP input field.
- `cursorHeight` (optional): Height of the cursor in the OTP input field.
- `textInputStyle` (optional): Style for the text input.
- `boxDecoration` (optional): Decoration for the OTP input field.
- `obscureText` (optional): To hide and show OTP while entering.
- `onInitialization` (optional): This Callback Gives you the OtpInputController to get more control like clearing and get OTP fields data.

```dart
// Define Your own otpController
  OtpInputController? _otpInputController;
// Assign controller to your local _otpInputController
  onInitialization: (OtpInputController otpInputController) {
    setState(() {
      _otpInputController = otpInputController;
    });
  },
  // You can clear and get OTP fields Data from the controller
   if (_otpInputController != null) {
    _otpInputController!.clear();
    _otpData = _otpInputController?.otp ?? "";
    setState(() {});
  }

```

## Example

```dart
import 'package:flutter/material.dart';
import 'package:otp_input_editor/otp_input_editor.dart';

class OtpInputField extends StatefulWidget {
  const OtpInputField({super.key});

  @override
  State<OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<OtpInputField> {
  String _otpData = "";

  OtpInputController? _otpInputController;
  bool _showOtp = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ..._getOtpText,
              _getOtpEditor,
              _spacer,
              _clearOtpButton,
              _hideOrShowButton,
            ],
          ),
        ),
      ),
    );
  }

  SizedBox get _spacer {
    return const SizedBox(
      height: 5,
    );
  }

  Row get _hideOrShowButton {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
            onPressed: () {
              setState(() {
                _showOtp = !_showOtp;
              });
            },
            child: Row(
              children: _showOtp
                  ? [
                      const Icon(Icons.visibility_off),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text("Hide"),
                      )
                    ]
                  : [
                      const Icon(Icons.visibility),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text("Show"),
                      )
                    ],
            )),
      ],
    );
  }

  Row get _clearOtpButton {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            if (_otpInputController != null) {
              _otpInputController!.clear();
              _otpData = _otpInputController?.otp ?? "";
              setState(() {});
            }
          },
          child: const Text(
            "Clear OTP",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 17,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
    );
  }

  OtpInputEditor get _getOtpEditor {
    return OtpInputEditor(
      obscureText: !_showOtp,
      otpLength: 6,
      onOtpChanged: (value) {
        print(value);
        setState(() {
          _otpData = value;
        });
      },
      onInitialization: (OtpInputController otpInputController) {
        setState(() {
          _otpInputController = otpInputController;
        });
      },
      invalid: false,
      otpTextFieldBackgroundColor: Colors.white,
      cursorHeight: 25,
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 2.0,
          spreadRadius: 1.0,
        ),
      ],
      fieldWidth: 40.0,
      fieldHeight: 40.0,
      cursorWidth: 1.5,
      textInputStyle: const TextStyle(
        fontSize: 20.0,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      boxDecoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }

  AppBar get _appBar {
    return AppBar(
      title: const Text(
        "OTP Input Editor Example",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }

  List<Widget> get _getOtpText {
    return [
      const Text(
        "Entered Otp:",
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(
        height: 10,
      ),
      Text(
        _otpData,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(
        height: 30,
      ),
    ];
  }
}

```

## License

This project is licensed under the [MIT License](LICENSE).

## Issues and Feedback

Please file issues or provide feedback on the [GitHub repository](https://github.com/vidya-hub/otp_input_editor).

---
