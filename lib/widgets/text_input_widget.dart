import 'package:dockcheck/utils/theme.dart';
import 'package:dockcheck/utils/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInputWidget extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isRequired;
  final bool isID;
  final bool isPassword;

  final void Function(String)? onChanged;

  const TextInputWidget({
    Key? key,
    this.title = '',
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isRequired = false,
    this.isID = false,
    this.onChanged,
    this.isPassword = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != '')
            Row(
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: CQTheme.h2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isRequired)
                  Text(
                    '*',
                    style: CQTheme.h2.copyWith(color: CQColors.danger100),
                  ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 11.5),
                hintText: title,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: CQColors.iron100,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: CQColors.iron100,
                    width: 1,
                  ),
                ),
              ),
              cursorColor: CQColors.iron100,
              keyboardType: keyboardType,
              controller: controller,
              onChanged: onChanged,
              obscureText: isPassword,
              inputFormatters: isID
                  ? [
                      IDInputFormatter(),
                      LengthLimitingTextInputFormatter(12),
                    ]
                  : [],
            ),
          ),
        ],
      ),
    );
  }
}

class IDInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final newTextLength = newValue.text.length;
    int selectionIndex = newValue.selection.end;

    if (newTextLength >= oldValue.text.length) {
      if (newTextLength == 2 || newTextLength == 6) {
        newValue = TextEditingValue(
          text: '${newValue.text}.',
          selection: TextSelection.collapsed(offset: selectionIndex + 1),
        );
      }
      if (newTextLength == 10) {
        newValue = TextEditingValue(
          text: '${newValue.text}-',
          selection: TextSelection.collapsed(offset: selectionIndex + 1),
        );
      }
    }

    return newValue;
  }
}
