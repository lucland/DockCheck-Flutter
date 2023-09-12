import 'package:cloud_firestore/cloud_firestore.dart';
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
import '../pesquisar/pesquisar.dart';

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
    ASO: Timestamp.fromDate(DateTime.parse('2023-09-01 00:00:00-0300')),
    numero: 0,
    empresa: "Googlemarine",
    email: "lucas.vsc@gmail.com",
    identidade: 255521528,
    isAdmin: true,
    isBlocked: false,
    isVisitante: false,
    eventos: ["OsUJsIU5JFWySiLShbkk"],
    nome: "Lucas Valente",
    NR10: Timestamp.fromDate(DateTime.parse('2023-09-01 00:00:00-0300')),
    NR33: Timestamp.fromDate(DateTime.parse('2023-09-01 00:00:00-0300')),
    NR34: Timestamp.fromDate(DateTime.parse('2023-09-01 00:00:00-0300')),
    NR35: Timestamp.fromDate(DateTime.parse('2023-09-01 00:00:00-0300')),
    funcao: "Engenheiro de Sotware",
    vessel: "Teste Ship",
    dataInicial: Timestamp.fromDate(DateTime.parse('2023-09-01 00:00:00-0300')),
    dataLimite: Timestamp.fromDate(DateTime.parse('2023-09-01 00:00:00-0300')),
    createdAt: Timestamp.fromDate(DateTime.parse('2023-09-01 00:00:00-0300')),
    updatedAt: Timestamp.fromDate(DateTime.parse('2023-09-01 00:00:00-0300')),
  );

  late List<Widget> _widgetOptions;

  static const List<String> _pageTitles = [
    'Home',
    'Pesquisar',
    'Scan',
    'Cadastrar',
  ];

  //fetch users from UserRepository
  //set mockUser to first users
  @override
  void initState() {
    super.initState();

    final key = encrypt.Key.fromUtf8("1234567890123456");
    final iv = encrypt.IV.fromUtf8("1234567890123456");
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(mockUser.toDatabaseString(), iv: iv);
    //final decrypted = encrypter.decrypt(encrypted, iv: iv);

    //fetch first user from firebase and set mockUser

    print(encrypted.base64);

    _widgetOptions = [
      HomeWidget(user: mockUser, encrypted: encrypted.base64),
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
        icon: Icon(Icons.list_alt_rounded),
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
