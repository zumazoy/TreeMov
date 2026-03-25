import 'package:flutter/material.dart';
import 'package:treemov/core/widgets/layout/child_nav_bar.dart';
import 'package:treemov/features/kid_calendar/presentation/screens/calendar_kid.dart';
import 'package:treemov/features/kid_profile/presentation/screens/student_profile_screen.dart';
import 'package:treemov/features/raiting/presentation/screens/rating_screen.dart';

class StudentScreen extends StatefulWidget {
  final int initialIndex;

  const StudentScreen({super.key, this.initialIndex = 2});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  late int _currentIndex;

  final List<Widget> _pages = const [
    CalendarKidScreen(),
    RatingScreen(),
    StudentProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: ChildBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
