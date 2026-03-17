import 'package:treemov/core/constants/api_constants.dart';
import 'package:treemov/core/network/base/base_remote_data_source.dart';
import 'package:treemov/core/storage/secure_storage_repository.dart';
import 'package:treemov/shared/data/models/lesson_response_model.dart';
import 'package:treemov/shared/data/models/org_member_response_model.dart';
import 'package:treemov/shared/data/models/student_group_member_response_model.dart';
import 'package:treemov/shared/data/models/student_group_response_model.dart';

class SharedRemoteDataSource extends BaseRemoteDataSource {
  final SecureStorageRepository _secureStorageRepository;

  SharedRemoteDataSource(super.dioClient, this._secureStorageRepository);

  Future<OrgMemberResponseModel> getMyOrgMember() async {
    final orgMemberId = await _secureStorageRepository.getOrgMemberId();
    final orgMembers = await getList(
      path: ApiConstants.orgs + ApiConstants.me,
      fromJson: OrgMemberResponseModel.fromJson,
    );

    final orgMember = orgMembers.firstWhere(
      (member) => member.id.toString() == orgMemberId,
      orElse: () => throw Exception('Организация с id $orgMemberId не найдена'),
    );

    return orgMember;
  }

  Future<List<LessonResponseModel>> getLessons(
    DateTime dateMin,
    DateTime dateMax,
  ) {
    return getList(
      path: ApiConstants.lessons + ApiConstants.me,
      fromJson: LessonResponseModel.fromJson,
      queryParameters: {
        'date_min': dateMin.toIso8601String(),
        'date_max': dateMax.toIso8601String(),
      },
    );
  }

  Future<List<GroupStudentsResponseModel>> getGroupStudents() {
    return getList(
      path: ApiConstants.studentGroups,
      fromJson: GroupStudentsResponseModel.fromJson,
    );
  }

  Future<List<StudentInGroupResponseModel>> getStudentsInGroup(int groupId) {
    return getList(
      path: ApiConstants.studentGroupMembers,
      fromJson: StudentInGroupResponseModel.fromJson,
      queryParameters: {'student_group__id': groupId},
    );
  }
}
