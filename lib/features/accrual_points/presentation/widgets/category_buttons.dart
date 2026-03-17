import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_text_styles.dart';
import '../../domain/entities/point_category_entity.dart';

class CategoryButtons extends StatelessWidget {
  final PointCategory? selectedCategory;
  final Function(PointCategory) onCategorySelected;

  const CategoryButtons({
    super.key,
    this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildCategoryButton(
                context,
                category: PointCategory.participation,
                label: 'Участие',
                iconPath: 'assets/images/team_icon.png',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildCategoryButton(
                context,
                category: PointCategory.behavior,
                label: 'Поведение',
                iconPath: 'assets/images/medal_icon.png',
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildCategoryButton(
                context,
                category: PointCategory.achievements,
                label: 'Достижения',
                iconPath: 'assets/images/achievement_icon.png',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildCategoryButton(
                context,
                category: PointCategory.homework,
                label: 'ДЗ',
                iconPath: 'assets/images/home_icon.png',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoryButton(
    BuildContext context, {
    required PointCategory category,
    required String label,
    required String iconPath,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = selectedCategory == category;

    Color bgColor;
    Color textColor;
    Color iconColor;
    Color borderColor;

    if (isSelected) {
      bgColor = AppColors.teacherPrimary;
      textColor = AppColors.white;
      iconColor = AppColors.white;
      borderColor = AppColors.teacherPrimary;
    } else {
      bgColor = isDark ? AppColors.darkSurface : AppColors.eventTap;
      textColor = isDark ? AppColors.darkText : AppColors.teacherPrimary;
      iconColor = isDark ? AppColors.darkText : AppColors.teacherPrimary;
      borderColor = isDark ? AppColors.darkSurface : AppColors.teacherPrimary;
    }

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: TextButton(
        onPressed: () => onCategorySelected(category),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: 20,
              height: 20,
              color: iconColor,
              errorBuilder: (context, error, stackTrace) {
                IconData fallbackIcon;
                switch (category) {
                  case PointCategory.participation:
                    fallbackIcon = Icons.people;
                    break;
                  case PointCategory.behavior:
                    fallbackIcon = Icons.emoji_events;
                    break;
                  case PointCategory.achievements:
                    fallbackIcon = Icons.stars;
                    break;
                  case PointCategory.homework:
                    fallbackIcon = Icons.home;
                    break;
                }
                return Icon(fallbackIcon, size: 20, color: iconColor);
              },
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.arial12W700.copyWith(color: textColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
