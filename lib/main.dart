import 'package:dockcheck/pages/cadastrar/cubit/cadastrar_cubit.dart';
import 'package:dockcheck/pages/details/cubit/details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:dockcheck/repositories/login_repository.dart';
import 'package:dockcheck/repositories/authorization_repository.dart';
import 'package:dockcheck/services/api_service.dart';
import 'package:dockcheck/services/local_storage_service.dart';
import 'blocs/user/user_cubit.dart';
import 'pages/init.dart';
import 'pages/login/cubit/login_cubit.dart';
import 'repositories/company_repository.dart';
import 'repositories/docking_repository.dart';
import 'repositories/event_repository.dart';
import 'repositories/portal_repository.dart';
import 'repositories/supervisor_repository.dart';
import 'repositories/user_repository.dart';
import 'repositories/vessel_repository.dart';
import 'services/background_service.dart';
import 'services/permission_handler_service.dart';
import 'utils/simple_logger.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var localStorageService = LocalStorageService();
  await localStorageService.initDB();
  await localStorageService.init();

  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  SimpleLogger.shared.set(level: LoggerLevel.info, mode: LoggerMode.log);
  SimpleLogger.info('Launching -----');
  SimpleLogger.info('App ID: ${packageInfo.packageName}');
  SimpleLogger.info('Version: ${packageInfo.version}');

  var apiService = ApiService(localStorageService);
  var permissionHandlerService = PermissionHandlerService();

  var loginRepository = LoginRepository(apiService);
  var authorizationRepository =
      AuthorizationRepository(apiService, localStorageService);
  var companyRepository = CompanyRepository(apiService, localStorageService);
  var dockingRepository = DockingRepository(apiService, localStorageService);
  var eventRepository = EventRepository(apiService, localStorageService);
  var portalRepository = PortalRepository(apiService, localStorageService);
  var supervisorRepository =
      SupervisorRepository(apiService, localStorageService);
  var userRepository = UserRepository(apiService, localStorageService);
  var vesselRepository = VesselRepository(apiService, localStorageService);

  var loginCubit =
      LoginCubit(loginRepository, userRepository, localStorageService);
  var userCubit = UserCubit(userRepository);
  var cadastrarCubit =
      CadastrarCubit(userRepository, eventRepository, localStorageService);
  var detailsCubit = DetailsCubit(userRepository, eventRepository,
      localStorageService, authorizationRepository, vesselRepository);

  BackgroundService();

  runApp(
    MultiBlocProvider(
      providers: [
        Provider<LoginRepository>(create: (_) => loginRepository),
        Provider<AuthorizationRepository>(
            create: (_) => authorizationRepository),
        Provider<CompanyRepository>(create: (_) => companyRepository),
        Provider<DockingRepository>(create: (_) => dockingRepository),
        Provider<EventRepository>(create: (_) => eventRepository),
        Provider<PortalRepository>(create: (_) => portalRepository),
        Provider<SupervisorRepository>(create: (_) => supervisorRepository),
        Provider<UserRepository>(create: (_) => userRepository),
        Provider<VesselRepository>(create: (_) => vesselRepository),
        Provider<PermissionHandlerService>(
            create: (_) => permissionHandlerService),
        Provider<ApiService>(create: (_) => apiService),
        Provider<LocalStorageService>(create: (_) => localStorageService),
        BlocProvider<LoginCubit>(create: (_) => loginCubit),
        BlocProvider<UserCubit>(create: (_) => userCubit),
        BlocProvider<CadastrarCubit>(create: (_) => cadastrarCubit),
        BlocProvider<DetailsCubit>(create: (_) => detailsCubit),
      ],
      child: MaterialApp(
        theme: CQTheme.theme,
        home: const InitPage(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
