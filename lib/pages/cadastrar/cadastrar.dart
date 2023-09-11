import 'package:cripto_qr_googlemarine/utils/theme.dart';
import 'package:cripto_qr_googlemarine/utils/ui/constants.dart';
import 'package:flutter/material.dart';

import '../../utils/ui/colors.dart';
import '../../widgets/calendar_picker_widget.dart';
import '../../widgets/text_input_widget.dart';

class Cadastrar extends StatelessWidget {
  final VoidCallback onCadastrar;
  const Cadastrar({super.key, required this.onCadastrar});

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<String> switcherNotifier = ValueNotifier('Convés');

    return Column(
      children: [
        Expanded(
          child: Container(
            color: CQColors.white,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('N° 1', style: CQTheme.h1),
                        SizedBox(
                          width: 8,
                        ),
                        Flexible(
                          child: Text(
                            DateTime.now().toString(),
                            style: CQTheme.body,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    TextInputWidget(
                      title: CriptoQRUIConstants.nome,
                      isRequired: true,
                      controller: TextEditingController(),
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: TextInputWidget(
                            title: 'Email',
                            controller: TextEditingController(),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: TextInputWidget(
                            title: 'Identidade',
                            keyboardType: TextInputType.number,
                            controller: TextEditingController(),
                            isRequired: true,
                            isID: true,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: TextInputWidget(
                            title: 'Função',
                            controller: TextEditingController(),
                            isRequired: true,
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: TextInputWidget(
                            title: 'Empresa/Trip',
                            keyboardType: TextInputType.text,
                            controller: TextEditingController(),
                            isRequired: true,
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Local',
                        style: CQTheme.h2,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 0, 16, 16),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: CQColors.iron100,
                            width: 1.0,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DropdownButton<String>(
                            value: 'SKANDI 1',
                            isExpanded: true,
                            icon: const Icon(
                              Icons.arrow_downward_rounded,
                              color: CQColors.iron100,
                            ),
                            iconSize: 24,
                            alignment: Alignment.centerRight,
                            elevation: 2,
                            style: CQTheme.h2.copyWith(
                              color: CQColors.iron100,
                            ),
                            selectedItemBuilder: (BuildContext context) {
                              return <String>[
                                'SKANDI 1',
                                'SKANDI 2',
                                'SKANDI 3'
                              ].map<Widget>((String value) {
                                return Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    value,
                                    style: CQTheme.h2.copyWith(
                                      color: CQColors.iron100,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                );
                              }).toList();
                            },
                            onChanged: (String? newValue) {
                              // Handle the new value
                            },
                            underline: Container(
                              height: 0,
                              color: CQColors.iron100,
                            ),
                            items: <String>['SKANDI 1', 'SKANDI 2', 'SKANDI 3']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(8.0, 16.0, 16, 0.0),
                      child: Text(
                        'Área',
                        style: CQTheme.h2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8, 16.0),
                      child: ValueListenableBuilder(
                        valueListenable: switcherNotifier,
                        builder: (context, value, child) {
                          return Row(
                            children: [
                              buildSwitcherItem(
                                  'Convés', value, switcherNotifier),
                              buildSwitcherItem(
                                  'Praça', value, switcherNotifier),
                              buildSwitcherItem(
                                  'Casario', value, switcherNotifier),
                            ],
                          );
                        },
                      ),
                    ),
                    const Divider(),
                    const CalendarPickerWidget(
                      title: 'ASO',
                      isRequired: true,
                    ),
                    const Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: CalendarPickerWidget(
                            title: 'NR-34',
                            isRequired: true,
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: CalendarPickerWidget(
                            title: 'NR-10',
                          ),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: CalendarPickerWidget(
                            title: 'NR-33',
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: CalendarPickerWidget(
                            title: 'NR-35',
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    const Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: CalendarPickerWidget(
                            title: 'Data Inicial',
                            isRequired: true,
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: CalendarPickerWidget(
                            title: 'Data Final',
                            isRequired: true,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          color: CQColors.white,
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 8, 16.0),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: CQColors.slate100),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: const Text('LIMPAR',
                        overflow: TextOverflow.ellipsis, style: CQTheme.h3),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: CQColors.iron100,
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'CADASTRAR',
                      overflow: TextOverflow.ellipsis,
                      style: CQTheme.h3.copyWith(color: CQColors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Flexible buildSwitcherItem(
      String title, String value, ValueNotifier<String> notifier) {
    bool isActive = title == value;
    return Flexible(
      child: GestureDetector(
        onTap: () => notifier.value = title,
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(right: 8.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: isActive ? CQColors.iron100 : CQColors.white,
            border: Border.all(
              color: CQColors.iron100,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: CQTheme.h3.copyWith(
              color: isActive ? Colors.white : CQColors.iron100,
            ),
          ),
        ),
      ),
    );
  }
}
