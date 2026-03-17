import 'package:flutter/material.dart';
import 'package:treemov/core/themes/app_colors.dart';

enum ReportFilterCategory {
  performance('Успеваемость', 4),
  attendance('Посещаемость', 4),
  rating('Баллы', 2),
  other('Другое', 24);

  final String title;
  final int mockCount;

  const ReportFilterCategory(this.title, this.mockCount);
}

class ReportFilterCategoriesSection extends StatelessWidget {
  final ReportFilterCategory? selectedCategory;
  final Function(ReportFilterCategory) onCategorySelected;

  const ReportFilterCategoriesSection({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  final List<ReportFilterCategory> _categories = ReportFilterCategory.values;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Категория:',
          style: TextStyle(
            fontFamily: 'Arial',
            fontWeight: FontWeight.w700,
            fontSize: 16,
            height: 1.0,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.directoryTextSecondary,
          ),
        ),
        const SizedBox(height: 12),

        ..._categories.map((category) {
          return Column(
            children: [
              _ReportCategoryItem(
                category: category,
                isSelected: selectedCategory == category,
                onSelected: () => onCategorySelected(category),
              ),
              if (_categories.indexOf(category) < _categories.length - 1)
                const SizedBox(height: 8),
            ],
          );
        }),
      ],
    );
  }
}

class _ReportCategoryItem extends StatelessWidget {
  final ReportFilterCategory category;
  final bool isSelected;
  final VoidCallback onSelected;

  const _ReportCategoryItem({
    required this.category,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.darkEventTap : AppColors.eventTap)
              : (isDark ? AppColors.darkSurface : AppColors.white),
          border: Border.all(
            color: isSelected
                ? AppColors.teacherPrimary
                : (isDark ? AppColors.darkSurface : AppColors.eventTap),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                category.title,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: isDark ? AppColors.darkText : AppColors.notesDarkText,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                category.mockCount.toString(),
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.notesDarkText,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.teacherPrimary
                      : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.directoryTextSecondary),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark
                              ? AppColors.darkText
                              : AppColors.teacherPrimary,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
