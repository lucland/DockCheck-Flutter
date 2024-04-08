import 'package:dockcheck/utils/theme.dart';
import 'package:dockcheck/utils/ui/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FilePickerWidget extends StatefulWidget {
  final bool showAttachmentIcon;

  const FilePickerWidget({
    Key? key,
    this.showAttachmentIcon = true,
  }) : super(key: key);

  @override
  _FilePickerWidgetState createState() => _FilePickerWidgetState();
}

class _FilePickerWidgetState extends State<FilePickerWidget> {
  String? attachedFileName;

  Future<void> _pickFile() async {
    if (widget.showAttachmentIcon) {
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
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (widget.showAttachmentIcon)
              GestureDetector(
                onTap: () => _pickFile(),
                child: Icon(
                  Icons.attach_file,
                  color: CQColors.slate100,
                ),
              ),
            if (attachedFileName != null)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
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
      ],
    );
  }
}
