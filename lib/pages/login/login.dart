import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:dockcheck/pages/root/root.dart';
import 'package:dockcheck/utils/ui/colors.dart';
import 'package:dockcheck/utils/theme.dart';
import 'package:dockcheck/utils/ui/strings.dart';
import 'package:dockcheck/widgets/text_input_widget.dart';

import 'cubit/login_cubit.dart';
import 'cubit/login_state.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Root()),
            );
          } else if (state is LoginError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Login Failed')),
            );
          }
        },
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Container(
                color: CQColors.iron100,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Image.asset('assets/imgs/logo_dock_check.png'),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: SingleChildScrollView(
                child: Container(
                  color: CQColors.background,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextInputWidget(
                              title: 'Usuário',
                              keyboardType: TextInputType.emailAddress,
                              controller: _usernameController,
                            ),
                            TextInputWidget(
                              title: 'Senha',
                              keyboardType: TextInputType.text,
                              controller: _passwordController,
                              isPassword: true,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                BlocProvider.of<LoginCubit>(context).logIn(
                  _usernameController.text,
                  _passwordController.text,
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
                  style: CQTheme.headLine.copyWith(color: CQColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
