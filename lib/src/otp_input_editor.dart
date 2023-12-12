import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_input_editor/src/otp_input_controller.dart';

class OtpInputEditor extends StatefulWidget {
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

  final int otpLength;
  final ValueChanged<String>? onOtpChanged;
  final bool invalid;
  final Color? otpTextFieldBackgroundColor;
  final List<BoxShadow>? boxShadow;
  final double fieldWidth;
  final double fieldHeight;
  final double cursorWidth;
  final double cursorHeight;
  final TextStyle? textInputStyle;
  final BoxDecoration? boxDecoration;
  final Function(OtpInputController)? onInitialization;
  final bool obscureText;

  @override
  State<OtpInputEditor> createState() => _OtpInputEditorState();
}

class _OtpInputEditorState extends State<OtpInputEditor> {
  List<TextEditingController> controllers = [];
  List<String> tempValues = [];
  List<FocusNode> focusNodes = [];
  List<FocusNode> rawFocusNodes = [];
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
                child: RawKeyboardListener(
                  focusNode: rawFocusNodes[index],
                  onKey: (value) {
                    if (value.logicalKey.keyLabel == "Backspace" &&
                        value.runtimeType.toString() == 'RawKeyDownEvent') {
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
