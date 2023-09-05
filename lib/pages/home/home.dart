import 'package:cripto_qr_googlemarine/pages/scan/scan.dart';
import 'package:cripto_qr_googlemarine/utils/theme.dart';
import 'package:cripto_qr_googlemarine/utils/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home'),
    Text('Formulário'),
    QRViewExample(),
    Text('Cadastrar'),
  ];

  static const List<String> _pageTitles = [
    'Home',
    'Formulário',
    'Scan',
    'Cadastrar',
  ];

  static const List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(
        icon: Icon(Icons.home_rounded),
        label: 'Home',
        backgroundColor: CQColors.background),
    BottomNavigationBarItem(
        icon: Icon(Icons.list_alt_rounded),
        label: 'Formulário',
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
                'assets/imgs/googlemarine_logo.svg',
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
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _pageTitles[_selectedIndex],
                style: const TextStyle(
                  color: CQColors.iron100,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
        backgroundColor: CQColors.background,
        shadowColor: CQColors.slate110.withOpacity(0.18),
        elevation: 1.0,
        scrolledUnderElevation: 4.0,
        surfaceTintColor: Colors.transparent,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.menu_rounded,
                color: CQColors.iron100,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search_rounded,
              color: CQColors.iron100,
            ),
            onPressed: () {
              // Handle search button press
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView.builder(
          itemCount: _bottomNavBarItems.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: _bottomNavBarItems[index].icon,
              title: Text(_bottomNavBarItems[index].label!),
              onTap: () {
                _onItemTapped(index);
                Navigator.of(context).pop();
              },
              selectedColor: CQColors.iron100,
              style: ListTileStyle.drawer,
              iconColor: CQColors.iron100,
            );
          },
        ),
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
