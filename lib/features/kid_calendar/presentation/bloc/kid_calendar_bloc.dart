import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:treemov/features/kid_calendar/domain/repositories/kid_calendar_repository.dart';
import 'package:treemov/shared/domain/entities/lesson_entity.dart';

part 'kid_calendar_event.dart';
part 'kid_calendar_state.dart';

class KidCalendarBloc extends Bloc<KidCalendarEvent, KidCalendarState> {
  final KidCalendarRepository _repository;

  List<LessonEntity> _cachedLessons = [];
  DateTime? _cachedDateMin;
  DateTime? _cachedDateMax;
  DateTime? _cachedTimestamp;

  bool _isLoading = false;

  DateTime _currentDisplayDate = DateTime.now();
  static const Duration _cacheDuration = Duration(seconds: 30);

  KidCalendarBloc({required KidCalendarRepository repository})
    : _repository = repository,
      super(KidCalendarInitial()) {
    on<LoadKidLessonsEvent>(_onLoadLessons);
    on<ChangeMonthEvent>(_onChangeMonth);
    on<SelectDayEvent>(_onSelectDay);
    on<ClosePanelEvent>(_onClosePanel);
  }
  bool _isCacheValid() {
    if (_cachedTimestamp == null) return false;
    return DateTime.now().difference(_cachedTimestamp!) < _cacheDuration;
  }

  Future<void> _onLoadLessons(
    LoadKidLessonsEvent event,
    Emitter<KidCalendarState> emit,
  ) async {
    final requestedMin = DateTime.parse(event.dateMin);
    final requestedMax = DateTime.parse(event.dateMax);

    if (_isLoading ||
        (_isCacheValid() && _isRangeCached(requestedMin, requestedMax))) {
      if (_isCacheValid() && _isRangeCached(requestedMin, requestedMax)) {
        _emitLoadedState(emit, _currentDisplayDate);
      }
      return;
    }

    _isLoading = true;

    try {
      final expandedMin = DateTime(
        requestedMin.year,
        requestedMin.month - 2,
        1,
      );
      final expandedMax = DateTime(
        requestedMax.year,
        requestedMax.month + 2,
        0,
      );

      final lessons = await _repository.getLessons(
        _formatDate(expandedMin),
        _formatDate(expandedMax),
      );

      _cachedLessons = lessons;
      _cachedDateMin = expandedMin;
      _cachedDateMax = expandedMax;
      _cachedTimestamp = DateTime.now();

      _emitLoadedState(emit, _currentDisplayDate);
    } catch (e) {
      if (state is! KidCalendarLoaded) {
        emit(KidCalendarError('Ошибка загрузки расписания: $e'));
      }
    } finally {
      _isLoading = false;
    }
  }

  void _onChangeMonth(ChangeMonthEvent event, Emitter<KidCalendarState> emit) {
    if (state is KidCalendarLoaded) {
      final current = state as KidCalendarLoaded;
      final newDate = DateTime(
        current.currentDate.year,
        current.currentDate.month + event.offset,
        1,
      );

      _currentDisplayDate = newDate;

      final dateMin = _formatDate(newDate);
      final dateMax = _formatDate(DateTime(newDate.year, newDate.month + 1, 0));

      emit(current.copyWith(currentDate: newDate));

      add(LoadKidLessonsEvent(dateMin, dateMax));
    }
  }

  void _onSelectDay(SelectDayEvent event, Emitter<KidCalendarState> emit) {
    if (state is KidCalendarLoaded) {
      final current = state as KidCalendarLoaded;
      emit(
        current.copyWith(
          selectedDate: event.selectedDate,
          selectedDay: event.day,
        ),
      );
    }
  }

  void _onClosePanel(ClosePanelEvent event, Emitter<KidCalendarState> emit) {
    if (state is KidCalendarLoaded) {
      final current = state as KidCalendarLoaded;
      emit(current.copyWith(selectedDate: null, selectedDay: -1));
    }
  }

  bool _isRangeCached(DateTime min, DateTime max) {
    if (_cachedDateMin == null || _cachedDateMax == null) return false;

    return min.isAfter(_cachedDateMin!) && max.isBefore(_cachedDateMax!);
  }

  void _emitLoadedState(Emitter<KidCalendarState> emit, DateTime currentDate) {
    final monthLessons = _cachedLessons.where((lesson) {
      if (lesson.date == null) return false;
      try {
        final date = DateTime.parse(lesson.date!);
        return date.year == currentDate.year && date.month == currentDate.month;
      } catch (e) {
        return false;
      }
    }).toList();

    final processed = _processLessons(monthLessons, currentDate);

    emit(
      KidCalendarLoaded(
        currentDate: currentDate,
        selectedDate: null,
        selectedDay: -1,
        daysWithLessons: processed.days,
        lessonsByDay: processed.lessonsByDay,
        allLessons: monthLessons,
      ),
    );
  }

  String _formatDate(DateTime date) {
    return date.toIso8601String().split('T').first;
  }

  _ProcessedLessons _processLessons(
    List<LessonEntity> lessons,
    DateTime currentDate,
  ) {
    final Set<int> days = {};
    final Map<int, List<LessonEntity>> lessonsByDay = {};

    for (final lesson in lessons) {
      if (lesson.date != null) {
        try {
          final date = DateTime.parse(lesson.date!);
          days.add(date.day);
          if (!lessonsByDay.containsKey(date.day)) {
            lessonsByDay[date.day] = [];
          }
          lessonsByDay[date.day]!.add(lesson);
        } catch (e) {
          continue;
        }
      }
    }

    return _ProcessedLessons(days: days, lessonsByDay: lessonsByDay);
  }
}

class _ProcessedLessons {
  final Set<int> days;
  final Map<int, List<LessonEntity>> lessonsByDay;

  _ProcessedLessons({required this.days, required this.lessonsByDay});
}
