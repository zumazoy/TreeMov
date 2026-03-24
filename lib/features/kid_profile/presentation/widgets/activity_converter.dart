import 'package:flutter/material.dart';
import 'package:treemov/features/kid_profile/domain/student_profile_models.dart';
import 'package:treemov/shared/data/models/accrual_response_model.dart';

class ActivityConverter {
  static ActivityItemData fromAccrual(AccrualResponseModel accrual) {
    String iconPath;
    String title;

    DateTime? createdAt;
    if (accrual.createdAt != null) {
      try {
        createdAt = DateTime.parse(accrual.createdAt!);
      } catch (e) {
        debugPrint('   Ошибка парсинга даты: $e');
      }
    }

    String category = accrual.category ?? 'Активность';
    switch (category.toLowerCase()) {
      case 'attendance':
      case 'presence':
        iconPath = 'assets/images/calendar_icon.png';
        title = 'Присутствие на занятии';
        break;
      case 'homework':
        iconPath = 'assets/images/home_icon.png';
        title = 'Выполнение домашнего задания';
        break;
      case 'project':
        iconPath = 'assets/images/medal_icon.png';
        title = 'Отличный проект';
        break;
      case 'competition':
        iconPath = 'assets/images/medal_icon.png';
        title = 'Участие в конкурсе';
        break;
      case 'participation':
        iconPath = 'assets/images/team_icon.png';
        title = accrual.comment ?? 'Активность на занятии';
        break;
      case 'behavior_negative':
      case 'passive':
        iconPath = 'assets/images/alarm.png';
        title = accrual.comment ?? 'Пассивность';
        break;
      default:
        iconPath = 'assets/images/energy_icon.png';
        title = accrual.comment ?? 'Активность';
    }

    return ActivityItemData(
      title: title,
      points: accrual.amount ?? 0,
      iconPath: iconPath,
      createdAt: createdAt,
    );
  }
}
