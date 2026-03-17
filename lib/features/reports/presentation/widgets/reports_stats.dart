import 'package:flutter/material.dart';
import 'package:treemov/core/themes/app_colors.dart';
import 'package:treemov/core/themes/app_text_styles.dart';

class ReportsStats extends StatelessWidget {
  final int totalReports;
  final int thisWeekCount;
  final int thisMonthCount;

  const ReportsStats({
    super.key,
    required this.totalReports,
    required this.thisWeekCount,
    required this.thisMonthCount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 90,
      child: Row(
        children: [
          Expanded(
            child: _buildStatContainer(
              count: totalReports,
              title: 'Готовых отчетов',
              bgColor: isDark
                  ? AppColors.darkCategoryStudyBg
                  : AppColors.statsTotalBg,
              borderColor: isDark
                  ? AppColors.darkCategoryStudyText.withAlpha(77)
                  : AppColors.statsTotalBorder,
              countColor: isDark
                  ? AppColors.darkCategoryStudyText
                  : AppColors.statsTotalText,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatContainer(
              count: thisWeekCount,
              title: 'За эту неделю',
              bgColor: isDark
                  ? AppColors.darkEventTap
                  : AppColors.statsPinnedBg,
              borderColor: isDark
                  ? AppColors.teacherPrimary.withAlpha(77)
                  : AppColors.statsPinnedBorder,
              countColor: isDark
                  ? AppColors.darkText
                  : AppColors.statsPinnedText,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildStatContainer(
              count: thisMonthCount,
              title: 'Всего за месяц',
              bgColor: isDark ? AppColors.darkSurface : AppColors.statsTodayBg,
              borderColor: isDark
                  ? AppColors.darkTextSecondary.withAlpha(77)
                  : AppColors.statsTodayBorder,
              countColor: isDark
                  ? AppColors.darkText
                  : AppColors.statsTodayText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatContainer({
    required int count,
    required String title,
    required Color bgColor,
    required Color borderColor,
    required Color countColor,
  }) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.5),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count.toString(),
            style: AppTextStyles.ttNorms20W700.copyWith(color: countColor),
          ),
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.arial11W400.copyWith(color: countColor),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
