import 'package:dockcheck/repositories/beacon_repository.dart';
import 'package:dockcheck/repositories/receptor_repository.dart';
import 'package:dockcheck/repositories/supervisor_repository.dart';
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
    // _storeUserData();
    _initialize();
  }

  /*Future<void> _storeUserData() async {
    await context.read<LocalStorageService>().saveToken(
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6Imx1Y2FzdmNhcm5laXJvIiwicm9sZSI6ImFkbWluIiwiaWF0IjoxNjk5MzAwMTYxLCJleHAiOjE2OTk0NzI5NjF9.QytPS1faAJDDHVb9VuMRLeHXzBzb9ME_HGNThSpe1Lc");
    await context
        .read<LocalStorageService>()
        .saveUserId("eccf32d9-2c91-46ab-b6c5-16aaa391e4d1");
    _initialize();
    // Store other user data as needed
  }*/

  Future<void> _initialize() async {
    final loginCubit = context.read<LoginCubit>();
    final localStorageService = context.read<LocalStorageService>();
    final jwtToken = await localStorageService.getToken();

    if (jwtToken != null) {
      loginCubit.validateToken(jwtToken);
    } else {
      _navigateToLoginPage();
    }

    await _syncData();
  }

  Future<void> _syncData() async {
    //create tables if not exists
    final localStorageService = context.read<LocalStorageService>();
    final authorizationRepository = context.read<AuthorizationRepository>();
    final companyRepository = context.read<CompanyRepository>();
    final dockingRepository = context.read<DockingRepository>();
    final eventRepository = context.read<EventRepository>();
    final portalRepository = context.read<PortalRepository>();
    final supervisorRepository = context.read<SupervisorRepository>();
    final userRepository = context.read<UserRepository>();
    final vesselRepository = context.read<VesselRepository>();
    final beaconRepository = context.read<BeaconRepository>();
    final receptorRepository = context.read<ReceptorRepository>();

    try {
      SimpleLogger.info('Starting data synchronization');
      await localStorageService.ensureTableExists('authorizations');
      authorizationRepository.syncAuthorizations();
      await localStorageService.ensureTableExists('companies');
      companyRepository.syncCompanies();
      await localStorageService.ensureTableExists('dockings');
      dockingRepository.syncDockings();
      await localStorageService.ensureTableExists('events');
      eventRepository.syncEvents();
      await localStorageService.ensureTableExists('portals');
      portalRepository.syncPortals();
      await localStorageService.ensureTableExists('users');
      userRepository.syncPendingUsers();
      await localStorageService.ensureTableExists('supervisors');
      supervisorRepository.syncPendingSupervisors();
      await localStorageService.ensureTableExists('vessels');
      vesselRepository.syncPendingVessels();
      await localStorageService.ensureTableExists('beacons');
      beaconRepository.syncBeacons();
      await localStorageService.ensureTableExists('receptors');
      receptorRepository.syncReceptors();
    } catch (e) {
      SimpleLogger.warning('Error during data synchronization: $e');
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
