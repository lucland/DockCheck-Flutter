import 'package:dockcheck/models/project.dart';
import 'package:dockcheck/services/api_service.dart';
import '../utils/simple_logger.dart';

class ProjectRepository {
  final ApiService apiService;

  ProjectRepository(this.apiService);

  Future<Project?> createProject(Project project) async {
    try {
      final data = await apiService.post('projects/create', project.toJson());
      SimpleLogger.info('Project created successfully');
      return Project.fromJson(data);
    } catch (error) {
      SimpleLogger.severe('Error creating project: $error');
      return null;
    }
  }

  Future<Project?> getProjectById(String projectId) async {
    try {
      final data = await apiService.get('projects/$projectId');
      SimpleLogger.info('Project fetched successfully');
      return Project.fromJson(data);
    } catch (error) {
      SimpleLogger.severe('Error fetching project: $error');
      return null;
    }
  }

  Future<List<Project>> getAllProjects() async {
    try {
      final data = await apiService.get('projects');
      SimpleLogger.info('All projects fetched successfully');
      return List<Project>.from(data.map((item) => Project.fromJson(item)));
    } catch (error) {
      SimpleLogger.severe('Error fetching all projects: $error');
      return [];
    }
  }

  Future<Project?> updateProject(String projectId, Project project) async {
    try {
      final data =
          await apiService.put('projects/$projectId', project.toJson());
      SimpleLogger.info('Project updated successfully');
      return Project.fromJson(data);
    } catch (error) {
      SimpleLogger.severe('Error updating project: $error');
      return null;
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      await apiService.delete('projects/$projectId');
      SimpleLogger.info('Project deleted successfully');
    } catch (error) {
      SimpleLogger.severe('Error deleting project: $error');
    }
  }
}
