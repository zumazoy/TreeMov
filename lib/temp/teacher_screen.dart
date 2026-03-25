import 'package:flutter/material.dart';
import 'package:treemov/core/widgets/layout/nav_bar.dart';
import 'package:treemov/features/accrual_points/presentation/screens/groups_list_screen.dart';
import 'package:treemov/features/directory/presentation/screens/directory_screen.dart';
import 'package:treemov/features/teacher_calendar/presentation/screens/calendar_screen.dart';
import 'package:treemov/features/teacher_profile/presentation/screens/profile_screen.dart';

class TeacherScreen extends StatefulWidget {
  final int initialIndex;

  const TeacherScreen({super.key, this.initialIndex = 3});

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  late int _currentIndex;
  final ValueNotifier<int> _calendarRefreshTrigger = ValueNotifier<int>(0);

  late final List<Widget> _pages = [
    CalendarScreen(refreshTrigger: _calendarRefreshTrigger),
    const GroupsListScreen(),
    const DirectoryScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    // Если нажимаем на ту же вкладку, что и текущая
    if (_currentIndex == index) {
      // Индекс 0 - календарь
      if (index == 0) {
        _calendarRefreshTrigger.value++;
      }
    } else {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}
