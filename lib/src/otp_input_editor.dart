import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  @override
  State<OtpInputEditor> createState() => _OtpInputEditorState();
}

class _OtpInputEditorState extends State<OtpInputEditor> {
  List<TextEditingController> controllers = [];
  List<String> tempValues = [];
  List<FocusNode> focusNodes = [];
  List<FocusNode> rawFocusNodes = [];

  @override
  void initState() {
    setState(() {
      controllers.addAll(
          List.generate(widget.otpLength, (index) => TextEditingController()));
      focusNodes
          .addAll(List.generate(widget.otpLength, (index) => FocusNode()));
      rawFocusNodes
          .addAll(List.generate(widget.otpLength, (index) => FocusNode()));
      tempValues.addAll(List.generate(widget.otpLength, (index) => ""));
    });
    super.initState();
  }

  int testCounter = 1;

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
              margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
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
                      // End
                    },
                    style: widget.textInputStyle,
                    decoration: const InputDecoration(
                      counterText: '',
                      contentPadding: EdgeInsets.all(5.0),
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
  }
}