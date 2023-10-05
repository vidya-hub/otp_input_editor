# otp_input_editor

A customizable OTP (One Time Password) input field package for Flutter that allows editing from any position within the OTP text fields.

### Features

- Supports customization of OTP input field appearance.
- Allows editing of OTP from any position within the input field.
- Provides callback for OTP changes.
- Option to specify OTP length.

### Installation

Add the following line to your `pubspec.yaml` file:

```yaml
dependencies:
  otp_input_editor: ^0.0.1 # Replace with the latest version
```

Run `flutter pub get` to install the package.

## Usage

Import the package:

```dart
import 'package:otp_input_editor/otp_input_editor.dart';
```

Use the `OtpInputEditor` widget in your Flutter app, providing the necessary parameters:

```dart
OtpInputEditor(
  otpLength: 6,
  onOtpChanged: (String otp) {
    // Handle OTP changes here
  },
  invalid: false,
  otpTextFieldBackgroundColor: Colors.white,
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 2.0,
      spreadRadius: 1.0,
    ),
  ],
  fieldWidth: 40.0,
  fieldHeight: 40.0,
  cursorWidth: 2.0,
  cursorHeight: 30.0,
  textInputStyle: TextStyle(
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

```

### Parameters

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

## Example

```dart
import 'package:flutter/material.dart';
import 'package:otp_input_editor/otp_input_editor.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTP Input Editor Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Input Editor Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Enter OTP:',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            OtpInputEditor(
              otpLength: 6,
              onOtpChanged: (String otp) {
                print("OTP changed: $otp");
              },
              invalid: false,
              otpTextFieldBackgroundColor: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 2.0,
                  spreadRadius: 1.0,
                ),
              ],
              fieldWidth: 40.0,
              fieldHeight: 40.0,
              cursorWidth: 2.0,
              cursorHeight: 30.0,
              textInputStyle: TextStyle(
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
      ),
    );
  }
}

```

## License

This project is licensed under the [MIT License](LICENSE).

## Issues and Feedback

Please file issues or provide feedback on the [GitHub repository](https://github.com/vidya-hub/otp_input_editor).

---
