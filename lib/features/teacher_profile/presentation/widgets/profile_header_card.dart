import 'package:flutter/material.dart';
import 'package:treemov/core/themes/app_text_styles.dart';
import 'package:treemov/shared/data/models/org_member_response_model.dart';

class ProfileHeaderCard extends StatelessWidget {
  final OrgMemberResponseModel? orgMember;

  const ProfileHeaderCard({super.key, required this.orgMember});

  String _getFullName() {
    if (orgMember == null) {
      return 'Профиль null';
    }
    final profile = orgMember?.profile;
    if (profile == null) return 'Не указано';

    final parts = [
      profile.surname,
      profile.name,
      profile.patronymic,
    ].where((part) => part != null && part.isNotEmpty).toList();

    return parts.isEmpty ? 'ФИО не указано' : parts.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary.withAlpha(51),
              border: Border.all(color: theme.colorScheme.primary, width: 1.5),
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
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getFullName(),
                  style: AppTextStyles.ttNorms16W700.themed(context),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  ' ', // teacherProfile != null
                  //     ? teacherProfile!.teacher?.employee.email ??
                  //           'Заглушка должности'
                  //     : 'Профиль null',
                  style: AppTextStyles.ttNorms12W400.grey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
