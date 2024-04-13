import 'package:dockcheck/models/project.dart';
import 'package:dockcheck/pages/home/cubit/home_cubit.dart';
import 'package:dockcheck/pages/home/cubit/home_state.dart';
import 'package:dockcheck/utils/ui/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/theme.dart';
import '../details/details.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    context.read<HomeCubit>().fetchProjects();

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().fetchProjects();
  }

  @override
  void dispose() {
    super.dispose();
  }

    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.isLoading) {
          return SizedBox(
              width: MediaQuery.of(context).size.width - 300,
              child: const Center(
                child: CircularProgressIndicator(),
              ));
        } else if (!state.isLoading && state.projects.isNotEmpty) {
          List<Project> allHome = state.projects;

          return Container(
            color: CQColors.background,
            width: MediaQuery.of(context).size.width - 300,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListView.builder(
                        itemCount: allHome.length,
                        itemBuilder: (context, index) {
                          //Employee employee = displayEmployees[index];
                          Project project = allHome[index];
                          return _buildProjectListTile(context, project);
                        },
                      ),
                    ),
                  ),
                ],
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
    return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.width * 0.1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(0.0),
                            ),
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              
              Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: CQColors.white,
                ),
                child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: CQColors.danger100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                '${project.name}',
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
                Text('De: ${'${project.dateStart.day}/${project.dateStart.month}/${project.dateStart.year}'}  Até: ${'${project.dateEnd.day}/${project.dateEnd.month}/${project.dateEnd.year}'}',
                style: CQTheme.h3.copyWith(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
                Text('Local: ${project.address}',
                style: CQTheme.h3.copyWith(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
                Center(
                  child: Text(
                    'Total: 1',
                    style: CQTheme.h3.copyWith(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  title: Text(
                    'Nome: aa',
                    style: CQTheme.h3.copyWith(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                  trailing: Text(
                    'aa',
                    style: CQTheme.h1.copyWith(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.info_outline, color: CQColors.slate100, size: 14),
                      const SizedBox(width: 8),
                      Text(
                        'Atualizado em: 1',
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
              ),
              ),
            ],
          ),
        ),
        );
        
  }
}
