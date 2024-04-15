import 'package:dockcheck/models/project.dart';
import 'package:dockcheck/models/employee.dart'; // Importe o modelo de Employee
import 'package:dockcheck/pages/home/cubit/home_cubit.dart';
import 'package:dockcheck/pages/home/cubit/home_state.dart';
import 'package:dockcheck/pages/pesquisar/cubit/pesquisar_cubit.dart';
import 'package:dockcheck/repositories/employee_repository.dart';
import 'package:dockcheck/repositories/sensor_repository.dart'; // Importe o repositório do sensor
import 'package:dockcheck/utils/ui/colors.dart';
import 'package:dockcheck/widgets/semi_circle_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../utils/theme.dart';
import '../details/details.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Employee> employeesInSensor = []; 
  int fetchDataVesselLenght = 0;
  int fetchDataDiqueLenght = 0;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    List<Employee> employees = await context.read<EmployeeRepository>().getAllEmployees();
    setState(() {
      employeesInSensor = employees;
    });
  }

  Future<void> _fetchDataVesselLenght() async {
    List<Employee> VesselLenght = await context.read<SensorRepository>().getAllEmployeesFound();
    setState(() {
      fetchDataVesselLenght = VesselLenght as int;
    });
  }

  Future<void> _fetchDataDiqueLenght() async {
    List<Employee> DiqueLenght = await context.read<SensorRepository>().getAllEmployeesFound();
    setState(() {
      fetchDataDiqueLenght = DiqueLenght as int;
    });
  }

  @override
  Widget build(BuildContext context) {
    context.read<HomeCubit>().fetchProjects();

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.isLoading) {
          return SizedBox(
            width: MediaQuery.of(context).size.width - 300,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (!state.isLoading && state.projects.isNotEmpty) {
          List<Project> allHome = state.projects;

          return Container(
            color: CQColors.background,
            width: MediaQuery.of(context).size.width - 300,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: allHome.length,
                        itemBuilder: (context, index) {
                          Project project = allHome[index];
                          return _buildProjectListTile(context, project);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Nenhum projeto encontrado',
                style: CQTheme.h2.copyWith(
                  color: CQColors.iron100,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildProjectListTile(BuildContext context, Project project) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: Row(
            children: [
              Text(
                '${project.name}',
                style: CQTheme.h3.copyWith(
                  color: CQColors.iron100,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _buildFirstDecoratedContainer(
                      _buildFirstContainer()
                      ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _buildSecondDecoratedContainer(
                      _buildSecondContainer()
                      ),
                  ),
                ],
              ),
              _buildThirdDecoratedContainer(
                _buildThirdContainer(employeesInSensor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFirstDecoratedContainer(Widget child) {
    return Stack(
      children: [
        child,
        Positioned(
          top: 50,
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
          top: 50,
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
          bottom: 54,
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
          bottom: 54,
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
    );
  }

  Widget _buildSecondDecoratedContainer(Widget child) {
    return Stack(
      children: [
        child,
        Positioned(
          top: 50,
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
          bottom: 54,
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
    );
  }

  Widget _buildThirdDecoratedContainer(Widget child) {
    return Stack(
      children: [
        child,
        Positioned(
          top: 65,
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
          top: 65,
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
          bottom: 50,
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
    );
  }

  Widget _buildFirstContainer() {
    return Container(
      decoration: BoxDecoration(
        color: CQColors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: CQColors.success100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            child: Center(
              child: Text(
                'Dique Seco',
                style: CQTheme.h3.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '12',
                  style: CQTheme.h3.copyWith(
                    color: Colors.black,
                    fontSize: 120,
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: CQColors.slate100,
                        size: 14,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Atualizado às: ' + DateFormat('HH:mm').format(DateTime.now()).toString(),
                        style: CQTheme.body.copyWith(
                          color: CQColors.slate100,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondContainer() {
    return Container(
      margin: const EdgeInsets.only(left: 8.0),
      decoration: BoxDecoration(
        color: CQColors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: CQColors.forange110,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            child: Center(
              child: Text(
                'Embarcação',
                style: CQTheme.h3.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '20',
                  style: CQTheme.h3.copyWith(
                    color: Colors.black,
                    fontSize: 120,
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: CQColors.slate100,
                        size: 14,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Atualizado às: ' + DateFormat('HH:mm').format(DateTime.now()).toString(),
                        style: CQTheme.body.copyWith(
                          color: CQColors.slate100,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThirdContainer(List<Employee> employees) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      decoration: BoxDecoration(
        color: CQColors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: CQColors.iron100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            child: Center(
              child: Text(
                'Pessoas avistadas',
                style: CQTheme.h3.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Total: ${employees.length}',
                    style: CQTheme.h3.copyWith(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Divider(),
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(), // Desabilita o scroll da ListView
                  shrinkWrap: true,
                  itemCount: employees.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Nome:',
                          style: CQTheme.body.copyWith(
                              color: CQColors.iron60,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            '${employees[index].name}',
                            style: CQTheme.h3.copyWith(
                              color: CQColors.iron100,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      trailing: Text(
                        '${employees[index].documentsOk}',
                        style: CQTheme.h1.copyWith(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    );
                  },
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: CQColors.slate100,
                        size: 14,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Atualizado às: ' +
                            DateFormat('HH:mm').format(DateTime.now()).toString(),
                        style: CQTheme.body.copyWith(
                          color: CQColors.slate100,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
