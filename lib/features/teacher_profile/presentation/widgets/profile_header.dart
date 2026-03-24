import 'package:flutter/material.dart';
import 'package:treemov/core/themes/app_text_styles.dart';
import 'package:treemov/shared/data/models/org_member_response_model.dart';

class ProfileHeader extends StatelessWidget {
  final OrgMemberResponseModel orgMember;

  const ProfileHeader({super.key, required this.orgMember});

  String _getFullName() {
    final profile = orgMember.profile;
    if (profile == null) return 'Не указано';

    final parts = [
      profile.surname,
      profile.name,
      profile.patronymic,
    ].where((part) => part != null && part.isNotEmpty).toList();

    return parts.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.cardColor,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.primary.withAlpha(128),
                width: 4,
              ),
              borderRadius: BorderRadius.circular(40),
            ),
            child: CircleAvatar(
              radius: 36,
              backgroundColor: theme.colorScheme.primary.withAlpha(26),
              child: Icon(
                Icons.person,
                size: 32,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 16),

          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getFullName(),
                    style: AppTextStyles.arial18W700.themed(context),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    ' ', // teacherProfile.teacher?.employee.email ??
                    //     'Заглушка должности',
                    style: AppTextStyles.arial14W400.grey,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
