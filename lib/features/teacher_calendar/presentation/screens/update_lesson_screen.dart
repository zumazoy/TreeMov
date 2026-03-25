import 'package:flutter/material.dart';
import 'package:treemov/core/themes/app_colors.dart';
import 'package:treemov/core/themes/app_text_styles.dart';
import 'package:treemov/core/widgets/layout/nav_bar.dart';
import 'package:treemov/shared/domain/entities/lesson_entity.dart';
import 'package:treemov/temp/teacher_screen.dart';

class UpdateLessonScreen extends StatefulWidget {
  final LessonEntity event;

  const UpdateLessonScreen({super.key, required this.event});

  @override
  State<UpdateLessonScreen> createState() => _UpdateLessonScreenState();
}

class _UpdateLessonScreenState extends State<UpdateLessonScreen> {
  String? _selectedGroup;
  String? _selectedLessonType;
  String? _selectedLocation;
  String? _selectedRepeat;
  String? _selectedReminder;
  final TextEditingController _descriptionController = TextEditingController();

  // демонстрационные данные
  final List<String> _groupOptions = ['Группа 1', 'Группа 2', 'Группа 3'];
  final List<String> _lessonTypeOptions = [
    'Растяжка',
    'Йога',
    'Фитнес',
    'Силовая тренировка',
  ];
  final List<String> _locationOptions = [
    'Тренажерный зал',
    'Большой зал',
    'Малый зал',
  ];
  final List<String> _repeatOptions = [
    'Не повторять',
    'Ежедневно',
    'Еженедельно',
    'Ежемесячно',
    'Через 2 дня',
    'Через 3 дня',
  ];
  final List<String> _reminderOptions = [
    'Не напоминать',
    'За 5 минут',
    'За 15 минут',
    'За 30 минут',
    'За 1 час',
  ];

  DateTime _startDateTime = DateTime.now();
  DateTime _endDateTime = DateTime.now().add(const Duration(hours: 1));

  @override
  void initState() {
    super.initState();
    // Инициализация данными из переданного события
    // _selectedGroup = widget.initialGroup;
    // _selectedLessonType = widget.initialLessonType;
    // _selectedLocation = widget.initialLocation;
    // _startDateTime = widget.initialStartDateTime;
    // _endDateTime = widget.initialEndDateTime;
    // _selectedRepeat = widget.initialRepeat;
    // _selectedReminder = widget.initialReminder;
    // _descriptionController.text = widget.initialDescription;
  }

  String _formatDateTime(DateTime dateTime) {
    return '${_formatDate(dateTime)} ${_formatTime(dateTime)}';
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}';
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _selectStartDateTime() async {
    final theme = Theme.of(context);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: theme.colorScheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_startDateTime),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: theme.colorScheme.primary,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null && mounted) {
        setState(() {
          _startDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          if (_endDateTime.isBefore(_startDateTime)) {
            _endDateTime = _startDateTime.add(const Duration(hours: 1));
          }
        });
      }
    }
  }

  Future<void> _selectEndDateTime() async {
    final theme = Theme.of(context);

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _endDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: theme.colorScheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_endDateTime),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: theme.colorScheme.primary,
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null && mounted) {
        setState(() {
          _endDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _updateEvent() {
    //
    // context.read<EventBloc>().add(UpdateEvent(
    //   eventId: widget.eventId,
    //   group: _selectedGroup!,
    //   lessonType: _selectedLessonType!,
    //   location: _selectedLocation!,
    //   startDateTime: _startDateTime,
    //   endDateTime: _endDateTime,
    //   repeat: _selectedRepeat,
    //   reminder: _selectedReminder,
    //   description: _descriptionController.text,
    // ));

    // Временно возвращаем назад
    Navigator.pop(context);
  }

  Widget _buildDropdownCard({
    required String title,
    required String? value,
    required List<String> options,
    required Function(String?) onSelected,
    required String iconPath,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.grayFieldText;
    final borderColor = isDark ? AppColors.darkSurface : AppColors.eventTap;
    final backgroundColor = isDark ? AppColors.darkCard : Colors.white;

    return Container(
      width: 352,
      height: 52,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(12.5),
      ),
      child: DropdownMenu<String>(
        initialSelection: value,
        onSelected: onSelected,
        dropdownMenuEntries: options
            .map(
              (option) =>
                  DropdownMenuEntry<String>(value: option, label: option),
            )
            .toList(),
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
        textStyle: AppTextStyles.arial14W400.copyWith(color: textColor),
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(backgroundColor),
          elevation: WidgetStateProperty.all(2),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.5)),
          ),
        ),
        width: 352,
        hintText: title,
        leadingIcon: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Image.asset(iconPath, width: 20, height: 20, color: textColor),
        ),
        trailingIcon: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Icon(Icons.expand_more, size: 20, color: textColor),
        ),
      ),
    );
  }

  Widget _buildDateTimeSection() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.grayFieldText;
    final borderColor = isDark ? AppColors.darkSurface : AppColors.eventTap;
    final dividerColor = theme.dividerColor;

    return Container(
      width: 352,
      height: 90,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(12.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _selectStartDateTime,
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/clock_icon.png',
                      width: 20,
                      height: 20,
                      color: textColor,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Начало:',
                      style: AppTextStyles.arial14W400.copyWith(
                        color: textColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDateTime(_startDateTime),
                      style: AppTextStyles.arial14W400.copyWith(
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(height: 1, color: dividerColor),

            Expanded(
              child: GestureDetector(
                onTap: _selectEndDateTime,
                child: Row(
                  children: [
                    const SizedBox(width: 32), // Для выравнивания с иконкой
                    Text(
                      'Конец:',
                      style: AppTextStyles.arial14W400.copyWith(
                        color: textColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatDateTime(_endDateTime),
                      style: AppTextStyles.arial14W400.copyWith(
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? AppColors.darkText : AppColors.grayFieldText;
    final borderColor = isDark ? AppColors.darkSurface : AppColors.eventTap;

    return Container(
      width: 352,
      height: 52,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(12.5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Image.asset(
              'assets/images/desc_icon.png',
              width: 20,
              height: 20,
              color: textColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Описание',
                  hintStyle: AppTextStyles.arial14W400.copyWith(
                    color: textColor.withAlpha(128),
                  ),
                  border: InputBorder.none,
                ),
                style: AppTextStyles.arial14W400.copyWith(color: textColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onTabTapped(int index) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => TeacherScreen(initialIndex: index),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        automaticallyImplyLeading: false,
        title: Text('Изменить событие', style: AppTextStyles.arial20W900.white),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: _updateEvent,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 26),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 352,
                  child: Column(
                    children: [
                      _buildDropdownCard(
                        title: 'Группа/ученик',
                        value: _selectedGroup,
                        options: _groupOptions,
                        onSelected: (value) {
                          setState(() {
                            _selectedGroup = value;
                          });
                        },
                        iconPath: 'assets/images/group_icon.png',
                      ),
                      const SizedBox(height: 8),

                      _buildDropdownCard(
                        title: 'Вид занятия',
                        value: _selectedLessonType,
                        options: _lessonTypeOptions,
                        onSelected: (value) {
                          setState(() {
                            _selectedLessonType = value;
                          });
                        },
                        iconPath: 'assets/images/activity_icon.png',
                      ),
                      const SizedBox(height: 8),

                      _buildDropdownCard(
                        title: 'Локация',
                        value: _selectedLocation,
                        options: _locationOptions,
                        onSelected: (value) {
                          setState(() {
                            _selectedLocation = value;
                          });
                        },
                        iconPath: 'assets/images/place_icon.png',
                      ),
                      const SizedBox(height: 8),

                      _buildDateTimeSection(),
                      const SizedBox(height: 8),

                      _buildDropdownCard(
                        title: 'Повтор',
                        value: _selectedRepeat,
                        options: _repeatOptions,
                        onSelected: (value) {
                          setState(() {
                            _selectedRepeat = value;
                          });
                        },
                        iconPath: 'assets/images/repeat_icon.png',
                      ),
                      const SizedBox(height: 8),

                      _buildDropdownCard(
                        title: 'Добавить напоминание',
                        value: _selectedReminder,
                        options: _reminderOptions,
                        onSelected: (value) {
                          setState(() {
                            _selectedReminder = value;
                          });
                        },
                        iconPath: 'assets/images/bell_icon.png',
                      ),
                      const SizedBox(height: 8),

                      _buildDescriptionField(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: _onTabTapped,
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}
