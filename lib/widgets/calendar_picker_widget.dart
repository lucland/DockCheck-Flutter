import 'package:cripto_qr_googlemarine/utils/formatter.dart';
import 'package:cripto_qr_googlemarine/utils/theme.dart';
import 'package:cripto_qr_googlemarine/utils/ui/ui.dart';
import 'package:flutter/material.dart';

class CalendarPickerWidget extends StatelessWidget {
  final String title;
  final bool isRequired;
  final TextEditingController controller;
  final void Function(DateTime) onChanged;

  const CalendarPickerWidget(
      {Key? key,
      required this.title,
      this.isRequired = false,
      required this.controller,
      required this.onChanged})
      : super(key: key);

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
              controller: controller,
              decoration: InputDecoration(
                suffixIcon: const Icon(
                  Icons.calendar_today,
                  color: CQColors.slate100,
                ),
                hintText: title,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: CQColors.slate100,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: CQColors.slate100,
                    width: 1.0,
                  ),
                ),
              ),
              readOnly: true,
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (selectedDate != null) {
                  controller.text = Formatter.formatDateTime(selectedDate);
                  onChanged(selectedDate);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
