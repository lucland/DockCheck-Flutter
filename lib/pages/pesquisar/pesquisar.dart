import 'package:cripto_qr_googlemarine/pages/details/details.dart';
import 'package:cripto_qr_googlemarine/pages/home/home.dart';
import 'package:cripto_qr_googlemarine/utils/theme.dart';
import 'package:cripto_qr_googlemarine/utils/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/user/user_cubit.dart';
import '../../blocs/user/user_state.dart';
import '../../models/user.dart';
import '../../repositories/user_repository.dart';
import '../../utils/ui/strings.dart';

class Pesquisar extends StatelessWidget {
  const Pesquisar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit(UserRepository()),
      child: Container(
        color: CQColors.white,
        child: const UserListView(),
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
              Expanded(
                child: ListView.builder(
                  itemCount: state.users.length,
                  itemBuilder: (context, index) {
                    User user = state.users[index];
                    return _buildUserListTile(context, user);
                  },
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
        title: Text(user.nome, style: CQTheme.h2),
        titleAlignment: ListTileTitleAlignment.center,
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
