import 'package:dockcheck/models/employee.dart';
import 'package:dockcheck/pages/cadastrar/cadastrar.dart';
import 'package:dockcheck/pages/details/details.dart';
import 'package:dockcheck/pages/pesquisar/cubit/pesquisar_cubit.dart';
import 'package:dockcheck/pages/pesquisar/cubit/pesquisar_state.dart';
import 'package:dockcheck/repositories/employee_repository.dart';
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

class Pesquisar extends StatefulWidget {
  const Pesquisar({Key? key}) : super(key: key);

  @override
  _PesquisarState createState() => _PesquisarState();
}

class _PesquisarState extends State<Pesquisar> {
  @override
  void initState() {
    super.initState();
    context.read<PesquisarCubit>().fetchEmployees();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Container(
          color: Colors.white,
          child: Column(
            children: [
              _buildSearchBar(context),
              TabBar(
                tabs: [
                  Tab(text: 'Todos'),
                  Tab(text: 'À bordo'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildTodosTab(context),
                    _buildOnboardTab(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodosTab(BuildContext context) {
    return BlocBuilder<PesquisarCubit, PesquisarState>(
      builder: (context, state) {
        if (state is PesquisarLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PesquisarError) {
          return Center(
            child: Text('Erro: ${state.message}'),
          );
        } else if (state is PesquisarLoaded) {
          List<Employee> displayEmployees = state.employees;
          if (context.read<PesquisarCubit>().isSearching) {
            displayEmployees = displayEmployees
                .where((employee) => employee.name.toLowerCase().contains(
                    context.read<PesquisarCubit>().searchQuery.toLowerCase()))
                .toList();
          }
          displayEmployees.sort((a, b) => a.number.compareTo(b.number));
          return _buildEmployeeList(context, displayEmployees);
        } else {
          return const Center(child: Text('Erro ao carregar dados'));
        }
      },
    );
  }

  Widget _buildOnboardTab(BuildContext context) {
    return BlocBuilder<PesquisarCubit, PesquisarState>(
      builder: (context, state) {
        if (state is PesquisarLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is PesquisarError) {
          return Center(
            child: Text('Erro: ${state.message}'),
          );
        } else if (state is PesquisarLoaded) {
          List<Employee> onboardEmployees = state.employees
          //alterar depois
              .where((employee) => employee.lastAreaFound == "P1")
              .toList();
              onboardEmployees.sort((a, b) => a.number.compareTo(b.number));
          return _buildEmployeeList(context, onboardEmployees);
        } else {
          return const Center(child: Text('Erro ao carregar dados'));
        }
      },
    );
}


  Widget _buildEmployeeList(BuildContext context, List<Employee> employees) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildEmployeeListView(context, employees),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
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
                      ),
        onChanged: (value) {
          context.read<PesquisarCubit>().searchEmployee(value);
        },
      ),
    );
  }

  Widget _buildEmployeeListView(BuildContext context, List<Employee> employees) {
    return SizedBox(
      height: MediaQuery.of(context).size.height - 200,
      child: ListView.builder(
        itemCount: employees.length,
        itemBuilder: (context, index) {
          Employee employee = employees[index];
          return _buildUserListTile(context, employee);
        },
      ),
    );
  }

Widget _buildUserListTile(BuildContext context, Employee employee) {
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
        title: Text('${employee.number} - ${employee.name}', style: CQTheme.h2),
        titleAlignment: ListTileTitleAlignment.center,
        dense: true,
        visualDensity: VisualDensity.compact,
        horizontalTitleGap: 0,
        subtitle: Text(employee.cpf.toString()),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsView(employee: employee, employeeId: employee.id,),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLeadingIcon(Employee employee) {
    if (employee.lastAreaFound == "P1") {
      //is OnBoard
      return const Icon(
        Icons.circle,
        color: Colors.green,
        size: 10,
      );
    } else if (employee.lastAreaFound != "P1") {
      // Isn't onBoard
      return const Icon(
        Icons.circle,
        color: Colors.red,
        size: 10,
      );
    } else {
      return const Icon(
        Icons.circle,
        color: Colors.yellow,
        size: 10,
      );
    }
  }

  void _openRightSideModal(BuildContext context, Employee employee) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 1,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: Container(
              color: Colors.white,
              child: Text(
                'Conteúdo da modal',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        );
      },
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void openModal(BuildContext context, String s) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CadastrarModal(
           title: '',
        );
      },
    );
  }
}
