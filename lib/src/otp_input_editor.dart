import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_input_editor/src/otp_input_controller.dart';

class OtpInputEditor extends StatefulWidget {
  /// Constructor for OtpInputEditor with optional parameters
  const OtpInputEditor({
    super.key,
    this.otpLength = 4,
    this.onOtpChanged,
    this.invalid = false,
    this.otpTextFieldBackgroundColor,
    this.boxShadow,
    this.fieldWidth = 50,
    this.fieldHeight = 50,
    this.cursorWidth = 3,
    this.cursorHeight = 24,
    this.textInputStyle,
    this.boxDecoration,
    this.onInitialization,
    this.obscureText = true,
  });

  /// Number of OTP fields, default is 4
  final int otpLength;

  /// Callback when OTP value changes
  final ValueChanged<String>? onOtpChanged;

  /// Indicates if the entered OTP is invalid
  final bool invalid;

  /// Background color for OTP text fields
  final Color? otpTextFieldBackgroundColor;

  /// Box shadow for the OTP text fields
  final List<BoxShadow>? boxShadow;

  /// Width of each OTP text field, default is 50
  final double fieldWidth;

  /// Height of each OTP text field, default is 50
  final double fieldHeight;

  /// Width of the cursor in OTP text fields, default is 3
  final double cursorWidth;

  /// Height of the cursor in OTP text fields, default is 24
  final double cursorHeight;

  /// Text style for the OTP input
  final TextStyle? textInputStyle;

  /// Custom box decoration for the OTP text fields
  final BoxDecoration? boxDecoration;

  /// Callback after initialization
  final Function(OtpInputController)? onInitialization;

  /// Whether to obscure the text in OTP fields, default is true
  final bool obscureText;

  @override
  State<OtpInputEditor> createState() => _OtpInputEditorState();
}

class _OtpInputEditorState extends State<OtpInputEditor> {
  /// Controllers for each OTP text field
  List<TextEditingController> controllers = [];

  /// Temporary values for each OTP text field
  List<String> tempValues = [];

  /// Focus nodes for each OTP text field
  List<FocusNode> focusNodes = [];

  /// Raw focus nodes for keyboard listeners
  List<FocusNode> rawFocusNodes = [];

  /// Controller for managing OTP input
  OtpInputController? _otpInputController;

  @override
  void initState() {
    setState(() {
      controllers.addAll(
        List.generate(
          widget.otpLength,
          (index) => TextEditingController(),
        ),
      );

      focusNodes
          .addAll(List.generate(widget.otpLength, (index) => FocusNode()));
      rawFocusNodes
          .addAll(List.generate(widget.otpLength, (index) => FocusNode()));
      tempValues.addAll(List.generate(widget.otpLength, (index) => ""));
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _otpInputController = OtpInputController(controllers: controllers);
      if (widget.onInitialization != null) {
        widget.onInitialization!(_otpInputController!);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    for (var element in controllers) {
      element.dispose();
    }
    for (var element in focusNodes) {
      element.dispose();
    }
    for (var element in rawFocusNodes) {
      element.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          widget.otpLength,
          (index) => Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
              decoration: widget.boxDecoration ??
                  BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: widget.otpTextFieldBackgroundColor,
                    boxShadow: widget.boxShadow,
                  ),
              width: widget.fieldWidth,
              height: widget.fieldHeight,
              child: Center(
                child: KeyboardListener(
                  focusNode: rawFocusNodes[index],
                  onKeyEvent: (value) {
                    if (value.logicalKey.keyLabel == "Backspace" &&
                        value.runtimeType.toString() == 'KeyUpEvent') {
                      if (controllers[index].text.isEmpty && index != 0) {
                        onChanged();
                        FocusScope.of(context)
                            .requestFocus(focusNodes[index - 1]);
                      }
                    }
                  },
                  child: TextFormField(
                    key: Key("otp-${index + 1}"),
                    obscureText: widget.obscureText,
                    focusNode: focusNodes[index],
                    controller: controllers[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 2,
                    onTap: () {
                      controllers[index].selection = TextSelection.fromPosition(
                        TextPosition(
                          offset: controllers[index].text.length,
                        ),
                      );
                    },
                    cursorColor: Theme.of(context).hintColor,
                    cursorWidth: widget.cursorWidth,
                    cursorHeight: widget.cursorHeight,
                    cursorRadius: const Radius.circular(20),
                    onChanged: (value) {
                      onChanged();
                      TextEditingController controller = controllers[index];
                      if (index + 1 == widget.otpLength && value.isNotEmpty) {
                        FocusManager.instance.primaryFocus?.unfocus();
                        onChanged();
                      }
                      if (value.isNotEmpty &&
                          value.length <= 1 &&
                          index != widget.otpLength - 1) {
                        onChanged();
                        FocusScope.of(context)
                            .requestFocus(focusNodes[index + 1]);
                        return;
                      }
                      if (value.length == 2) {
                        controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: value.length - 1),
                        );
                        controller.clear();
                        controller.value = TextEditingValue(
                          text: value.split("").last,
                          selection: TextSelection.fromPosition(
                            const TextPosition(
                              offset: 1,
                            ),
                          ),
                        );
                        setState(() {});
                        if (index != widget.otpLength - 1) {
                          onChanged();
                          FocusScope.of(context)
                              .requestFocus(focusNodes[index + 1]);
                        }
                        onChanged();
                      }
                      if (Platform.isIOS && value.isEmpty && index != 0) {
                        onChanged();
                        FocusScope.of(context)
                            .requestFocus(focusNodes[index - 1]);
                      }
                      // End
                    },
                    style: widget.textInputStyle,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Method to handle changes in the OTP input
  void onChanged() {
    String data = controllers.map((e) => e.text).join();
    if (widget.onOtpChanged != null) {
      widget.onOtpChanged!(data);
    }
    if (_otpInputController != null) {
      _otpInputController!.setOtp = data;
      setState(() {});
    }
  }
}
