import 'package:dockcheck/models/document.dart';
import 'package:dockcheck/services/api_service.dart';
import '../utils/simple_logger.dart';

class DocumentRepository {
  final ApiService apiService;

  DocumentRepository(this.apiService);

  Future<Document?> createDocument(Document document) async {
    try {
      final data = await apiService.post('documents/create', document.toJson());
      SimpleLogger.info('Document created successfully');
      return Document.fromJson(data);
    } catch (error) {
      SimpleLogger.severe('Error creating document: $error');
      return null;
    }
  }

  Future<Document?> getDocument(String id) async {
    try {
      final data = await apiService.get('documents/$id');
      SimpleLogger.info('Document fetched successfully');
      return Document.fromJson(data);
    } catch (error) {
      SimpleLogger.severe('Error fetching document: $error');
      return null;
    }
  }

  Future<List<String>> getDocumentsByEmployeeId(String employeeId) async {
    try {
      final data = await apiService
          .post('documents/getByEmployeeId', {'employee_id': employeeId});
      SimpleLogger.info('Documents fetched successfully');
      return List<String>.from(data);
    } catch (error) {
      SimpleLogger.severe('Error fetching documents: $error');
      return [];
    }
  }

  Future<List<Document>> getAllDocuments() async {
    try {
      final data = await apiService.get('documents');
      SimpleLogger.info('All documents fetched successfully');
      return List<Document>.from(data.map((item) => Document.fromJson(item)));
    } catch (error) {
      SimpleLogger.severe('Error fetching all documents: $error');
      return [];
    }
  }

  Future<Document?> updateDocument(String id, Document document) async {
    try {
      final data = await apiService.put('documents/$id', document.toJson());
      SimpleLogger.info('Document updated successfully');
      return Document.fromJson(data);
    } catch (error) {
      SimpleLogger.severe('Error updating document: $error');
      return null;
    }
  }

  Future<void> deleteDocument(String id) async {
    try {
      await apiService.delete('documents/$id');
      SimpleLogger.info('Document deleted successfully');
    } catch (error) {
      SimpleLogger.severe('Error deleting document: $error');
    }
  }
}
