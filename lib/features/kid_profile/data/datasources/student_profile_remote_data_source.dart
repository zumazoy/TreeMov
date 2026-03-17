import 'package:treemov/core/constants/api_constants.dart';
import 'package:treemov/core/network/base/base_remote_data_source.dart';
import 'package:treemov/core/storage/secure_storage_repository.dart';
import 'package:treemov/shared/data/models/accrual_response_model.dart';
import 'package:treemov/shared/data/models/student_response_model.dart';

class StudentProfileRemoteDataSource extends BaseRemoteDataSource {
  final SecureStorageRepository _secureStorageRepository;

  StudentProfileRemoteDataSource(
    super.dioClient,
    this._secureStorageRepository,
  );

  Future<StudentResponseModel> getStudentProfile() async {
    final orgMemberId = await _secureStorageRepository.getOrgMemberId();

    if (orgMemberId == null) {
      throw Exception('ID организации не найден');
    }

    final queryParams = <String, dynamic>{'org_member_id': orgMemberId};

    try {
      final students = await getList(
        path: ApiConstants.students,
        fromJson: StudentResponseModel.fromJson,
        queryParameters: queryParams,
      );

      if (students.isEmpty) {
        throw Exception('Студент с org_member_id $orgMemberId не найден');
      }

      return students.first;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<AccrualResponseModel>> getStudentAccruals({
    required int? studentId,
    required int page,
  }) async {
    if (studentId == null) {
      throw Exception('ID ученика не указан');
    }

    final response = await rawGet(
      ApiConstants.accruals,
      queryParameters: {'student': studentId, 'page': page, 'page_size': 20},
    );

    final responseData = response.data;
    if (responseData is Map<String, dynamic> &&
        responseData['results'] != null) {
      return (responseData['results'] as List)
          .map<AccrualResponseModel>(
            (json) => AccrualResponseModel.fromJson(json),
          )
          .toList();
    } else if (responseData is List) {
      return responseData
          .map<AccrualResponseModel>(
            (json) => AccrualResponseModel.fromJson(json),
          )
          .toList();
    }
    return [];
  }
}
