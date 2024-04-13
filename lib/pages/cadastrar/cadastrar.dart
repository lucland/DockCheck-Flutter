import 'package:dockcheck/pages/cadastrar/cubit/cadastrar_cubit.dart';
import 'package:dockcheck/pages/cadastrar/cubit/cadastrar_state.dart';
import 'package:dockcheck/utils/enums/nrs_enum.dart';
import 'package:dockcheck/utils/theme.dart';
import 'package:dockcheck/utils/ui/colors.dart';
import 'package:dockcheck/utils/ui/strings.dart';
import 'package:dockcheck/widgets/calendar_picker_widget.dart';
import 'package:dockcheck/widgets/text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class CadastrarModal extends StatelessWidget {
  final String title;
  const CadastrarModal({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CadastrarCubit, CadastrarState>(
      builder: (context, state) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          backgroundColor: CQColors.white,
          surfaceTintColor: CQColors.white,
          title: Text(title),
          content: SizedBox(
            width: MediaQuery.of(context).size.width - 00,
            height: MediaQuery.of(context).size.height - 300,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextInputWidget(
                    title: CQStrings.nome,
                    isRequired: true,
                    controller: TextEditingController(
                      text: '',
                    ),
                    onChanged: (text) {},
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextInputWidget(
                              isRequired: true,
                              title: CQStrings.email,
                              controller: TextEditingController(
                                text: '',
                              ),
                              onChanged: (text) {},
                            ),
                            TextInputWidget(
                              title: CQStrings.funcao,
                              controller: TextEditingController(
                                text: '',
                              ),
                              onChanged: (text) {},
                              isRequired: true,
                            ),
                            TextInputWidget(
                              title: CQStrings.cpf,
                              controller: TextEditingController(
                                text: '',
                              ),
                              onChanged: (text) {},
                              keyboardType: TextInputType.number,
                              isRequired: true,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Tipo sanguíneo', style: CQTheme.h2),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8, right: 16, bottom: 8),
                                  child: DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 11.5),
                                      hintText: 'Tipo Sanguíneo',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: CQColors.slate100,
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: const BorderSide(
                                          color: CQColors.slate100,
                                          width: 1,
                                        ),
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
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
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
                      Flexible(
                          flex: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 8.0),
                                    child: Text('Foto',
                                        style: CQTheme.h2,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 2.0),
                                    child: Text(
                                      '*',
                                      style: CQTheme.h2
                                          .copyWith(color: CQColors.danger100),
                                    ),
                                  ),
                                ],
                              ),
                              // ImagePickerWidget(
                              //     cubit: context.read<CadastrarCubit>()),
                            ],
                          )),
                    ],
                  ),

                  //divider
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 24, 0, 8),
                        child: Text(
                          'Documentos',
                          overflow: TextOverflow.ellipsis,
                          style: CQTheme.h1.copyWith(
                              color: CQColors.iron80,
                              fontWeight: FontWeight.w400),
                        ),
                      
                      ),
                      Divider(),
                      CalendarPickerWidget(
                        showAttachmentIcon: true,
                        title: CQStrings.aso,
                        isRequired: true,
                        controller: TextEditingController(),
                        // cubit: context.read<CadastrarCubit>(),
                        onChanged: (time) {},
                      ),
                      CalendarPickerWidget(
                        showAttachmentIcon: true,
                        title: CQStrings.nr34,
                        isRequired: true,
                        controller: TextEditingController(),
                        //  cubit: context.read<CadastrarCubit>(),
                        onChanged: (time) {},
                      ),
                      ...state.nrTypes.map(
                        (nrType) => CalendarPickerWidget(
                          showAttachmentIcon: true,
                          title: nrType,
                          isRequired: false,
                          controller: TextEditingController(),
                          onChanged: (time) {},
                          // showRemoveButton: true,
                          //cubit: context.read<CadastrarCubit>(),
                          // onRemove: () => context
                          //   .read<CadastrarCubit>()
                          //   .removeNrType(nrType),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 11.5),
                                  hintText: 'Adicionar NR',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: CQColors.slate100,
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: CQColors.slate100,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                value: state.selectedNr == ''
                                    ? null
                                    : state.selectedNr,
                                onChanged: (String? newValue) {
                                  context.read<CadastrarCubit>().updateSelectedNr(
                                    newValue ?? '',
                                  );
                                },
                                items: NrsEnum.nrs
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: SizedBox(
                                      width: 600,
                                      child: Text(
                                        value,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: InkWell(
                                onTap: () => state.selectedNr != ''
                                    ? context
                                        .read<CadastrarCubit>()
                                        .addNrType(state.selectedNr)
                                    : null,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: state.selectedNr != ''
                                        ? CQColors.success100
                                        : CQColors.slate100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.add,
                                      color: CQColors.white,
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
                ],
              ),
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<CadastrarCubit>().resetState();
              },
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                                          decoration: BoxDecoration(
                                            color: 
                                                 CQColors.slate100,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Center(
                                              child: Text('cadastrar',
                                              style: TextStyle(color: Colors.white)
                                                 ),
                                            ),
                                          ),
                                        ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
