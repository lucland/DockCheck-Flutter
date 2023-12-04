import 'package:cripto_qr_googlemarine/pages/cadastrar/cadastrar.dart';
import 'package:cripto_qr_googlemarine/pages/home/home.dart';
import 'package:cripto_qr_googlemarine/repositories/login_repository.dart';
import 'package:cripto_qr_googlemarine/utils/theme.dart';
import 'package:cripto_qr_googlemarine/utils/ui/colors.dart';
import 'package:cripto_qr_googlemarine/utils/ui/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../login/login.dart';
import '../pesquisar/pesquisar.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  String appVersion = '';
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  late List<Widget> _widgetOptions;

  static const List<String> _pageTitles = [
    CQStrings.home,
    CQStrings.pesquisar,
    CQStrings.cadastrar,
  ];

  @override
  void initState() {
    super.initState();
    _loadAppVersion();

    _widgetOptions = [
      const Home(),
      const Pesquisar(),
      Cadastrar(
        onCadastrar: () {
          _pageController.jumpToPage(0);
        },
      ),
    ];
  }

  Future<void> _loadAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  static const List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(
        icon: Icon(Icons.home_rounded),
        label: 'Home',
        backgroundColor: CQColors.background),
    BottomNavigationBarItem(
        icon: Icon(Icons.search_rounded),
        label: 'Pesquisar',
        backgroundColor: CQColors.background),
    BottomNavigationBarItem(
        icon: Icon(Icons.person_add_rounded),
        label: 'Cadastrar',
        backgroundColor: CQColors.background),
  ];

  void _onItemTapped(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final Widget svgLogo = SvgPicture.asset(
    'assets/imgs/googlemarine_logo.svg',
    semanticsLabel: 'CriptoQR',
  );

  @override
  Widget build(BuildContext context) {
    final LoginRepository loginRepository = context.read<LoginRepository>();

    return Scaffold(
      appBar: AppBar(
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
                  _pageTitles[_selectedIndex],
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
      ),
      drawer: Drawer(
        surfaceTintColor: CQColors.iron100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: CQColors.iron100,
              ),
              child: Row(children: [
                Expanded(
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      color: CQColors.background,
                      fontSize: 24,
                    ),
                  ),
                ),
              ]),
            ),
            Expanded(
              child: ListView(children: const [
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                ),
              ]),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () {
                // Implement logout logic here
                // For example, clear user token and navigate to login screen
                loginRepository.logout();

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
                // Close the drawer
                // Navigate to login screen or handle logout
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('Version: $appVersion'),
            ),
            // Add other drawer items if needed
          ],
        ),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: _widgetOptions,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _bottomNavBarItems,
        currentIndex: _selectedIndex,
        selectedItemColor: CQColors.iron100,
        unselectedItemColor: CQColors.iron100.withOpacity(0.6),
        elevation: 4.0,
        selectedLabelStyle: CQTheme.selectedLabelTextStyle,
        unselectedLabelStyle: CQTheme.unselectLabelTextStyle,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
      ),
    );
  }
}
