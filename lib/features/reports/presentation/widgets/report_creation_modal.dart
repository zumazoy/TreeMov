import 'package:flutter/material.dart';
import 'package:treemov/core/themes/app_colors.dart';

import 'report_selection_card.dart';

// Enum для типов отчетов (для первого шага)
enum ReportType {
  performance, // Успеваемость
  attendance, // Посещаемость
  rating, // Рейтинг по баллам
}

// Enum для выбора периода (для второго шага)
enum ReportPeriod {
  monthly, // За месяц
  quarterly, // За четверть
  custom, // Произвольный период
}

class ReportCreationModal extends StatefulWidget {
  // Добавлены параметры для передачи в BLoC
  final Function(
    ReportType type,
    ReportPeriod periodType,
    DateTime? startDate,
    DateTime? endDate,
    bool includeGraphs,
    bool includeDetails,
  )
  onReportCreated;

  const ReportCreationModal({super.key, required this.onReportCreated});

  static Future<void> show({
    required BuildContext context,
    required Function(
      ReportType type,
      ReportPeriod periodType,
      DateTime? startDate,
      DateTime? endDate,
      bool includeGraphs,
      bool includeDetails,
    )
    onReportCreated,
  }) {
    return showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        child: ReportCreationModal(onReportCreated: onReportCreated),
      ),
    );
  }

  @override
  State<ReportCreationModal> createState() => _ReportCreationModalState();
}

class _ReportCreationModalState extends State<ReportCreationModal> {
  int _currentStep = 1;
  ReportType? _selectedReportType;
  ReportPeriod _selectedPeriod = ReportPeriod.monthly;
  bool _includeGraphs = true;
  bool _includeDetails = false;

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  void _nextStep() {
    if (_currentStep == 1 && _selectedReportType != null) {
      setState(() => _currentStep = 2);
    }
  }

  void _backStep() {
    setState(() => _currentStep = 1);
  }

  void _createReport() {
    // Определяем даты для отправки в BLoC
    DateTime? finalStartDate = _selectedPeriod == ReportPeriod.custom
        ? _startDate
        : null;
    DateTime? finalEndDate = _selectedPeriod == ReportPeriod.custom
        ? _endDate
        : null;

    widget.onReportCreated(
      _selectedReportType!,
      _selectedPeriod,
      finalStartDate,
      finalEndDate,
      _includeGraphs,
      _includeDetails,
    );
    Navigator.of(context).pop();
  }

  Future<void> _selectDate(bool isStart) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final initialDate = isStart ? _startDate : _endDate;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: (isDark ? ThemeData.dark() : ThemeData.light()).copyWith(
            colorScheme: ColorScheme(
              brightness: isDark ? Brightness.dark : Brightness.light,
              primary: AppColors.teacherPrimary,
              onPrimary: AppColors.white,
              secondary: AppColors.teacherPrimary,
              onSecondary: AppColors.white,
              error: Colors.red,
              onError: Colors.white,
              surface: isDark ? AppColors.darkSurface : AppColors.white,
              onSurface: isDark ? AppColors.darkText : AppColors.notesDarkText,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_startDate.isAfter(_endDate)) _endDate = _startDate;
        } else {
          _endDate = picked;
          if (_endDate.isBefore(_startDate)) _startDate = _endDate;
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    final months = {
      1: 'января',
      2: 'февраля',
      3: 'марта',
      4: 'апреля',
      5: 'мая',
      6: 'июня',
      7: 'июля',
      8: 'августа',
      9: 'сентября',
      10: 'октября',
      11: 'ноября',
      12: 'декабря',
    };
    return '${date.day.toString().padLeft(2, '0')}-${months[date.month]}-${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;
    final maxModalHeight = screenHeight * 0.9;

    return Container(
      padding: const EdgeInsets.all(20),
      constraints: BoxConstraints(maxHeight: maxModalHeight),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),

          Flexible(
            child: SingleChildScrollView(
              child: _currentStep == 1 ? _buildStepOne() : _buildStepTwo(),
            ),
          ),

          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Создать отчет',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkText : AppColors.notesDarkText,
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.close,
            color: isDark ? AppColors.darkText : AppColors.teacherPrimary,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildStepOne() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Выберите тип отчета:',
          style: TextStyle(
            fontSize: 14,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.directoryTextSecondary,
          ),
        ),
        const SizedBox(height: 12),
        ReportSelectionCard(
          icon: Icons.ssid_chart,
          title: 'Успеваемость',
          description: 'Отчёт по оценкам и успеваемости учеников',
          isSelected: _selectedReportType == ReportType.performance,
          onTap: () =>
              setState(() => _selectedReportType = ReportType.performance),
        ),
        ReportSelectionCard(
          icon: Icons.groups,
          title: 'Посещаемость',
          description: 'Статистика посещений и пропусков',
          isSelected: _selectedReportType == ReportType.attendance,
          onTap: () =>
              setState(() => _selectedReportType = ReportType.attendance),
        ),
        ReportSelectionCard(
          icon: Icons.bar_chart,
          title: 'Рейтинг по баллам',
          description: 'Система баллов и достижения учеников',
          isSelected: _selectedReportType == ReportType.rating,
          onTap: () => setState(() => _selectedReportType = ReportType.rating),
        ),
      ],
    );
  }

  Widget _buildStepTwo() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String reportTitle;
    String reportDescription;
    IconData reportIcon;

    switch (_selectedReportType) {
      case ReportType.performance:
        reportTitle = 'Успеваемость';
        reportDescription = 'Отчёт по оценкам и успеваемости учеников';
        reportIcon = Icons.ssid_chart;
        break;
      case ReportType.attendance:
        reportTitle = 'Посещаемость';
        reportDescription = 'Статистика посещений и пропусков';
        reportIcon = Icons.groups;
        break;
      case ReportType.rating:
        reportTitle = 'Рейтинг по баллам';
        reportDescription = 'Система баллов и достижения учеников';
        reportIcon = Icons.bar_chart;
        break;
      default:
        reportTitle = 'Выберите тип отчета';
        reportDescription = '';
        reportIcon = Icons.help_outline;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReportSelectionCard(
          icon: reportIcon,
          title: reportTitle,
          description: reportDescription,
          isSelected: true,
          onTap: () {},
        ),
        const SizedBox(height: 16),
        Text(
          'Период:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkText : AppColors.notesDarkText,
          ),
        ),
        const SizedBox(height: 8),

        _buildPeriodOption(ReportPeriod.monthly, 'За месяц', 'Текущий месяц'),
        _buildPeriodOption(
          ReportPeriod.quarterly,
          'За четверть',
          'Текущая четверть',
        ),
        _buildPeriodOption(
          ReportPeriod.custom,
          'Произвольный период',
          'Выберите даты',
        ),
        const SizedBox(height: 20),

        if (_selectedPeriod == ReportPeriod.custom)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: _buildDateInput(true, _startDate)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildDateInput(false, _endDate)),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),

        Text(
          'Дополнительные параметры:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkText : AppColors.notesDarkText,
          ),
        ),
        const SizedBox(height: 8),

        _buildCheckboxOption(
          'Включить графики',
          'Диаграммы и визуализация данных',
          _includeGraphs,
          (value) => setState(() => _includeGraphs = value),
        ),
        _buildCheckboxOption(
          'Детальная информация',
          'Подробные данные по каждому ученику',
          _includeDetails,
          (value) => setState(() => _includeDetails = value),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildPeriodOption(
    ReportPeriod period,
    String title,
    String subtitle,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = _selectedPeriod == period;

    return GestureDetector(
      onTap: () => setState(() => _selectedPeriod = period),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.darkEventTap : AppColors.eventTap)
              : (isDark ? AppColors.darkSurface : AppColors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.teacherPrimary
                : (isDark ? AppColors.darkSurface : AppColors.eventTap),
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isDark ? AppColors.darkText : AppColors.grayFieldText,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.directoryTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateInput(bool isStart, DateTime date) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _selectDate(isStart),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isStart ? 'Начальная дата' : 'Конечная дата',
            style: TextStyle(
              fontSize: 12,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.directoryTextSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isDark ? AppColors.darkSurface : AppColors.eventTap,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 12),
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.grayFieldText,
                ),
                const SizedBox(width: 8),
                Text(
                  _formatDate(date),
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.darkText
                        : AppColors.grayFieldText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxOption(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: value
              ? (isDark ? AppColors.darkEventTap : AppColors.eventTap)
              : (isDark ? AppColors.darkSurface : AppColors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: value
                ? AppColors.teacherPrimary
                : (isDark ? AppColors.darkSurface : AppColors.eventTap),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: value
                      ? AppColors.teacherPrimary
                      : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.directoryTextSecondary),
                  width: value ? 6 : 2,
                ),
                color: isDark ? AppColors.darkCard : AppColors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark
                          ? AppColors.darkText
                          : AppColors.grayFieldText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.directoryTextSecondary,
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

  Widget _buildFooter() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isStepOneComplete = _currentStep == 1 && _selectedReportType != null;

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _currentStep == 1
                  ? () => Navigator.of(context).pop()
                  : _backStep,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                side: BorderSide(
                  color: isDark ? AppColors.darkText : AppColors.teacherPrimary,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                foregroundColor: isDark
                    ? AppColors.darkText
                    : AppColors.teacherPrimary,
              ),
              child: Text(_currentStep == 1 ? 'Отмена' : 'Назад'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _currentStep == 1
                  ? (isStepOneComplete ? _nextStep : null)
                  : _createReport,
              icon: Icon(
                _currentStep == 1 ? Icons.arrow_forward_ios : Icons.download,
                size: 18,
              ),
              label: Text(_currentStep == 1 ? 'Далее' : 'Создать отчет'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                backgroundColor: AppColors.teacherPrimary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: isDark
                    ? AppColors.darkSurface
                    : AppColors.eventTap,
                disabledForegroundColor: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.directoryTextSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
