import 'package:flutter/material.dart';
import 'package:treemov/core/themes/app_colors.dart';

import '../../domain/entities/report_entity.dart';

class ReportItem extends StatelessWidget {
  final ReportEntity report;
  final VoidCallback? onDownload;

  const ReportItem({super.key, required this.report, this.onDownload});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isReady = report.status == ReportStatus.ready;
    Color statusBg;
    Color statusText;

    switch (report.status) {
      case ReportStatus.ready:
        statusBg = isDark
            ? AppColors.darkCategoryStudyBg
            : AppColors.categoryStudyBg;
        statusText = isDark
            ? AppColors.darkCategoryStudyText
            : AppColors.categoryStudyText;
        break;
      case ReportStatus.generating:
        statusBg = isDark
            ? AppColors.darkCategoryGeneralBg
            : AppColors.categoryGeneralBg;
        statusText = isDark
            ? AppColors.darkCategoryGeneralText
            : AppColors.categoryGeneralText;
        break;
      case ReportStatus.error:
        statusBg = isDark
            ? AppColors.darkCategoryParentsBg
            : AppColors.categoryParentsBg;
        statusText = isDark
            ? AppColors.darkCategoryParentsText
            : AppColors.categoryParentsText;
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 0,
      color: isDark ? AppColors.darkCard : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? AppColors.darkSurface : AppColors.eventTap,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    report.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: isDark
                          ? AppColors.darkText
                          : AppColors.grayFieldText,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    report.status.title,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: statusText,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Информация о периоде и обновлении
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.directoryTextSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  report.period,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.directoryTextSecondary,
                  ),
                ),
                const SizedBox(width: 16),
                if (report.size != '—' &&
                    report.status != ReportStatus.generating)
                  Text(
                    'Размер: ${report.size}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.directoryTextSecondary,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.watch_later_outlined,
                  size: 14,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.directoryTextSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Обновлён: ${report.updateTime}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.directoryTextSecondary,
                  ),
                ),
              ],
            ),

            if (isReady) ...[
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 100,
                  height: 36,
                  child: ElevatedButton.icon(
                    onPressed: onDownload,
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text('Скачать'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.teacherPrimary,
                      foregroundColor: AppColors.white,
                      textStyle: const TextStyle(fontSize: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ),
            ] else if (report.status == ReportStatus.generating)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          isDark
                              ? AppColors.darkText
                              : AppColors.teacherPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Генерируется',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkText
                            : AppColors.teacherPrimary,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
