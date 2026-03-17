import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';

class StudentAvatar extends StatelessWidget {
  final String? avatarUrl;
  final double size;

  const StudentAvatar({super.key, this.avatarUrl, this.size = 60});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final avatarSize = size;

    return Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurface
            : AppColors.directoryAvatarBackground,
        borderRadius: BorderRadius.circular(avatarSize / 2),
        border: Border.all(
          color: isDark ? AppColors.darkCard : AppColors.directoryAvatarBorder,
          width: 2,
        ),
      ),
      child: avatarUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(avatarSize / 2 - 2),
              child: Image.network(
                avatarUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.person,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.directoryTextSecondary,
                    size: avatarSize / 2,
                  );
                },
              ),
            )
          : Icon(
              Icons.person,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.directoryTextSecondary,
              size: avatarSize / 2,
            ),
    );
  }
}
