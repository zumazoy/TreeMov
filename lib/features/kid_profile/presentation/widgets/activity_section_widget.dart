import 'package:flutter/material.dart';
import 'package:treemov/core/themes/app_colors.dart';
import 'package:treemov/core/themes/app_text_styles.dart';

import '../../domain/student_profile_models.dart';
import 'activity_item_widget.dart';

class ActivitySectionWidget extends StatelessWidget {
  final List<ActivityItemData> activities;
  final bool isLoading;

  const ActivitySectionWidget({
    super.key,
    required this.activities,
    this.isLoading = false,
  });

  Color _getCircleColor(String title) {
    if (title.contains('Пассивность') || title.contains('Мешал')) {
      return AppColors.activityRedWithOpacity;
    } else if (title.contains('Присутствие')) {
      return AppColors.activityBlueWithOpacity;
    } else if (title.contains('конкурсе') ||
        title.contains('Отличный проект')) {
      return AppColors.activityCream;
    } else if (title.contains('домашнего')) {
      return AppColors.activityPurpleWithOpacity;
    } else if (title.contains('Активность')) {
      return AppColors.activityBlueWithOpacity;
    }
    return Colors.grey.withAlpha(0x26);
  }

  Color _getIconColor(String title) {
    if (title.contains('Пассивность') || title.contains('Мешал')) {
      return AppColors.activityRed;
    } else if (title.contains('Присутствие')) {
      return AppColors.activityBlue;
    } else if (title.contains('конкурсе') ||
        title.contains('Отличный проект')) {
      return AppColors.achievementGold;
    } else if (title.contains('домашнего')) {
      return AppColors.activityPurple;
    } else if (title.contains('Активность')) {
      return AppColors.activityBlue;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty && !isLoading) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/clock_icon.png',
                  width: 20,
                  height: 20,
                  color: AppColors.kidButton,
                ),
                const SizedBox(width: 8),
                Text(
                  'Последняя активность',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'TT Norms',
                    color: AppColors.notesDarkText,
                    height: 1.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.history,
                    size: 48,
                    color: AppColors.directoryTextSecondary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Нет активностей',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.directoryTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/clock_icon.png',
                width: 20,
                height: 20,
                color: AppColors.kidButton,
              ),
              const SizedBox(width: 8),
              Text(
                'Последняя активность',
                style: AppTextStyles.ttNorms18W700.copyWith(
                  color: AppColors.notesDarkText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length + (isLoading ? 1 : 0),
            separatorBuilder: (context, index) => const SizedBox(height: 0),
            itemBuilder: (context, index) {
              if (index == activities.length) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              final activity = activities[index];
              return ActivityItemWidget(
                title: activity.title,
                points: activity.points,
                iconPath: activity.iconPath,
                circleColor: _getCircleColor(activity.title),
                iconColor: _getIconColor(activity.title),
                createdAt: activity.createdAt,
              );
            },
          ),
        ],
      ),
    );
  }
}
