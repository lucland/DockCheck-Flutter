import 'dart:convert';
import 'package:dockcheck/pages/cadastrar/cubit/cadastrar_cubit.dart';
import 'package:dockcheck/pages/cadastrar/cubit/cadastrar_state.dart';
import 'package:dockcheck/utils/theme.dart';
import 'package:dockcheck/utils/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImagePickerWidget extends StatelessWidget {
  final CadastrarCubit cubit;

  const ImagePickerWidget({Key? key, required this.cubit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CadastrarCubit, CadastrarState>(
      builder: (context, state) {
        bool hasImage = state.picture.base64.isNotEmpty;
        return GestureDetector(
          onTap: () => _showImagePickerDialog(context, state),
          child: Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 8),
            child: _buildImageContainer(hasImage, state),
          ),
        );
      },
    );
  }

  Widget _buildImageContainer(bool hasImage, CadastrarState state) {
    return Column(
      children: [
        Container(
          //infinity width
          width: double.infinity,
          height: 280,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(
              color: hasImage ? Colors.transparent : CQColors.iron80,
              width: 1.0,
            ),
          ),
          child: (hasImage && state.picture.base64.isNotEmpty)
              ? Image.memory(
                  base64Decode(state.picture.base64),
                  fit: BoxFit.cover,
                )
              : const Center(
                  child: Icon(
                    Icons.document_scanner_outlined,
                    color: CQColors.iron80,
                    size: 45,
                  ),
                ),
        ),
      ],
    );
  }

  void _showImagePickerDialog(BuildContext context, CadastrarState state) {
    bool hasImage = state.picture.base64.isNotEmpty;

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
          content: _buildDialogContents(context, state, hasImage),
        );
      },
    );
  }

  Widget _buildDialogContents(
      BuildContext context, CadastrarState state, bool hasImage) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Foto do funcionário',
              style: CQTheme.body,
            ),
            const Text(
              'Adicione uma foto do funcionário para identificação',
              style: CQTheme.body,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Container(
                color: Colors.transparent,
                child: hasImage
                    ? _buildImageContainer(hasImage, state)
                    : GestureDetector(
                        onTap: () {
                          cubit.pickImage();
                          Navigator.pop(context);
                        },
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: CQColors.iron80,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(80.0),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: CQColors.iron80,
                                size: 45,
                              ),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (!hasImage) {
                  await cubit.pickImage();
                } else {
                  cubit.removeImage();
                }
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                        color: hasImage
                            ? CQColors.danger100
                            : CQColors.iron100),
                    color: hasImage ? CQColors.danger100 : CQColors.iron100,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        hasImage ? 'Remover' : 'Adicionar imagem',
                        style: CQTheme.body.copyWith(
                          color: CQColors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
