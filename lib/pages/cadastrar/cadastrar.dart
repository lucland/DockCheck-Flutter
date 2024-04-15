import 'dart:io';
import 'package:dockcheck/pages/cadastrar/cubit/cadastrar_cubit.dart';
import 'package:dockcheck/pages/cadastrar/cubit/cadastrar_state.dart';
import 'package:dockcheck/utils/theme.dart';
import 'package:dockcheck/utils/ui/colors.dart';
import 'package:dockcheck/utils/ui/strings.dart';
import 'package:dockcheck/widgets/text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CadastrarModal extends StatefulWidget {
    final String title;

    const CadastrarModal({
        super.key,
        required this.title,
    });

    @override
    _CadastrarModalState createState() => _CadastrarModalState();
}

class _CadastrarModalState extends State<CadastrarModal> {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _selectedImage; // Guarda a imagem selecionada

    Future<void> _pickImage() async {
        final pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);
        if (pickedFile != null) {
            setState(() {
                _selectedImage = pickedFile;
            });
        }
    }

    @override
    Widget build(BuildContext context) {
        return BlocBuilder<CadastrarCubit, CadastrarState>(
            builder: (context, state) {
                return Container(
                    decoration: BoxDecoration(
                        color: CQColors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8.0,
                                offset: Offset(0, 2),
                            ),
                        ],
                    ),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(
                                    widget.title,
                                    style: CQTheme.h2,
                                ),
                                SizedBox(height: 16.0),
                                Expanded(
                                    child: SingleChildScrollView(
                                        child: Column(
                                            children: [
                                                Divider(),
                                                TextInputWidget(
                                                    title: CQStrings.nome,
                                                    isRequired: true,
                                                    controller: TextEditingController(text: ''),
                                                    onChanged: (text) {},
                                                ),
                                                Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                        Expanded(
                                                            flex: 6,
                                                            child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                    TextInputWidget(
                                                                        isRequired: true,
                                                                        title: CQStrings.email,
                                                                        controller: TextEditingController(text: ''),
                                                                        onChanged: (text) {},
                                                                    ),
                                                                    Column(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                          TextInputWidget(
                                                                                                                    title: CQStrings.cpf,
                                                                                                                    controller: TextEditingController(text: ''),
                                                                                                                    onChanged: (text) {},
                                                                                                                    keyboardType: TextInputType.number,
                                                                                                                    isRequired: true,
                                                                                                                ),
                                                                            Text('Tipo sanguíneo', style: CQTheme.h2),
                                                                            Padding(
                                                                                padding: const EdgeInsets.only(top: 8, left: 16, bottom: 8, right: 16),
                                                                                child: DropdownButtonFormField<String>(
                                                                                    decoration: InputDecoration(
                                                                                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11.5),
                                                                                        hintText: 'Tipo Sanguíneo',
                                                                                        border: OutlineInputBorder(
                                                                                            borderRadius: BorderRadius.circular(8),
                                                                                            borderSide: const BorderSide(color: CQColors.slate100, width: 1),
                                                                                        ),
                                                                                        focusedBorder: OutlineInputBorder(
                                                                                            borderRadius: BorderRadius.circular(8),
                                                                                            borderSide: const BorderSide(color: CQColors.slate100, width: 1),
                                                                                        ),
                                                                                    ),
                                                                                    value: 'A+',
                                                                                    onChanged: (String? newValue) {},
                                                                                    items: [
                                                                                        'A+',
                                                                                        'A-',
                                                                                        'B+',
                                                                                        'B-',
                                                                                        'AB+',
                                                                                        'AB-',
                                                                                        'O+',
                                                                                        'O-',
                                                                                    ].map<DropdownMenuItem<String>>((String value) {
                                                                                        return DropdownMenuItem<String>(
                                                                                            value: value,
                                                                                            child: Text(value),
                                                                                        );
                                                                                    }).toList(),
                                                                                ),
                                                                            ),
                                                                        ],
                                                                    ),
                                                                  
                                                                ],
                                                            ),
                                                        ),
                                                        Expanded(
                                                            flex: 4,
                                                            child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                children: [
                                                                    Row(
                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                        children: [
                                                                            Padding(
                                                                                padding: const EdgeInsets.only(bottom: 8.0),
                                                                                child: Text(
                                                                                    'Foto',
                                                                                    style: CQTheme.h2,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                ),
                                                                            ),
                                                                            Padding(
                                                                                padding: const EdgeInsets.only(left: 2.0),
                                                                                child: Text(
                                                                                    '*',
                                                                                    style: CQTheme.h2.copyWith(color: CQColors.danger100),
                                                                                ),
                                                                            ),
                                                                        ],
                                                                    ),
                                                                    GestureDetector(
                                                                        onTap: _pickImage,
                                                                        child: Padding(
                                                                            padding: const EdgeInsets.only(right: 12),
                                                                            child: Container(
                                                                                height: 280,
                                                                                decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(4),
                                                                                    color: Colors.transparent,
                                                                                    border: Border.all(color: Colors.grey, width: 1.0),
                                                                                ),
                                                                                child: _selectedImage != null
                                                                                    ? Image.file(
                                                                                        File(_selectedImage!.path),
                                                                                        fit: BoxFit.cover,
                                                                                    )
                                                                                    : Center(
                                                                                        child: Icon(
                                                                                            Icons.camera_alt,
                                                                                            color: CQColors.iron100,
                                                                                        ),
                                                                                    ),
                                                                            ),
                                                                        ),
                                                                    ),
                                                                ],
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                                Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      TextInputWidget(
                                                title: CQStrings.funcao,
                                                controller: TextEditingController(text: ''),
                                                onChanged: (text) {},
                                                isRequired: true,
                                                                                                                    ),
                                                        Text('Adicionar Beacon', style: CQTheme.h2),
                                                        Padding(
                                                            padding: const EdgeInsets.only(top: 8, left: 16, bottom: 8, right: 16),
                                                            child: DropdownButtonFormField<String>(
                                                                decoration: InputDecoration(
                                                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11.5),
                                                                    hintText: 'Adicionar Beacon',
                                                                    border: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.circular(8),
                                                                        borderSide: const BorderSide(color: CQColors.slate100, width: 1),
                                                                    ),
                                                                    focusedBorder: OutlineInputBorder(
                                                                        borderRadius: BorderRadius.circular(8),
                                                                        borderSide: const BorderSide(color: CQColors.slate100, width: 1),
                                                                    ),
                                                                ),
                                                                value: 'item 1',
                                                                onChanged: (String? newValue) {},
                                                                items: [
                                                                    'item 1',
                                                                    'item 2',
                                                                    'item 3',
                                                                    'item 4',
                                                                    'item 5',
                                                                    'item 6',
                                                                    'item 7',
                                                                    'item 8',
                                                                ].map<DropdownMenuItem<String>>((String value) {
                                                                    return DropdownMenuItem<String>(
                                                                        value: value,
                                                                        child: Text(value),
                                                                    );
                                                                }).toList(),
                                                            ),
                                                        ),
                                                    ],
                                                ),
                                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8),
                                    child: Column(
                                        children: [
                                            
                                            TextInputWidget(
                                                                        title: 'Aprovado por',
                                                                        isRequired: true,
                                                                        controller: TextEditingController(text: ''),
                                                                        onChanged: (text) {},
                                                                    ),
                                            SizedBox(height: 16.0),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 16),
                                              child: Container(
                                                  height: 50,
                                                  width: double.infinity, // Expandindo o botão à largura máxima
                                                  decoration: BoxDecoration(
                                                      color: CQColors.slate100,
                                                      borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: Center(
                                                      child: Text(
                                                          'Cadastrar',
                                                          style: TextStyle(color: Colors.white),
                                                      ),
                                                  ),
                                              ),
                                            ),
                                        ],
                                    ),
                                ),
                                            ],
                                        ),
                                    ),
                                ),
                               
                            ],
                        ),
                    ),
                );
            },
        );
    }
}
