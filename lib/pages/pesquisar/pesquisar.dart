import 'package:dockcheck/pages/details/details.dart';
import 'package:dockcheck/utils/theme.dart';
import 'package:dockcheck/utils/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../blocs/user/user_cubit.dart';
import '../../blocs/user/user_state.dart';
import '../../models/user.dart';
import '../../repositories/user_repository.dart';
import '../../utils/ui/strings.dart';

class Pesquisar extends StatelessWidget {
  const Pesquisar({super.key});

  @override
  Widget build(BuildContext context) {
    // Get UserRepository from Provider
    final userRepository = Provider.of<UserRepository>(context, listen: false);

    return BlocProvider(
      // Use the provided UserRepository
      create: (context) => UserCubit(userRepository),
      child: DefaultTabController(
        length: 2,
        child: Container(
          color: CQColors.white,
          child: const UserListView(),
        ),
      ),
    );
  }
}

class UserListView extends StatelessWidget {
  const UserListView({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<UserCubit>().fetchUsers();

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is UserError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is UserLoaded) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 11.5),
                    hintText: CQStrings.pesquisar,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: CQColors.slate100,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: CQColors.slate100,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        color: CQColors.slate100,
                        width: 1,
                      ),
                    ),
                    suffixIcon: GestureDetector(
                        onTap: () => context.read<UserCubit>().fetchUsers(),
                        child: const Icon(Icons.search_rounded)),
                  ),
                  onSubmitted: (value) {
                    context.read<UserCubit>().searchUsers(value);
                  },
                ),
              ),
              const TabBar(
                tabs: [
                  Tab(text: CQStrings.todos),
                  Tab(text: CQStrings.aBordo),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    ListView.builder(
                      itemCount: state.users.length,
                      itemBuilder: (context, index) {
                        User user = state.users[index];
                        return _buildUserListTile(context, user);
                      },
                    ),
                    ListView.builder(
                      itemCount: state.users.length,
                      itemBuilder: (context, index) {
                        User user = state.users[index];
                        if (user.isOnboarded) {
                          return _buildUserListTile(context, user);
                        } else {
                          return Container(); // Return an empty container if isOnboarded is false
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          return const Center(child: Text(CQStrings.nenhumUsuarioEncontrado));
        }
      },
    );
  }

  Widget _buildUserListTile(BuildContext context, User user) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: CQColors.slate100,
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        trailing:
            const Icon(Icons.chevron_right_rounded, color: CQColors.slate100),
        title: Text(user.name, style: CQTheme.h2),
        titleAlignment: ListTileTitleAlignment.center,
        dense: true,
        visualDensity: VisualDensity.compact,
        horizontalTitleGap: 0,
        leading: user.isOnboarded
            ? const Icon(
                Icons.circle,
                color: CQColors.success100,
                size: 10,
              )
            : const Icon(
                Icons.circle,
                color: CQColors.danger100,
                size: 10,
              ),
        subtitle: Text(user.identidade),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Details(user: user),
            ),
          );
        },
      ),
    );
  }
}
