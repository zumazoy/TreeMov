import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treemov/app/di/di.config.dart';
import 'package:treemov/features/teacher_calendar/domain/repositories/schedule_repository.dart';
import 'package:treemov/features/teacher_calendar/presentation/bloc/schedules_bloc.dart';
import 'package:treemov/features/teacher_calendar/presentation/bloc/schedules_event.dart';
import 'package:treemov/features/teacher_calendar/presentation/bloc/schedules_state.dart';
import 'package:treemov/shared/domain/entities/lesson_entity.dart';
import 'package:treemov/shared/domain/repositories/shared_repository.dart';

import '../utils/calendar_utils.dart';
import '../widgets/calendar/add_event_button.dart';
import '../widgets/calendar/calendar_app_bar.dart';
import '../widgets/calendar/calendar_grid.dart';
import '../widgets/calendar/calendar_header.dart';
import '../widgets/calendar/calendar_week_days.dart';
import '../widgets/events_panel.dart';
import 'create_lesson_screen.dart';

class CalendarScreen extends StatefulWidget {
  final ValueNotifier<int>? refreshTrigger;

  const CalendarScreen({super.key, this.refreshTrigger});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _currentDate = DateTime.now();
  DateTime? _selectedDate;
  Map<String, List<LessonEntity>> _events = {};
  late SchedulesBloc _schedulesBloc;

  @override
  void initState() {
    super.initState();
    _schedulesBloc = getIt<SchedulesBloc>();
    _loadLessons();
    widget.refreshTrigger?.addListener(_onRefreshTriggered);
  }

  @override
  void dispose() {
    widget.refreshTrigger?.removeListener(_onRefreshTriggered);
    super.dispose();
  }

  void _onRefreshTriggered() {
    _goToCurrentMonth();
    _loadLessons();
  }

  void _goToCurrentMonth() {
    final now = DateTime.now();

    if (_currentDate.year != now.year || _currentDate.month != now.month) {
      setState(() {
        _currentDate = DateTime(now.year, now.month, 1);
        _selectedDate = null;
      });
    }
  }

  void _loadLessons() {
    final dateMin = DateTime(_currentDate.year, _currentDate.month - 2, 1);
    final dateMax = DateTime(_currentDate.year, _currentDate.month + 3, 0);
    _schedulesBloc.add(LoadLessonsEvent(dateMin, dateMax));
  }

  void _changeMonth(int offset) {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + offset);
    });
    _loadLessons();
  }

  void _showEventsPanel(DateTime date) {
    EventsPanel.show(
      context: context,
      selectedDate: date,
      events: _events[CalendarUtils.formatDateKey(date)] ?? [],
      schedulesBloc: _schedulesBloc,
    );
  }

  void _navigateToCreateLessons() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CreateLessonScreen(
          sharedRepository: getIt<SharedRepository>(),
          scheduleRepository: getIt<ScheduleRepository>(),
          schedulesBloc: _schedulesBloc,
        ),
      ),
    ).then((_) {
      _loadLessons();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider<SchedulesBloc>.value(
      value: _schedulesBloc,
      child: BlocListener<SchedulesBloc, ScheduleState>(
        listener: (context, state) {
          if (state is LessonsLoaded) {
            setState(() {
              _events = CalendarUtils.groupLessonsByDate(state.lessons);
            });
          }
        },
        child: Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: const CalendarAppBar(),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CalendarHeader(
                          currentDate: _currentDate,
                          onPrevMonth: () => _changeMonth(-1),
                          onNextMonth: () => _changeMonth(1),
                        ),
                        const SizedBox(height: 20),
                        const CalendarWeekDays(),
                        const SizedBox(height: 10),
                        CalendarGrid(
                          currentDate: _currentDate,
                          selectedDate: _selectedDate,
                          eventDates: _events.keys.toSet(),
                          onDateSelected: (date) {
                            setState(() => _selectedDate = date);
                            _showEventsPanel(date);
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: AddEventButton(
            onPressed: _navigateToCreateLessons,
          ),
        ),
      ),
    );
  }
}
