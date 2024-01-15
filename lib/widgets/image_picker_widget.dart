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
        bool _hasImage = state.user.picture.isNotEmpty;
        return GestureDetector(
          onTap: () => _showImagePickerDialog(context, state),
          child: Padding(
            padding: const EdgeInsets.only(right: 16, bottom: 8),
            child: _buildImageContainer(_hasImage, state.user.picture),
          ),
        );
      },
    );
  }

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

  Widget _buildImageContainer(bool hasImage, String? imagePath) {
    return Container(
      width: double.infinity,
      height: 300,
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
              File(imagePath ?? ''),
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
    bool _hasImage = state.user.picture.isNotEmpty;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 120, vertical: 20),
          backgroundColor: CQColors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          content: _buildDialogContents(context, state, _hasImage),
        );
      },
    );
  }

  Widget _buildDialogContents(
      BuildContext context, CadastrarState state, bool hasImage) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Identidade',
              style: CQTheme.h2,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Adicione o seu documento aqui',
              style: CQTheme.body2,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            height: 300,
            color: Colors.transparent,
            child: state.user.picture.isNotEmpty
                ? Image.file(
                    File(state.user.picture),
                    fit: BoxFit.cover,
                  )
                : GestureDetector(
                    onTap: () {
                      cubit.pickImage();
                    },
                    child: Center(
                      child: Image.asset(
                        'assets/imgs/rg2.2.png',
                        fit: BoxFit.cover,
                        height: 400,
                        width: 400,
                      ),
                    ),
                  ),
          ),
        ),
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    hasImage ? 'Remover credencial' : 'Adicionar credencial',
                    style: CQTheme.body.copyWith(
                      color: CQColors.white,
                    ),
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
                  style: CQTheme.headLine,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
