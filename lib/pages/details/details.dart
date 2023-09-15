import 'package:cripto_qr_googlemarine/utils/formatter.dart';
import 'package:cripto_qr_googlemarine/utils/ui/colors.dart';
import 'package:cripto_qr_googlemarine/widgets/print_button_widget.dart';
import 'package:cripto_qr_googlemarine/widgets/title_value_widget.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../utils/theme.dart';

class Details extends StatelessWidget {
  final User user;
  const Details({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.edit_rounded,
              color: CQColors.iron100,
            ),
          ),
        ],
        backgroundColor: CQColors.background,
        elevation: 0,
        title: const Text('Informações',
            style: CQTheme.h2, overflow: TextOverflow.ellipsis),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16),
                    color: CQColors.iron100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(user.nome,
                              style: CQTheme.h1.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                              overflow: TextOverflow.ellipsis),
                        ),
                        Text('#${user.numero.toString()}',
                            style: CQTheme.h1.copyWith(color: Colors.white),
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        TitleValueWidget(
                          title: 'Função',
                          value: user.funcao,
                          color: CQColors.iron100,
                        ),
                        const SizedBox(height: 12),
                        TitleValueWidget(
                          title: 'Empresa',
                          value: user.empresa,
                          color: CQColors.iron100,
                        ),
                        const SizedBox(height: 12),
                        TitleValueWidget(
                          title: 'Identidade',
                          value: Formatter.identidade(user.identidade),
                          color: CQColors.iron100,
                        ),
                        if (user.email != '') ...[
                          const SizedBox(height: 12),
                          TitleValueWidget(
                            title: 'Email',
                            value: user.email,
                            color: CQColors.iron100,
                          ),
                        ],
                        const SizedBox(height: 12),
                        TitleValueWidget(
                          title: 'Embarcação',
                          value: user.vessel,
                          color: CQColors.iron100,
                        ),
                        const SizedBox(height: 12),
                        TitleValueWidget(
                          title: 'Área',
                          value: user.area,
                          color: CQColors.iron100,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: CQColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'VALIDADES',
                              style: CQTheme.h1.copyWith(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.0),
                              child: Divider(
                                color: CQColors.slate100,
                                thickness: 0.3,
                              ),
                            ),
                            TitleValueWidget(
                              title: 'ASO',
                              value:
                                  Formatter.formatDateTime(user.ASO.toDate()),
                              color: CQColors.iron100,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TitleValueWidget(
                                  title: 'NR34',
                                  value: Formatter.formatDateTime(
                                      user.NR34.toDate()),
                                  color: CQColors.iron100,
                                ),
                                TitleValueWidget(
                                  title: 'NR10',
                                  value: Formatter.formatDateTime(
                                      user.NR10.toDate()),
                                  color: CQColors.iron100,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TitleValueWidget(
                                  title: 'NR33',
                                  value: Formatter.formatDateTime(
                                      user.NR33.toDate()),
                                  color: CQColors.iron100,
                                ),
                                TitleValueWidget(
                                  title: 'NR35',
                                  value: Formatter.formatDateTime(
                                      user.NR35.toDate()),
                                  color: CQColors.iron100,
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ESTADIA',
                                  style: CQTheme.h1.copyWith(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2.0),
                                  child: Divider(
                                    color: CQColors.iron100,
                                    thickness: 0.3,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'DE: ',
                                      style: CQTheme.body.copyWith(
                                        color: CQColors.iron100,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      Formatter.formatDateTime(
                                          user.dataInicial.toDate()),
                                      style: CQTheme.body.copyWith(
                                        color: CQColors.iron100,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'ATÉ: ',
                                      style: CQTheme.body.copyWith(
                                        color: CQColors.iron100,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      Formatter.formatDateTime(
                                          user.dataLimite.toDate()),
                                      style: CQTheme.body.copyWith(
                                        color: CQColors.iron100,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          PrintButtonWidget(onPressed: () {}),
        ],
      ),
    );
  }
}
