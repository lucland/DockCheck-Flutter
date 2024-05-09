import 'package:dockcheck/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dockcheck/pages/details/details.dart';
import 'package:dockcheck/models/employee.dart';
import 'package:dockcheck/pages/pesquisar/cubit/pesquisar_cubit.dart';
import 'package:dockcheck/pages/pesquisar/cubit/pesquisar_state.dart';

import '../../utils/ui/colors.dart';

class Pesquisar extends StatefulWidget {
  const Pesquisar({Key? key}) : super(key: key);

  @override
  _PesquisarState createState() => _PesquisarState();
}

class _PesquisarState extends State<Pesquisar> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<PesquisarCubit>().fetchEmployees();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<PesquisarCubit>().fetchMoreEmployees();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                _buildSearchBar(context),
                const TabBar(
                  tabs: [
                    Tab(text: 'Todos'),
                    Tab(text: 'À bordo'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildEmployeeListTab(context),
                      _buildEmployeeListTab(context, onboardOnly: true),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 11.5),
          hintText: 'Pesquisar',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.blue,
              width: 1,
            ),
          ),
        ),
        onChanged: (value) {
          context.read<PesquisarCubit>().searchEmployees(value);
        },
      ),
    );
  }

  Widget _buildEmployeeListTab(BuildContext context,
      {bool onboardOnly = false}) {
    return BlocBuilder<PesquisarCubit, PesquisarState>(
      builder: (context, state) {
        if (state is PesquisarLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PesquisarLoaded) {
          List<Employee> employees =
              onboardOnly ? state.employeesOnboarded : state.employees;

          return ListView.builder(
            controller: _scrollController,
            itemCount:
                state.hasReachedMax ? employees.length : employees.length + 1,
            itemBuilder: (context, index) {
              return index >= employees.length
                  ? const Center()
                  : _buildUserListTile(context, employees[index]);
            },
          );
        } else if (state is PesquisarError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const Center(child: Text('No data found'));
      },
    );
  }

  Widget _buildUserListTile(BuildContext context, Employee employee) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${employee.number} - ${employee.name}',
            style: CQTheme.h3.copyWith(
              color: CQColors.iron100,
              fontSize: 14,
            ),
          ),
          Text(
            '${employee.thirdCompanyId} - ${employee.role}',
            style: CQTheme.body.copyWith(
              color: CQColors.iron60,
              fontSize: 13,
            ),
          ),
        ],
      ),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    DetailsView(employeeId: employee.id, employee: employee)));
      },
    );
  }
}
