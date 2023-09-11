import 'package:cripto_qr_googlemarine/pages/cadastrar/cadastrar.dart';
import 'package:cripto_qr_googlemarine/pages/home/home.dart';
import 'package:cripto_qr_googlemarine/pages/scan/scan.dart';
import 'package:cripto_qr_googlemarine/utils/theme.dart';
import 'package:cripto_qr_googlemarine/utils/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import '../../models/user.dart';
import '../form/form.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  DateTime mockDate = DateTime.parse('2023-09-01 00:00:00-0300');

  User mockUser = User(
    aso: DateTime.parse('2023-09-01 00:00:00-0300'),
    checkIn: DateTime.parse('2023-09-01 00:00:00-0300')
        .add(const Duration(hours: 8)),
    checkInValidation: "01/09/2023 até 00/00/0000",
    checkOut: DateTime.parse('2023-09-01 00:00:00-0300')
        .add(const Duration(hours: 17)),
    checkOutValidation: "00/00/0000",
    company: "Googlemarine",
    email: "lucas.vsc@gmail.com",
    identity: "255521528",
    isAdmin: true,
    isBlocked: false,
    isVisitor: false,
    log: ["Dia 1"],
    name: "Lucas Valente",
    nr10: DateTime.parse('2023-09-01 00:00:00-0300'),
    nr33: DateTime.parse('2023-09-01 00:00:00-0300'),
    nr34: DateTime.parse('2023-09-01 00:00:00-0300'),
    nr35: DateTime.parse('2023-09-01 00:00:00-0300'),
    number: 1000,
    project: "Qr Cripto",
    reason: "-",
    role: "Engenheiro de Sotware",
    user: "LUCAS",
    vessel: "Teste Ship",
    isOnboarded: true,
    isConves: true,
    isPraca: false,
    isCasario: false,
    initialDate: DateTime.parse('2023-09-01'),
    finalDate: DateTime.parse('2023-09-01'),
  );

  late List<Widget> _widgetOptions;

  static const List<String> _pageTitles = [
    'Home',
    'Formulário',
    'Scan',
    'Cadastrar',
  ];

  @override
  void initState() {
    super.initState();

    final key = encrypt.Key.fromUtf8("1234567890123456");
    final iv = encrypt.IV.fromUtf8("1234567890123456");
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(mockUser.toDatabaseString(), iv: iv);
    //final decrypted = encrypter.decrypt(encrypted, iv: iv);

    print(encrypted.base64);

    _widgetOptions = [
      HomeWidget(user: mockUser, encrypted: encrypted.base64),
      const Formulario(),
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
