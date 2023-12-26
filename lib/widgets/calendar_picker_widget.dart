import 'package:dockcheck/utils/formatter.dart';
import 'package:dockcheck/utils/theme.dart';
import 'package:dockcheck/utils/ui/ui.dart';
import 'package:dockcheck/widgets/attach_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class CalendarPickerWidget extends StatefulWidget {
  final String title;
  final bool isRequired;
  final TextEditingController controller;
  final void Function(DateTime) onChanged;
  final bool showAttachmentIcon;

  const CalendarPickerWidget({
    Key? key,
    required this.title,
    this.isRequired = false,
    required this.controller,
    required this.onChanged,
    this.showAttachmentIcon = true,
  }) : super(key: key);

  @override
  _CalendarPickerWidgetState createState() => _CalendarPickerWidgetState();
}

class _CalendarPickerWidgetState extends State<CalendarPickerWidget> {
  String? attachedFileName;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      final String fileName = result.files.first.name;
      setState(() {
        attachedFileName = fileName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != '')
            Row(
              children: [
                Flexible(
                  child: Text(
                    widget.title,
                    style: CQTheme.h2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (widget.isRequired)
                  Text(
                    '*',
                    style: CQTheme.h2.copyWith(color: CQColors.danger100),
                  ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: widget.controller,
                  decoration: InputDecoration(
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.showAttachmentIcon)
                          GestureDetector(
                            onTap: () => _pickFile(),
                            child: Icon(
                              Icons.attach_file,
                              color: CQColors.slate100,
                            ),
                          ),
                        const Icon(
                          Icons.calendar_today,
                          color: CQColors.slate100,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                    hintText: widget.title,
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
                      widget.controller.text =
                          Formatter.formatDateTime(selectedDate);
                      widget.onChanged(selectedDate);
                    }
                  },
                ),
                if (attachedFileName != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Arquivo anexado: $attachedFileName',
                      style: CQTheme.h3.copyWith(
                        color: attachedFileName != null
                            ? Colors.green
                            : CQColors.slate100,
                        fontSize: 15,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
