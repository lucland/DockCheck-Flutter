import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cripto_qr_googlemarine/pages/cadastrar/cadastrar.dart';
import 'package:cripto_qr_googlemarine/pages/home/home.dart';
import 'package:cripto_qr_googlemarine/pages/scan/scan.dart';
import 'package:cripto_qr_googlemarine/utils/theme.dart';
import 'package:cripto_qr_googlemarine/utils/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../pesquisar/pesquisar.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  late List<Widget> _widgetOptions;

  static const List<String> _pageTitles = [
    'Home',
    'Pesquisar',
    'Scan',
    'Cadastrar',
  ];

  @override
  void initState() {
    super.initState();

    _widgetOptions = [
      const Home(),
      const Pesquisar(),
      const QRViewExample(),
      Cadastrar(
        onCadastrar: () {
          _pageController.jumpToPage(0);
        },
      ),
    ];
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
        icon: Icon(Icons.qr_code_scanner_rounded),
        label: 'Scan',
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
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 12.0),
              child: SvgPicture.asset(
                'assets/imgs/dof_logo.svg',
                semanticsLabel: 'CriptoQRLogo',
                height: 24.0,
                width: 24.0,
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
      body: PageView(
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
