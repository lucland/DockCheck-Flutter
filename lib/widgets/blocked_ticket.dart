import 'package:dockcheck/models/company.dart';
import 'package:dockcheck/models/user.dart';
import 'package:dockcheck/models/vessel.dart';
import 'package:dockcheck/pages/details/details.dart';
import 'package:dockcheck/utils/formatter.dart';
import 'package:dockcheck/utils/theme.dart';
import 'package:dockcheck/utils/ui/colors.dart';
import 'package:dockcheck/utils/ui/strings.dart';
import 'package:dockcheck/widgets/identificator.dart';
import 'package:dockcheck/widgets/semi_circle_painter.dart';
import 'package:dockcheck/widgets/title_value_widget.dart';
import 'package:flutter/material.dart';

class PrimaryTicket extends StatelessWidget {
  const PrimaryTicket(
      {Key? key,
      required this.users,
      required this.companies,
      required this.vessel,
      required this.bannercolor,
      this.isCompany = false,
      this.hasTime = true,
      required this.bannertitle})
      : super(key: key);

  final List<User> users;
  final List<Company> companies;
  final Vessel vessel;
  final bool hasTime;
  final bool isCompany;
  final Color bannercolor;
  final String bannertitle;

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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Column(
                children: [
                  TicketHeader(
                    vessel: vessel,
                    bannercolor: bannercolor,
                    bannertitle: bannertitle,
                  ),
                  if (!isCompany)
                    TicketBody(
                      users: users,
                      vessel: vessel,
                      hasTime: hasTime,
                    ),
                  if (isCompany)
                    TicketBodyCompany(
                      companies: companies,
                      vessel: vessel,
                      hasTime: hasTime,
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
      ),
    );
  }
}

class TicketBodyCompany extends StatefulWidget {
  const TicketBodyCompany({
    Key? key,
    required this.companies,
    required this.vessel,
    required this.hasTime,
  }) : super(key: key);

  final List<Company> companies;
  final Vessel vessel;
  final bool hasTime;

  @override
  State<TicketBodyCompany> createState() => _TicketBodyCompanyState();
}

class _TicketBodyCompanyState extends State<TicketBodyCompany> {
  bool _showAllUsers = false;

  void _toggleShowAllUsers() {
    setState(() {
      _showAllUsers = !_showAllUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Company> displayedUsers =
        _showAllUsers ? widget.companies : widget.companies.take(3).toList();

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Skandi Salvador',
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
                onTap: () {},
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    displayedUsers[index].name,
                                    style: CQTheme.body.copyWith(
                                      color: CQColors.iron100,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    displayedUsers[index].status,
                                    style: CQTheme.body.copyWith(
                                      color: CQColors.iron100,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Divider(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if (!_showAllUsers && widget.companies.length >= 3)
            InkWell(
              onTap: _toggleShowAllUsers,
              child: const Icon(Icons.keyboard_arrow_down_rounded),
            ),
          if (widget.hasTime) ...[
            // const Divider(),
            TicketFooter(updatedAt: widget.vessel.updatedAt),
          ]
        ],
      ),
    );
  }
}

class TicketBody extends StatefulWidget {
  const TicketBody({
    Key? key,
    required this.users,
    required this.vessel,
    required this.hasTime,
  }) : super(key: key);

  final List<User> users;
  final Vessel vessel;
  final bool hasTime;

  @override
  State<TicketBody> createState() => _TicketBodyState();
}

class _TicketBodyState extends State<TicketBody> {
  bool _showAllUsers = false;

  void _toggleShowAllUsers() {
    setState(() {
      _showAllUsers = !_showAllUsers;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<User> displayedUsers =
        _showAllUsers ? widget.users : widget.users.take(3).toList();

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Skandi Salvador',
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
                  ],
                ),
              );
            },
          ),
          if (!_showAllUsers && widget.users.length >= 3)
            InkWell(
              onTap: _toggleShowAllUsers,
              child: const Icon(Icons.keyboard_arrow_down_rounded),
            ),
          if (widget.hasTime) ...[
            // const Divider(),
            TicketFooter(updatedAt: widget.vessel.updatedAt),
          ]
        ],
      ),
    );
  }
}

class TicketHeader extends StatelessWidget {
  const TicketHeader({
    Key? key,
    required this.vessel,
    required this.bannercolor,
    required this.bannertitle,
  }) : super(key: key);

  final Vessel vessel;
  final Color bannercolor;
  final String bannertitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
        color: bannercolor,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              bannertitle,
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
          child: Text(
            user.number.toString(),
            style: CQTheme.h1.copyWith(fontSize: 38, color: Colors.black),
          ),
        ),
      ],
    );
  }
}
