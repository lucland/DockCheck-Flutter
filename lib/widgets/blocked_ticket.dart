import 'package:dockcheck/models/user.dart';
import 'package:dockcheck/models/vessel.dart';
import 'package:dockcheck/pages/details/details.dart';
import 'package:dockcheck/utils/formatter.dart';
import 'package:dockcheck/utils/theme.dart';
import 'package:dockcheck/utils/ui/colors.dart';
import 'package:dockcheck/utils/ui/strings.dart';
import 'package:dockcheck/widgets/semi_circle_painter.dart';
import 'package:dockcheck/widgets/title_value_widget.dart';
import 'package:flutter/material.dart';

class BlockedTicket extends StatelessWidget {
  const BlockedTicket({
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
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                TicketHeader(vessel: vessel),
                TicketBody(users: users, vessel: vessel),
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

class TicketBody extends StatelessWidget {
  const TicketBody({
    Key? key,
    required this.users,
    required this.vessel,
  }) : super(key: key);

  final List<User> users;
  final Vessel vessel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
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
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Total: ${users.length}',
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
            itemCount: users.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Details(user: users[index]),
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
                            TitleValueWidget(
                              title: "Nome",
                              value: users[index].name,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        users[index].number.toString(),
                        style: CQTheme.h1
                            .copyWith(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const Divider(),
          TicketFooter(updatedAt: vessel.updatedAt),
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
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
        color: CQColors.danger100,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'BLOQUEADOS DO DIA',
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
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
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
