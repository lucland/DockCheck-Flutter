import 'package:dockcheck/models/employee.dart';
import 'package:dockcheck/models/event.dart';
import 'package:dockcheck/models/user.dart';
import 'package:dockcheck/repositories/document_repository.dart';
import 'package:dockcheck/repositories/employee_repository.dart';
import 'package:dockcheck/repositories/picture_repository.dart';
import 'package:dockcheck/services/local_storage_service.dart';
import 'package:dockcheck/utils/formatter.dart';
import 'package:dockcheck/utils/simple_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/document.dart';
import '../../../repositories/authorization_repository.dart';
import '../../../repositories/event_repository.dart';
import '../../../repositories/user_repository.dart';
import '../../../repositories/vessel_repository.dart';
import 'details_state.dart';

class DetailsCubit extends Cubit<DetailsState> {
  final EmployeeRepository employeeRepository;
  final DocumentRepository documentsRepository; // Added DocumentsRepository
  final LocalStorageService localStorageService;

  DetailsCubit(this.employeeRepository, this.documentsRepository,
      this.localStorageService)
      : super(DetailsInitial());

  Future<void> getEmployeeAndDocuments(String employeeId) async {
    try {
      emit(DetailsLoading());
      Employee employee = await employeeRepository.getEmployeeById(employeeId);
      List<Document> documents =
          await documentsRepository.getDocumentByEmployeeId(employeeId);

      List<String> urls = [];
      // Fetch the documents from Firebase Storage
      if (documents.isEmpty) {
        emit(DetailsLoaded(employee, documents));
        return;
      }
      for (var document in documents) {
        try {
        } catch (e) {
          emit(DetailsError('Failed to fetch user or documents: $e'));
          SimpleLogger.warning('Failed to fetch document: $e');
        }
      }

      emit(DetailsLoaded(employee, documents, urls: urls));
    } catch (e) {
      SimpleLogger.warning('Error fetching user or documents: $e');
      emit(DetailsError('Failed to fetch user or documents: $e'));
    }
  }
}

