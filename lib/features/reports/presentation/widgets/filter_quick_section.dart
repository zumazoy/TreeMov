import 'package:flutter/material.dart';
import 'package:treemov/core/themes/app_colors.dart';

enum ReportQuickFilter {
  thisWeek('Эта неделя', 2),
  thisMonth('Месяц', 14);

  final String title;
  final int mockCount;

  const ReportQuickFilter(this.title, this.mockCount);
}

class ReportFilterQuickSection extends StatelessWidget {
  final ReportQuickFilter? selectedFilter;
  final Function(ReportQuickFilter) onFilterSelected;

  const ReportFilterQuickSection({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  final List<ReportQuickFilter> _filters = ReportQuickFilter.values;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Быстрый фильтр:',
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

        ..._filters.map((filter) {
          return Column(
            children: [
              _ReportQuickFilterItem(
                filter: filter,
                isSelected: selectedFilter == filter,
                onSelected: () => onFilterSelected(filter),
              ),
              if (_filters.indexOf(filter) < _filters.length - 1)
                const SizedBox(height: 8),
            ],
          );
        }),
      ],
    );
  }
}

class _ReportQuickFilterItem extends StatelessWidget {
  final ReportQuickFilter filter;
  final bool isSelected;
  final VoidCallback onSelected;

  const _ReportQuickFilterItem({
    required this.filter,
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
                filter.title,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  height: 1.0,
                  color: isDark ? AppColors.darkText : AppColors.notesDarkText,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                filter.mockCount.toString(),
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
            const SizedBox(width: 10),
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
