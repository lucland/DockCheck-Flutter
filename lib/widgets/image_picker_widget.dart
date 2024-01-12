import 'dart:convert';
import 'dart:io';

import 'package:dockcheck/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../pages/cadastrar/cubit/cadastrar_cubit.dart';
import '../pages/cadastrar/cubit/cadastrar_state.dart';
import '../utils/ui/colors.dart';

class ImagePickerWidget extends StatelessWidget {
  final CadastrarCubit cubit;

  const ImagePickerWidget({Key? key, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CadastrarCubit, CadastrarState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => _showImagePickerDialog(context, state),
          child: Padding(
            padding: const EdgeInsets.only(right: 16, bottom: 8),
            child: _buildImageContainer(base64ToFile(state.user.picture)),
          ),
        );
      },
    );
  }

  //function to convert base64 string to XFile
  XFile? base64ToFile(String base64String) {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      var file = File(fileName);
      file.writeAsBytesSync(base64Decode(base64String));
      return XFile(file.path);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Widget _buildImageContainer(XFile? pickedImage) {
    bool hasImage = pickedImage != null;

    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: hasImage ? Colors.transparent : CQColors.iron80,
          width: 1.0,
        ),
      ),
      child: hasImage
          ? Image.file(
              File(pickedImage.path),
              fit: BoxFit.cover,
            )
          : const Center(
              child: Icon(
                Icons.document_scanner_outlined,
                color: CQColors.iron80,
                size: 45,
              ),
            ),
    );
  }

  void _showImagePickerDialog(BuildContext context, CadastrarState state) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 120, vertical: 20),
          backgroundColor: CQColors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
          content: _buildDialogContents(context, state),
        );
      },
    );
  }

  Widget _buildDialogContents(BuildContext context, CadastrarState state) {
    bool hasImage = state.user.picture.isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ... other dialog contents
        GestureDetector(
          onTap: () async {
            if (!hasImage) {
              cubit.pickImage();
            } else {
              cubit.removeImage();
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: CQColors.iron100),
                color: CQColors.iron100,
              ),
              child: Center(
                child: Text(
                  hasImage ? 'Remover credencial' : 'Adicionar credencial',
                  style: CQTheme.h3.copyWith(
                    color: CQColors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: CQColors.iron100),
                color: Colors.transparent,
              ),
              child: const Center(
                child: Text(
                  'Salvar',
                  style: CQTheme.h3,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
