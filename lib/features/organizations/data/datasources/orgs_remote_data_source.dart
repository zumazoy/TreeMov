import 'package:treemov/core/constants/api_constants.dart';
import 'package:treemov/core/network/base/base_remote_data_source.dart';
import 'package:treemov/features/organizations/data/models/invite_response_model.dart';
import 'package:treemov/shared/data/models/org_member_response_model.dart';

class OrgsRemoteDataSource extends BaseRemoteDataSource {
  OrgsRemoteDataSource(super.dioClient);

  Future<List<OrgMemberResponseModel>> getMyOrgs() {
    return getList(
      path: ApiConstants.orgs + ApiConstants.me,
      fromJson: OrgMemberResponseModel.fromJson,
    );
  }

  Future<List<InviteResponseModel>> getMyInvites() {
    return getList(
      path: ApiConstants.invites + ApiConstants.me,
      fromJson: InviteResponseModel.fromJson,
      queryParameters: {'status': 'sending'},
    );
  }

  Future<bool> acceptInvite(String uuid) {
    return postBool(
      path: ApiConstants.acceptInvite,
      queryParameters: {'uuid': uuid},
    );
  }
}
