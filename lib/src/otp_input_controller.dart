import 'package:flutter/material.dart';

class OtpInputController extends ChangeNotifier {
  final List<TextEditingController> _controllers;
  String _otp = "";
  set setOtp(String otp) {
    _otp = otp;
    notifyListeners();
  }

  String get otp => _otp;
  OtpInputController({List<TextEditingController> controllers = const []})
      : _controllers = controllers;
  // String get otp => controllers.map((e) => e.text.trim()).join('');
  void clear() {
    for (var element in _controllers) {
      FocusManager.instance.primaryFocus?.unfocus();
      element.clear();
    }
    setOtp = "";
    notifyListeners();
  }
}
