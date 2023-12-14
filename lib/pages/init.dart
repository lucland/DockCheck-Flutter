import 'package:dockcheck/utils/simple_logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/authorization_repository.dart';
import '../repositories/company_repository.dart';
import '../repositories/docking_repository.dart';
import '../repositories/event_repository.dart';
import '../repositories/portal_repository.dart';
import '../repositories/user_repository.dart';
import '../repositories/vessel_repository.dart';
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

  Future<void> _syncData() async {
    // Call sync functions from all repositories
    try {
      context.read<AuthorizationRepository>().syncAuthorizations();
      context.read<CompanyRepository>().syncCompanies();
      context.read<DockingRepository>().syncDockings();
      context.read<EventRepository>().syncEvents();
      context.read<PortalRepository>().syncPortals();
      context.read<UserRepository>().syncUsers();
      context.read<VesselRepository>().syncVessels();
    } catch (e) {
      SimpleLogger.warning('Error during data synchronization: $e');
      print('Error during data synchronization: $e');
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
          _syncData().then((_) {
            SimpleLogger.info('Data synchronization completed');
            _navigateToRootPage();
          });
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
