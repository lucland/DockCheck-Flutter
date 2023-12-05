import 'dart:io';

import 'package:cripto_qr_googlemarine/utils/ui/colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AttachFileWidget extends StatefulWidget {
  final bool longName;

  const AttachFileWidget({Key? key, this.longName = true}) : super(key: key);

  @override
  _AttachFileWidgetState createState() => _AttachFileWidgetState();
}

class _AttachFileWidgetState extends State<AttachFileWidget> {
  FilePickerResult? result;
  String? _fileName;
  PlatformFile? pickedFile;
  bool isLoading = false;
  File? fileToDisplay;

  void filePicked() async {
    try {
      setState(() {
        isLoading = true;
      });

      result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result != null) {
        _fileName = result!.files.first.name;
        pickedFile = result!.files.first;
        fileToDisplay = File(pickedFile!.path.toString());

        print('File name $_fileName');
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 5),
            child: GestureDetector(
              onTap: () {
                filePicked();
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _fileName != null
                        ? CQColors.success100
                        : CQColors.slate100,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                  color: CQColors.white,
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Icon(
                            Icons.attach_file,
                            color: _fileName != null
                                ? CQColors.success100
                                : CQColors.iron100,
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              _fileName != null
                                  ? _fileName!
                                  : (widget.longName
                                      ? 'ANEXAR ARQUIVO'
                                      : 'ANEXAR'),
                              style: TextStyle(
                                color: _fileName != null
                                    ? CQColors.success100
                                    : CQColors.iron100,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
