import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treemov/app/di/di.config.dart';
import 'package:treemov/core/themes/app_colors.dart';
import 'package:treemov/features/kid_calendar/data/repositories/kid_calendar_repository_impl.dart';
import 'package:treemov/features/kid_calendar/presentation/bloc/kid_calendar_bloc.dart';
import 'package:treemov/features/kid_calendar/presentation/widgets/calendar_app_bar.dart';
import 'package:treemov/features/kid_calendar/presentation/widgets/calendar_background.dart';
import 'package:treemov/features/kid_calendar/presentation/widgets/calendar_content.dart';
import 'package:treemov/features/kid_calendar/presentation/widgets/lessons_panel.dart';
import 'package:treemov/shared/domain/entities/lesson_entity.dart';
import 'package:treemov/shared/domain/repositories/shared_repository.dart';

class CalendarKidScreen extends StatelessWidget {
  const CalendarKidScreen({super.key});

  String _getFirstDayOfMonth(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      1,
    ).toIso8601String().split('T').first;
  }

  String _getLastDayOfMonth(DateTime date) {
    return DateTime(
      date.year,
      date.month + 1,
      0,
    ).toIso8601String().split('T').first;
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateMin = _getFirstDayOfMonth(DateTime(now.year, now.month - 2));
    final dateMax = _getLastDayOfMonth(DateTime(now.year, now.month + 2));

    return BlocProvider(
      create: (context) {
        final sharedRepository = getIt<SharedRepository>();
        final repository = KidCalendarRepositoryImpl(sharedRepository);
        return KidCalendarBloc(repository: repository)
          ..add(LoadKidLessonsEvent(dateMin, dateMax));
      },
      child: const _CalendarKidScreenContent(),
    );
  }
}

class _CalendarKidScreenContent extends StatefulWidget {
  const _CalendarKidScreenContent();

  @override
  State<_CalendarKidScreenContent> createState() =>
      _CalendarKidScreenContentState();
}

class _CalendarKidScreenContentState extends State<_CalendarKidScreenContent>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController? _lessonsSheetController;

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  int? _currentPanelDay;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
        .animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  String _getFirstDayOfMonth(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      1,
    ).toIso8601String().split('T').first;
  }

  String _getLastDayOfMonth(DateTime date) {
    return DateTime(
      date.year,
      date.month + 1,
      0,
    ).toIso8601String().split('T').first;
  }

  Future<void> _closeLessonsPanel() async {
    if (_lessonsSheetController != null) {
      await _slideController.reverse();
      _lessonsSheetController!.close();
      _lessonsSheetController = null;
      _currentPanelDay = null;
    }
  }

  Future<void> _showLessonsPanel(
    BuildContext context,
    int day,
    List<LessonEntity> lessons,
  ) async {
    if (lessons.isEmpty) {
      await _closeLessonsPanel();
      return;
    }

    if (_lessonsSheetController != null && _currentPanelDay != day) {
      await _closeLessonsPanel();
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (_lessonsSheetController != null && _currentPanelDay == day) {
      await _closeLessonsPanel();
      return;
    }

    _slideController.reset();

    _lessonsSheetController = _scaffoldKey.currentState?.showBottomSheet(
      (context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _slideController.forward();
        });

        return SlideTransition(
          position: _slideAnimation,
          child: LessonsPanel(
            lessons: lessons,
            onClose: () async {
              await _closeLessonsPanel();
              if (mounted) {
                context.read<KidCalendarBloc>().add(const ClosePanelEvent());
              }
            },
          ),
        );
      },
      backgroundColor: Colors.transparent,
      elevation: 8,
    );

    _currentPanelDay = day;

    _lessonsSheetController?.closed.whenComplete(() {
      _slideController.reset();
      if (mounted) {
        _lessonsSheetController = null;
        _currentPanelDay = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<KidCalendarBloc, KidCalendarState>(
      listener: (context, state) {
        if (state is KidCalendarLoaded && state.selectedDay != -1) {
          final lessons = state.lessonsByDay[state.selectedDay] ?? [];
          _showLessonsPanel(context, state.selectedDay, lessons);
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.kidPrimary,
        appBar: const CalendarAppBar(),
        body: Stack(
          children: [
            const CalendarBackground(),
            BlocBuilder<KidCalendarBloc, KidCalendarState>(
              builder: (context, state) {
                if (state is KidCalendarLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.kidButton,
                    ),
                  );
                } else if (state is KidCalendarLoaded) {
                  return CalendarContent(
                    currentDate: state.currentDate,
                    selectedDay: state.selectedDay,
                    daysWithLessons: state.daysWithLessons,
                    onMonthChanged: (offset) {
                      context.read<KidCalendarBloc>().add(
                        ChangeMonthEvent(offset: offset),
                      );
                    },
                    onDaySelected: (day) {
                      final selectedDate = DateTime(
                        state.currentDate.year,
                        state.currentDate.month,
                        day,
                      );
                      context.read<KidCalendarBloc>().add(
                        SelectDayEvent(day: day, selectedDate: selectedDate),
                      );
                    },
                  );
                } else if (state is KidCalendarError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Ошибка загрузки',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          style: TextStyle(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            final now = DateTime.now();
                            final dateMin = _getFirstDayOfMonth(
                              DateTime(now.year, now.month - 2),
                            );
                            final dateMax = _getLastDayOfMonth(
                              DateTime(now.year, now.month + 2),
                            );

                            context.read<KidCalendarBloc>().add(
                              LoadKidLessonsEvent(dateMin, dateMax),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.kidButton,
                          ),
                          child: const Text('Повторить'),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
