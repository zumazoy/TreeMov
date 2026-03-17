import 'package:treemov/core/constants/api_constants.dart';
import 'package:treemov/core/network/base/base_remote_data_source.dart';
import 'package:treemov/shared/data/models/student_group_response_model.dart';
import 'package:treemov/shared/data/models/student_response_model.dart';

class RatingRemoteDataSource extends BaseRemoteDataSource {
  RatingRemoteDataSource(super.dioClient);

  Future<List<StudentResponseModel>> getAllStudents() {
    return getList(
      path: ApiConstants.students,
      fromJson: StudentResponseModel.fromJson,
    );
  }

  Future<List<StudentResponseModel>> getStudentsByGroup(int groupId) {
    return getList(
      path: ApiConstants.studentGroupMembers,
      fromJson: (json) {
        if (json.containsKey('student')) {
          return StudentResponseModel.fromJson(json['student']);
        }
        return StudentResponseModel.fromJson(json);
      },
      queryParameters: {'student_group__id': groupId},
    );
  }

  Future<List<GroupStudentsResponseModel>> getStudentGroups() {
    return getList(
      path: ApiConstants.studentGroups,
      fromJson: GroupStudentsResponseModel.fromJson,
    );
  }
}
