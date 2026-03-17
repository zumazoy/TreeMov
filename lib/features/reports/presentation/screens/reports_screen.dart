import 'package:flutter/material.dart';
// NOTE: BLoC imports are assumed for this screen to be functional
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:treemov/app/di/di.config.dart';
// import 'package:treemov/features/reports/presentation/blocs/reports/reports_bloc.dart';

import 'package:treemov/core/themes/app_colors.dart';
import 'package:treemov/features/reports/data/mocks/mock_reports_data.dart';
import 'package:treemov/features/reports/domain/entities/report_entity.dart';
import 'package:treemov/features/reports/presentation/widgets/report_creation_modal.dart';
import 'package:treemov/features/reports/presentation/widgets/report_filter_modal.dart';
import 'package:treemov/features/reports/presentation/widgets/report_item.dart';
import 'package:treemov/features/reports/presentation/widgets/reports_stats.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final List<ReportEntity> _reports = MockReportsData.mockReports;
  String _selectedFilter = 'Все отчеты';

  // Состояния для хранения активных фильтров (оставлены закомментированными)
  // ReportFilterCategory? _activeCategoryFilter;
  // ReportQuickFilter? _activeQuickFilter;
  // DateTime? _activeStartDate;
  // DateTime? _activeEndDate;

  int get _readyReportsCount =>
      _reports.where((r) => r.status == ReportStatus.ready).length;
  int get _thisWeekCount => 3;
  int get _thisMonthCount => 32;

  @override
  void dispose() {
    super.dispose();
  }

  List<ReportEntity> get _filteredReports {
    return _reports.where((report) {
      final matchesFilter =
          _selectedFilter == 'Все отчеты' ||
          (report.title.contains('Успеваемость') &&
              _selectedFilter == 'Успеваемость') ||
          (report.title.contains('Посещаемость') &&
              _selectedFilter == 'Посещаемость') ||
          (report.title.contains('Рейтинг') && _selectedFilter == 'Рейтинг');
      return matchesFilter;
    }).toList();
  }

  void _onFilterSelected(String filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  void _onDownloadReport(ReportEntity report) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Начат процесс скачивания отчета: ${report.title}'),
        backgroundColor: AppColors.teacherPrimary,
      ),
    );
  }

  void _showFilterModal() {
    ReportFilterModal.show(
      context: context,
      onApplyFilters: (category, quickFilter, startDate, endDate) {
        setState(() {
          // Логика применения фильтров (закомментирована, но готова)
          // _activeCategoryFilter = category;
          // _activeQuickFilter = quickFilter;
          // _activeStartDate = startDate;
          // _activeEndDate = endDate;
        });
      },
    );
  }

  void _showCreateReportModal() {
    ReportCreationModal.show(
      context: context,
      // ИСПРАВЛЕНИЕ: Функция должна принимать 6 обязательных аргументов
      onReportCreated:
          (
            type,
            periodType,
            startDate,
            endDate,
            includeGraphs,
            includeDetails,
          ) {
            // В BLoC архитектуре, здесь отправляется CreateReportEvent:
            // context.read<ReportsBloc>().add(
            //   CreateReportEvent(
            //     type: type,
            //     periodType: periodType,
            //     startDate: startDate,
            //     endDate: endDate,
            //     includeGraphs: includeGraphs,
            //     includeDetails: includeDetails,
            //   ),
            // );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Запрос на создание отчета отправлен!'),
                backgroundColor: Colors.green,
              ),
            );
          },
    );
  }

  Widget _buildCreateReportSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.darkSurface : AppColors.directoryBorder,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.description_outlined,
              size: 40,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.directoryTextSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              'Создать новый отчет',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkText : AppColors.grayFieldText,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Выберите отчет и период для генерации',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.directoryTextSecondary,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: 150,
              height: 40,
              child: ElevatedButton(
                onPressed: _showCreateReportModal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.teacherPrimary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Создать отчет'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filteredReports = _filteredReports;

    // В BLoC приложении этот код будет обернут в BlocConsumer

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.notesBackground,
      appBar: AppBar(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.notesBackground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            Icon(
              Icons.description_outlined,
              color: isDark ? AppColors.darkText : AppColors.notesDarkText,
              size: 28,
            ),
            const SizedBox(width: 8),
            Text(
              'Отчеты',
              style: TextStyle(
                fontFamily: 'TT Norms',
                fontWeight: FontWeight.w900,
                fontSize: 22,
                color: isDark ? AppColors.darkText : AppColors.notesDarkText,
              ),
            ),
          ],
        ),
        actions: const [SizedBox.shrink()],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryFilters(),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ReportsStats(
              totalReports: _readyReportsCount,
              thisWeekCount: _thisWeekCount,
              thisMonthCount: _thisMonthCount,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Все отчеты',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : null,
                  ),
                ),
                _buildFilterButton(),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              children: [
                ...filteredReports.map((report) {
                  return ReportItem(
                    report: report,
                    onDownload: report.status == ReportStatus.ready
                        ? () => _onDownloadReport(report)
                        : null,
                  );
                }),

                _buildCreateReportSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final List<String> categories = [
      'Все отчеты',
      'Успеваемость',
      'Посещаемость',
      'Рейтинг',
    ];

    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: categories.map((category) {
          final isSelected = _selectedFilter == category;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: FilterChip(
              label: Text(
                category,
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: isSelected
                      ? AppColors.white
                      : (isDark
                            ? AppColors.darkText
                            : AppColors.teacherPrimary),
                ),
              ),
              selected: isSelected,
              onSelected: (selected) => _onFilterSelected(category),
              selectedColor: AppColors.teacherPrimary,
              backgroundColor: isDark
                  ? AppColors.darkSurface
                  : AppColors.eventTap,
              checkmarkColor: AppColors.white,
              side: BorderSide(
                color: isSelected
                    ? AppColors.teacherPrimary
                    : (isDark ? AppColors.darkSurface : AppColors.eventTap),
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFilterButton() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextButton.icon(
      onPressed: _showFilterModal,
      icon: Icon(
        Icons.filter_list,
        size: 20,
        color: isDark ? AppColors.darkTextSecondary : AppColors.grayFieldText,
      ),
      label: Text(
        'Фильтр',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: isDark ? AppColors.darkTextSecondary : AppColors.grayFieldText,
        ),
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}
