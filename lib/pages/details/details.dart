import 'package:dockcheck/pages/editar/editar.dart';
import 'package:dockcheck/repositories/event_repository.dart';
import 'package:dockcheck/services/local_storage_service.dart';
import 'package:dockcheck/utils/formatter.dart';
import 'package:dockcheck/utils/ui/ui.dart';
import 'package:dockcheck/widgets/checkout_button_widget.dart';
import 'package:dockcheck/widgets/sync_button_widget.dart';
import 'package:dockcheck/widgets/title_value_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../models/user.dart';
import '../../repositories/authorization_repository.dart';
import '../../repositories/user_repository.dart';
import '../../repositories/vessel_repository.dart';
import '../../utils/action_enum.dart';
import '../../utils/theme.dart';
import 'cubit/details_cubit.dart';
import 'cubit/details_state.dart';

class Details extends StatelessWidget {
  final User user;
  const Details({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final UserRepository userRepository = Provider.of<UserRepository>(context);
    final EventRepository eventRepository =
        Provider.of<EventRepository>(context);
    final LocalStorageService localStorageService =
        Provider.of<LocalStorageService>(context);
    final AuthorizationRepository authorizationRepository =
        Provider.of<AuthorizationRepository>(context);
    final VesselRepository vesselRepository =
        Provider.of<VesselRepository>(context);

    return BlocProvider(
      create: (context) => DetailsCubit(userRepository, eventRepository,
          localStorageService, authorizationRepository, vesselRepository),
      child: Container(
        color: CQColors.white,
        child: DetailsView(
          user: user,
        ),
      ),
    );
  }
}

class DetailsView extends StatelessWidget {
  final User user;
  const DetailsView({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    context.read<DetailsCubit>().fetchEvents(user.id);

    return BlocBuilder<DetailsCubit, DetailsState>(
      builder: (context, state) {
        if (state is DetailsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DetailsError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is DetailsLoaded) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Editar(
                          user: user,
                          onSalvar: () => Navigator.pop,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.edit_rounded,
                    color: CQColors.iron100,
                  ),
                ),
              ],
              backgroundColor: CQColors.background,
              foregroundColor: CQColors.iron100,
              elevation: 0,
              title: const Text(CQStrings.informacoes,
                  style: CQTheme.h2, overflow: TextOverflow.ellipsis),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16),
                          color: CQColors.iron100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(user.name,
                                    style: CQTheme.h1.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                    overflow: TextOverflow.ellipsis),
                              ),
                              Text('|   N° ${user.number.toString()}',
                                  style:
                                      CQTheme.h1.copyWith(color: Colors.white),
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        if (user.isOnboarded)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16),
                            color: CQColors.success20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: CQColors.success120,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(CQStrings.aBordo,
                                    style: CQTheme.h1.copyWith(
                                        color: CQColors.success120,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                    overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              TitleValueWidget(
                                title: CQStrings.funcao,
                                value: user.role,
                                color: CQColors.iron100,
                              ),
                              const SizedBox(height: 12),
                              TitleValueWidget(
                                title: CQStrings.empresaTrip,
                                value: user.company,
                                color: CQColors.iron100,
                              ),
                              const SizedBox(height: 12),
                              TitleValueWidget(
                                title: CQStrings.identidade,
                                value: Formatter.identidade(user.identidade),
                                color: CQColors.iron100,
                              ),
                              if (user.email != '') ...[
                                const SizedBox(height: 12),
                                TitleValueWidget(
                                  title: CQStrings.email,
                                  value: user.email,
                                  color: CQColors.iron100,
                                ),
                              ],
                              const SizedBox(height: 12),
                              TitleValueWidget(
                                title: CQStrings.area,
                                value: user.area,
                                color: CQColors.iron100,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: CQColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    CQStrings.validades,
                                    style: CQTheme.h1.copyWith(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.0),
                                    child: Divider(
                                      color: CQColors.slate100,
                                      thickness: 0.3,
                                    ),
                                  ),
                                  TitleValueWidget(
                                    title: CQStrings.aso,
                                    value: Formatter.formatDateTime(user.aso),
                                    color: CQColors.iron100,
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TitleValueWidget(
                                        title: CQStrings.nr34,
                                        value:
                                            Formatter.formatDateTime(user.nr34),
                                        color: CQColors.iron100,
                                      ),
                                      TitleValueWidget(
                                        title: CQStrings.nr10,
                                        value:
                                            Formatter.formatDateTime(user.nr10),
                                        color: CQColors.iron100,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TitleValueWidget(
                                        title: CQStrings.nr33,
                                        value:
                                            Formatter.formatDateTime(user.nr33),
                                        color: CQColors.iron100,
                                      ),
                                      TitleValueWidget(
                                        title: CQStrings.nr35,
                                        value:
                                            Formatter.formatDateTime(user.nr35),
                                        color: CQColors.iron100,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: CQColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        CQStrings.estadia,
                                        style: CQTheme.h1.copyWith(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 2.0),
                                        child: Divider(
                                          color: CQColors.iron100,
                                          thickness: 0.3,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            CQStrings.de,
                                            style: CQTheme.body.copyWith(
                                              color: CQColors.iron100,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            Formatter.formatDateTime(
                                                user.startJob),
                                            style: CQTheme.body.copyWith(
                                              color: CQColors.iron100,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            CQStrings.ate,
                                            style: CQTheme.body.copyWith(
                                              color: CQColors.iron100,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Text(
                                            Formatter.formatDateTime(
                                                user.endJob),
                                            style: CQTheme.body.copyWith(
                                              color: CQColors.iron100,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 16),
                          child: Card(
                            color: CQColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    CQStrings.eventos,
                                    style: CQTheme.h1.copyWith(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 2.0),
                                    child: Divider(
                                      color: CQColors.slate100,
                                      thickness: 0.3,
                                    ),
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: state.eventos.length,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            actionEnumToString(
                                                state.eventos[index].action),
                                            style: CQTheme.body.copyWith(
                                              color: CQColors.iron100,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(
                                              Formatter.fromatHourDateTime(state
                                                  .eventos[index].timestamp),
                                              style: CQTheme.body.copyWith(
                                                color: CQColors.iron100,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SyncButtonWidget(
                      onPressed: () {
                        context.read<DetailsCubit>().fetchEvents(user.id);
                      },
                    ),
                    CheckOutButtonWidget(
                      onPressed: () {
                        String justification = '';

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Justificativa'),
                              content: TextFormField(
                                decoration: const InputDecoration(
                                  hintText: 'Justificativa',
                                ),
                                onChanged: (value) {
                                  justification = value;
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    context
                                        .read<DetailsCubit>()
                                        .createCheckoutEvento(
                                            user.id, justification);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Confirmar'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      isDisabled: !(state.eventos[0].action == 1 ||
                          user.isOnboarded == true),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return const Center(child: Text('Erro desconhecido'));
        }
      },
    );
  }
}
