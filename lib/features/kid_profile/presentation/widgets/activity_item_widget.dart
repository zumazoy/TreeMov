import 'package:flutter/material.dart';
import 'package:treemov/core/themes/app_colors.dart';
import 'package:treemov/core/themes/app_text_styles.dart';

class ActivityItemWidget extends StatelessWidget {
  final String title;
  final int points;
  final String iconPath;
  final Color circleColor;
  final Color iconColor;
  final DateTime? createdAt;

  const ActivityItemWidget({
    super.key,
    required this.title,
    required this.points,
    required this.iconPath,
    required this.circleColor,
    required this.iconColor,
    this.createdAt,
  });

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Сегодня в ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Вчера в ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${_getDaysWord(difference.inDays)} назад';
    } else {
      return '${date.day}.${date.month}.${date.year}';
    }
  }

  String _getDaysWord(int days) {
    if (days % 10 == 1 && days % 100 != 11) {
      return 'день';
    } else if (days % 10 >= 2 &&
        days % 10 <= 4 &&
        (days % 100 < 10 || days % 100 >= 20)) {
      return 'дня';
    } else {
      return 'дней';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPositive = points > 0;
    final pointsText = isPositive ? '+$points' : points.toString();
    final pointsColor = isPositive ? AppColors.statsTotalText : Colors.red;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: circleColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Image.asset(
                iconPath,
                width: 20,
                height: 20,
                color: iconColor,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.star, size: 20, color: iconColor);
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.ttNorms14W600.copyWith(
                    color: AppColors.notesDarkText,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (createdAt != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    _formatDate(createdAt!),
                    style: AppTextStyles.ttNorms12W400.copyWith(
                      color: AppColors.directoryTextSecondary.withAlpha(179),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            pointsText,
            style: AppTextStyles.ttNorms18W700.copyWith(color: pointsColor),
          ),
        ],
      ),
    );
  }
}
