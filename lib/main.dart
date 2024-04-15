import 'package:dockcheck/pages/cadastrar/cubit/cadastrar_cubit.dart';
import 'package:dockcheck/pages/details/cubit/details_cubit.dart';
import 'package:dockcheck/pages/home/cubit/home_cubit.dart';
import 'package:dockcheck/pages/home/cubit/home_details_cubit.dart';
import 'package:dockcheck/pages/pesquisar/cubit/pesquisar_cubit.dart';
import 'package:dockcheck/repositories/area_repository.dart';
import 'package:dockcheck/repositories/dashboard_repository.dart';
import 'package:dockcheck/repositories/document_repository.dart';
import 'package:dockcheck/repositories/employee_repository.dart';
import 'package:dockcheck/repositories/invite_repository.dart';
import 'package:dockcheck/repositories/picture_repository.dart';
import 'package:dockcheck/repositories/project_repository.dart';
import 'package:dockcheck/repositories/sensor_repository.dart';
import 'package:dockcheck/repositories/sync_repository.dart';
import 'package:dockcheck/repositories/third_company_repository.dart';
import 'package:dockcheck/repositories/third_project_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:dockcheck/repositories/login_repository.dart';
import 'package:dockcheck/repositories/authorization_repository.dart';
import 'package:dockcheck/services/api_service.dart';
import 'package:dockcheck/services/local_storage_service.dart';
import 'blocs/user/user_cubit.dart';
import 'pages/init.dart';
import 'pages/login/cubit/login_cubit.dart';
import 'repositories/beacon_repository.dart';
import 'repositories/company_repository.dart';
import 'repositories/event_repository.dart';
import 'repositories/user_repository.dart';
import 'repositories/vessel_repository.dart';
import 'services/background_service.dart';
import 'services/permission_handler_service.dart';
import 'utils/simple_logger.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  //--- permitir apenas posicao vertical
  /*SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);*/

  // Request Bluetooth permissions
  /*var status = await [
    Permission.bluetooth,
    Permission.bluetoothScan,
    Permission.bluetoothConnect
  ].request();
  if (status[Permission.bluetooth] != PermissionStatus.granted ||
      status[Permission.bluetoothScan] != PermissionStatus.granted ||
      status[Permission.bluetoothConnect] != PermissionStatus.granted) {
    // Handle permission denied
    return;
  }*/

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

// Repositorys callback

  var areaRepository = AreaRepository(apiService);
  var authorizationRepository =
      AuthorizationRepository(apiService, localStorageService);
  var beaconRepository = BeaconRepository(apiService, localStorageService);
  var companyRepository = CompanyRepository(apiService, localStorageService);
  var dashboardRepository = DashboardRepository(apiService);
  var documentRepository = DocumentRepository(apiService);
  var employeeRepository = EmployeeRepository(apiService);
  var eventRepository = EventRepository(apiService, localStorageService);
  var inviteRepository = InviteRepository(apiService);
  var loginRepository = LoginRepository(apiService);
  var pictureRepository = PictureRepository(apiService);
  var projectRepository = ProjectRepository(apiService);
  var sensorRepository = SensorRepository(apiService);
  var syncRepository = SyncController(apiService);
  //var thirdCompanyRepository = ThirdCompany(id: null, name: '', logo: '', razaoSocial: '', cnpj: '', admisId: null);
  //var thirdProjectRepository = ThirdProject(id: id, name: name, onboardedCount: onboardedCount, dateStart: dateStart, dateEnd: dateEnd, thirdCompany: thirdCompany, projectId: projectId, allowedAreasId: allowedAreasId, employeesId: employeesId, status: status);
  var userRepository = UserRepository(apiService, localStorageService);
  var vesselRepository = VesselRepository(apiService, localStorageService);
  var pesquisarCUbit = PesquisarCubit(employeeRepository, projectRepository, localStorageService);
  var homeCubit = HomeCubit(projectRepository, localStorageService);
  var homeDetailsCubit = HomeDetailsCubit(
      employeeRepository, projectRepository, localStorageService);

  // ------

  var loginCubit =
      LoginCubit(loginRepository, userRepository, localStorageService);
  var userCubit = UserCubit(userRepository);
  var cadastrarCubit = CadastrarCubit(
    employeeRepository,
    localStorageService,
    eventRepository,
    pictureRepository,
    documentRepository,
  );
  var detailsCubit = DetailsCubit(
      employeeRepository, documentRepository, localStorageService);

  BackgroundService();

  runApp(
    MultiBlocProvider(
      providers: [
        Provider<LoginRepository>(create: (_) => loginRepository),
        Provider<AuthorizationRepository>(
            create: (_) => authorizationRepository),
        Provider<CompanyRepository>(create: (_) => companyRepository),
        Provider<EventRepository>(create: (_) => eventRepository),
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
        Provider<BeaconRepository>(create: (_) => beaconRepository),
        Provider<SensorRepository>(
            create: (_) => SensorRepository(apiService)), //sensor repository
        Provider<PictureRepository>(create: (_) => pictureRepository),
        Provider<EmployeeRepository>(create: (_) => employeeRepository),
        BlocProvider<PesquisarCubit>(create: (_) => pesquisarCUbit),
        BlocProvider<HomeCubit>(create: (_) => homeCubit),
        BlocProvider<HomeDetailsCubit>(create: (_) => homeDetailsCubit),
      ],
      child: MaterialApp(
        theme: CQTheme.theme,
        home: const InitPage(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
