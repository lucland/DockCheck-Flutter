import 'package:cripto_qr_googlemarine/pages/root/root.dart';
import 'package:cripto_qr_googlemarine/utils/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/theme.dart';
import '../../utils/ui/strings.dart';
import '../../widgets/text_input_widget.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Optional
      statusBarIconBrightness: Brightness.light, // White status bar icons
    ));

    return Scaffold(
      body: Column(
        children: <Widget>[
          // Top half with the logo
          Expanded(
            flex: 4, // Adjust flex ratio if needed
            child: Container(
              color: CQColors.iron100,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Image.asset('assets/imgs/logo_dock_check.png'),
                ), // Logo
              ),
            ),
          ),
          Expanded(
            flex: 6, // Adjust flex ratio if needed
            child: Container(
              color: CQColors.background,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextInputWidget(
                          title: 'Usuário',
                          keyboardType: TextInputType.emailAddress,
                          controller: TextEditingController(),
                          onChanged: (text) => {},
                        ),
                        TextInputWidget(
                          title: 'Senha',
                          keyboardType: TextInputType.text,
                          controller: TextEditingController(),
                          isPassword: true,
                          onChanged: (text) => {},
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        //navigate to Root()
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            settings: const RouteSettings(name: '/root'),
                            builder: (context) => const Root(),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0.0),
                          color: CQColors.iron100,
                        ),
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          CQStrings.login,
                          overflow: TextOverflow.ellipsis,
                          style:
                              CQTheme.headLine.copyWith(color: CQColors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
