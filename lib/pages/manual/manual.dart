/*import 'package:dockcheck/utils/ui/colors.dart';
import 'package:dockcheck/utils/ui/strings.dart';
import 'package:dockcheck/widgets/manual_switcher.dart';
import 'package:dockcheck/widgets/text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onMenuPressed;

  CustomAppBar({
    required this.title,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 12.0),
            child: SvgPicture.asset(
              'assets/imgs/logo_dock_check.svg',
              semanticsLabel: 'CriptoQRLogo',
              height: 30.0,
              width: 80.0,
            ),
          ),
          Container(
            height: 24.0,
            width: 1.0,
            color: CQColors.iron100,
            margin: const EdgeInsets.only(left: 12.0, right: 2.0),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: CQColors.iron100,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: CQColors.background,
      shadowColor: CQColors.slate110.withOpacity(0.18),
      elevation: 0.0,
      scrolledUnderElevation: 4.0,
      surfaceTintColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class ManualPage extends StatefulWidget {
  ManualPage({Key? key}) : super(key: key);

  @override
  _ManualPageState createState() => _ManualPageState();
}

class _ManualPageState extends State<ManualPage> {
  bool isEntradaSelected = false;
  bool isSaidaSelected = false;
  final TextEditingController numeroController = TextEditingController();

  void onEntradaTap() {
    setState(() {
      isEntradaSelected = true;
      isSaidaSelected = false;
    });
  }

  void onSaidaTap() {
    setState(() {
      isEntradaSelected = false;
      isSaidaSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Acesso manual',
        onMenuPressed: () {},
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(4, 8, 4, 8),
              child: TextInputWidget(
                title: 'NÚMERO',
                keyboardType: TextInputType.number,
                controller: numeroController,
                isRequired: true,
              ),
            ),
            ManualSwitcherWidget(
              onEntradaTap:
                  onEntradaTap, // pode definir o que é feito com a entrada
              onSaidaTap: onSaidaTap, // pode definir o que é feito com a saída
              isEntradaSelected: isEntradaSelected,
              isSaidaSelected: isSaidaSelected,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: GestureDetector(
                      onTap: () {
                        // botão de envio aqui
                      },
                      child: Container(
                        child: Center(
                          child: Text(
                            CQStrings.enviar,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(width: 1, color: CQColors.iron100),
                          color: Colors.transparent,
                        ),
                        height: 50,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
*/