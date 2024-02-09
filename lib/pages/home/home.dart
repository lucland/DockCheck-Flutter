import 'dart:async';
import 'dart:ui';

import 'package:dockcheck/pages/details/details.dart';
import 'package:dockcheck/repositories/vessel_repository.dart';
import 'package:dockcheck/utils/formatter.dart';
import 'package:dockcheck/utils/theme.dart';
import 'package:dockcheck/utils/ui/colors.dart';
import 'package:dockcheck/widgets/blocked_ticket.dart';
import 'package:dockcheck/widgets/identificator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../models/company.dart';
import '../../models/user.dart';

import '../../models/vessel.dart';
import '../../repositories/authorization_repository.dart';
import '../../repositories/user_repository.dart';
import '../../services/local_storage_service.dart';
import '../../utils/ui/strings.dart';
import '../../widgets/sync_button_widget.dart';
import '../../widgets/semi_circle_painter.dart';
import '../../widgets/title_value_widget.dart';
import '../login/login.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserRepository userRepository =
        Provider.of<UserRepository>(context, listen: false);
    final LocalStorageService localStorageService =
        Provider.of<LocalStorageService>(context, listen: false);
    final VesselRepository vesselRepository =
        Provider.of<VesselRepository>(context, listen: false);
    final AuthorizationRepository authorizationRepository =
        Provider.of<AuthorizationRepository>(context, listen: false);

    return BlocProvider(
      create: (context) => HomeCubit(userRepository, localStorageService,
          vesselRepository, authorizationRepository),
      child: Container(
        color: CQColors.white,
        child: HomeView(),
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  final List<Company> conpanies = [
    Company(
        name: "Googlemarine",
        logo: "",
        supervisors: [""],
        vessels: [""],
        updatedAt: DateTime.now(),
        id: '',
        expirationDate: DateTime.now(),
        status: "56"),
    Company(
        name: "Vard",
        logo: "",
        supervisors: [""],
        vessels: [""],
        updatedAt: DateTime.now(),
        id: '',
        expirationDate: DateTime.now(),
        status: "18"),
    Company(
        name: "DOF",
        logo: "",
        supervisors: [""],
        vessels: [""],
        updatedAt: DateTime.now(),
        id: '',
        expirationDate: DateTime.now(),
        status: "62"),
    Company(
        name: "Empresa",
        logo: "",
        supervisors: [""],
        vessels: [""],
        updatedAt: DateTime.now(),
        id: '',
        expirationDate: DateTime.now(),
        status: "3"),
    Company(
        name: "Googlemarine",
        logo: "",
        supervisors: [""],
        vessels: [""],
        updatedAt: DateTime.now(),
        id: '',
        expirationDate: DateTime.now(),
        status: "4"),
  ];

  @override
  Widget build(BuildContext context) {
    context.read<HomeCubit>().fetchLoggedUser();

    return RefreshIndicator(
      color: CQColors.iron100,
      backgroundColor: CQColors.white,
      onRefresh: () async {
        context.read<HomeCubit>().reloadPage();
      },
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Container(
                color: CQColors.background,
                child: const Center(child: CircularProgressIndicator()));
          } else if (state.isLoading == false && state.loggedUser != null) {
            List<User> users = state.onboardUsers;
            User user = state.loggedUser!;
            return Container(
              color: CQColors.background,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                flex: 1,
                                child: HeaderTicket(
                                  totalheight: 300,
                                  bannercolor: CQColors.systemBlue110,
                                  bannertitle: 'total à bordo', //sleaver
                                  updatedAt: DateTime.now(),
                                  numberofmembers: 142,
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: HeaderTicket(
                                  totalheight: 300,
                                  bannercolor: CQColors.success100,
                                  bannertitle: 'total no dique', //sleaver
                                  updatedAt: DateTime.now(),
                                  numberofmembers: 34,
                                ),
                              ),
                            ],
                          ),
                          PrimaryTicket(
                              bannertitle: 'LOCALIZAÇÕES',
                              bannercolor: CQColors.iron100,
                              users: state.onboardUsers,
                              companies: conpanies,
                              vessel: state.vessels[0]),
                          PrimaryTicket(
                              bannertitle: 'EMPRESAS',
                              bannercolor: CQColors.iron100,
                              users: state.onboardUsers,
                              companies: conpanies,
                              isCompany: true,
                              vessel: state.vessels[0]),
                          const Divider(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SyncButtonWidget(
                                onPressed: () {
                                  context.read<HomeCubit>().reloadPage();
                                },
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            // Delete the token and navigate to the login page
            Provider.of<LocalStorageService>(context, listen: false)
                .deleteToken();
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => LoginPage()),
            );
            return const SizedBox.shrink(); // Or any other placeholder widget
          }
        },
      ),
    );
  }
}

class HeaderTicket extends StatelessWidget {
  final double totalheight;
  final Color bannercolor;
  final String bannertitle;
  final int numberofmembers;
  final DateTime updatedAt;
  final bool hasTime;
  final bool isAlt;

  const HeaderTicket({
    Key? key,
    this.isAlt = false,
    required this.totalheight,
    required this.bannercolor,
    required this.bannertitle,
    required this.updatedAt,
    this.hasTime = true,
    required this.numberofmembers,
  }) : super(key: key);

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      height: totalheight,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 68,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                    color: bannercolor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        bannertitle.toUpperCase(),
                        style: CQTheme.h3.copyWith(
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: totalheight - 138,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                    color: CQColors.white,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
                  child: Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: CQColors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          )),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Text(
                            numberofmembers.toString(),
                            style: isAlt
                                ? TextStyle(
                                    color: CQColors.iron80,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 75,
                                    overflow: TextOverflow.ellipsis,
                                  )
                                : TextStyle(
                                    color: CQColors.iron100,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 100,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                    color: CQColors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (hasTime) ...[
                          const Icon(Icons.info_outline,
                              color: CQColors.slate100, size: 14),
                          const SizedBox(width: 8),
                          Text(
                            CQStrings.atualizadoEm(
                                Formatter.formatDateTime(updatedAt)),
                            style: CQTheme.body.copyWith(
                              color: CQColors.slate100,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 56,
              left: -10,
              child: CustomPaint(
                size: const Size(20, 10),
                painter: CirclePainter(
                  color: CQColors.background,
                  direction: Direction.left,
                ),
              ),
            ),
            Positioned(
              top: 56,
              right: -10,
              child: CustomPaint(
                size: const Size(20, 10),
                painter: CirclePainter(
                  color: CQColors.background,
                  direction: Direction.right,
                ),
              ),
            ),
            Positioned(
              bottom: 48,
              left: -10,
              child: CustomPaint(
                size: const Size(20, 10),
                painter: CirclePainter(
                  color: CQColors.background,
                  direction: Direction.right,
                ),
              ),
            ),
            Positioned(
              bottom: 48,
              right: -10,
              child: CustomPaint(
                size: const Size(20, 10),
                painter: CirclePainter(
                  color: CQColors.background,
                  direction: Direction.left,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardTicket extends StatelessWidget {
  const OnboardTicket({
    Key? key,
    required this.users,
    required this.vessel,
  }) : super(key: key);

  final List<User> users;
  final Vessel vessel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                TicketHeader(vessel: vessel),
                TicketBody(
                  users: users,
                  vessel: vessel,
                ),
              ],
            ),
            Positioned(
              top: 48,
              left: -10,
              child: CustomPaint(
                size: const Size(20, 10),
                painter: CirclePainter(
                  color: CQColors.background,
                  direction: Direction.left,
                ),
              ),
            ),
            Positioned(
              top: 48,
              right: -10,
              child: CustomPaint(
                size: const Size(20, 10),
                painter: CirclePainter(
                  color: CQColors.background,
                  direction: Direction.right,
                ),
              ),
            ),
            Positioned(
              bottom: 48,
              left: -10,
              child: CustomPaint(
                size: const Size(20, 10),
                painter: CirclePainter(
                  color: CQColors.background,
                  direction: Direction.right,
                ),
              ),
            ),
            Positioned(
              bottom: 48,
              right: -10,
              child: CustomPaint(
                size: const Size(20, 10),
                painter: CirclePainter(
                  color: CQColors.background,
                  direction: Direction.left,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TicketBody extends StatefulWidget {
  const TicketBody({
    Key? key,
    required this.users,
    required this.vessel,
  }) : super(key: key);

  final List<User> users;
  final Vessel vessel;

  @override
  _TicketBodyState createState() => _TicketBodyState();
}

class _TicketBodyState extends State<TicketBody> {
  bool _showAllUsers = false;
  bool get showAllUsers => _showAllUsers;

  void _toggleShowAllUsers() {
    setState(() {
      _showAllUsers = !_showAllUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<User> displayedUsers =
        _showAllUsers ? widget.users : widget.users.sublist(0, 3);

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
        color: CQColors.white,
      ),
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //text saying Total: ${users.length}
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Total: ${widget.users.length}',
                style: CQTheme.h3.copyWith(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const Divider(),
          ListView.builder(
            shrinkWrap: true,
            itemCount: displayedUsers.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          Details(user: displayedUsers[index]),
                    ),
                  );
                },
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HomeListItemWidget(
                                area: displayedUsers[index].area,
                                number: displayedUsers[index].number.toString(),
                                name: displayedUsers[index].name,
                                company: displayedUsers[index].company,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
              );
            },
          ),
          if (!_showAllUsers)
            InkWell(
              onTap: _toggleShowAllUsers,
              child:
                  const Center(child: Icon(Icons.keyboard_arrow_down_rounded)),
            ),
          const Divider(),
          TicketFooter(updatedAt: widget.vessel.updatedAt),
        ],
      ),
    );
  }
}

class TicketHeader extends StatelessWidget {
  const TicketHeader({
    Key? key,
    required this.vessel,
  }) : super(key: key);

  final Vessel vessel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
        color: CQColors.iron100,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              vessel.name,
              style: CQTheme.h3.copyWith(
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class TicketFooter extends StatelessWidget {
  const TicketFooter({
    Key? key,
    required this.updatedAt,
  }) : super(key: key);

  final DateTime updatedAt;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
        ),
        color: CQColors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info_outline, color: CQColors.slate100, size: 14),
            const SizedBox(width: 8),
            Text(
              CQStrings.atualizadoEm(Formatter.formatDateTime(updatedAt)),
              style: CQTheme.body.copyWith(
                color: CQColors.slate100,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class EstadiaWidget extends StatelessWidget {
  const EstadiaWidget({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Center(
          child: Text(user.number.toString(),
              style: CQTheme.h1.copyWith(fontSize: 38, color: Colors.black)),
        ),
      ],
    );
  }
}
