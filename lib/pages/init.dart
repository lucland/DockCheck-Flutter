import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/local_storage_service.dart';
import 'login/cubit/login_cubit.dart';
import 'login/cubit/login_state.dart';
import 'root/root.dart';
import 'login/login.dart';

class InitPage extends StatefulWidget {
  const InitPage({Key? key}) : super(key: key);

  @override
  _InitPageState createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final loginCubit = context.read<LoginCubit>();
    final localStorageService = context.read<LocalStorageService>();
    final jwtToken = await localStorageService.getToken();

    if (jwtToken != null) {
      loginCubit.validateToken(jwtToken);
    } else {
      _navigateToLoginPage();
    }
  }

  void _navigateToLoginPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  void _navigateToRootPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const Root()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          _navigateToRootPage();
        } else if (state is LoginError) {
          _navigateToLoginPage();
        }
      },
      child: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
