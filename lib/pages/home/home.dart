import 'package:cripto_qr_googlemarine/repositories/vessel_repository.dart';
import 'package:cripto_qr_googlemarine/utils/formatter.dart';
import 'package:cripto_qr_googlemarine/utils/theme.dart';
import 'package:cripto_qr_googlemarine/utils/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';

import '../../models/vessel.dart';
import '../../repositories/authorization_repository.dart';
import '../../repositories/user_repository.dart';
import '../../services/local_storage_service.dart';
import '../../utils/ui/strings.dart';
import '../../widgets/sync_button_widget.dart';
import '../../widgets/semi_circle_painter.dart';
import '../../widgets/title_value_widget.dart';
import 'cubit/home_cubit.dart';
import 'cubit/home_state.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
        child: const HomeView(),
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<HomeCubit>().fetchLoggedUser();

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.isLoading == false && state.loggedUser != null) {
          List<User> users = state.onboardUsers;
          User user = state.loggedUser!;
          return Container(
            color: CQColors.background,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Olá, ${user.name}',
                    style: CQTheme.h3.copyWith(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pessoas a bordo:',
                        style: CQTheme.h3.copyWith(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'Total: ${users.length}',
                        style: CQTheme.h3.copyWith(
                          color: Colors.black,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                //list of onboard tickets for each vessel
                if (state.vessels.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: state.vessels.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: OnboardTicket(
                              users: users, vessel: state.vessels[index]),
                        );
                      },
                    ),
                  ),
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
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class OnboardTicket extends StatelessWidget {
  const OnboardTicket({
    super.key,
    required this.users,
    required this.vessel,
  });

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

class TicketBody extends StatelessWidget {
  const TicketBody({
    super.key,
    required this.users,
    required this.vessel,
  });

  final List<User> users;
  final Vessel vessel;

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
              return Row(
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
                                title: "Nome", value: users[index].name),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(users[index].area.toString(),
                          style: CQTheme.h1.copyWith(
                              fontSize: 14, color: CQColors.success100)),
                    ),
                  ]);
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
    super.key,
    required this.vessel,
  });

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
    super.key,
    required this.updatedAt,
  });

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
    super.key,
    required this.user,
  });

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
