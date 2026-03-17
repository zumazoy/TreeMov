import 'package:flutter/material.dart';
import 'package:treemov/core/themes/app_colors.dart';
import 'package:treemov/core/themes/app_text_styles.dart';
import 'package:treemov/shared/domain/entities/student_entity.dart';

import '../../domain/entities/point_category_entity.dart';

class PointsSnackBar {
  static void show({
    required BuildContext context,
    required StudentEntity student,
    required PointAction action,
  }) {
    final isPositive = action.points > 0;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color backgroundColor;
    if (isPositive) {
      backgroundColor = isDark
          ? AppColors.darkCategoryStudyBg
          : AppColors.teacherPrimary;
    } else {
      backgroundColor = isDark
          ? AppColors.darkCategoryGeneralBg
          : AppColors.activityRed;
    }

    final studentName = student.name ?? '';
    final actionText = isPositive ? 'Начислено' : 'Списано';
    final pointsText =
        '${action.points.abs()} ${_getPointsWord(action.points.abs())}';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isPositive ? Icons.add_circle : Icons.remove_circle,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    studentName,
                    style: AppTextStyles.arial12W400.white,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '$actionText $pointsText',
                    style: AppTextStyles.arial14W500.white,
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: isDark
              ? BorderSide(
                  color: isPositive
                      ? AppColors.darkCategoryStudyText
                      : AppColors.darkCategoryGeneralText,
                  width: 1,
                )
              : BorderSide.none,
        ),
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(16),
        elevation: isDark ? 4 : 6,
      ),
    );
  }

  static String _getPointsWord(int count) {
    if (count % 10 == 1 && count % 100 != 11) {
      return 'балл';
    } else if (count % 10 >= 2 &&
        count % 10 <= 4 &&
        (count % 100 < 10 || count % 100 >= 20)) {
      return 'балла';
    } else {
      return 'баллов';
    }
  }
}
