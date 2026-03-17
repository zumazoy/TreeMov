import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treemov/core/themes/app_colors.dart';
import 'package:treemov/core/themes/app_text_styles.dart';
import 'package:treemov/features/accrual_points/data/models/accrual_request_model.dart';
import 'package:treemov/features/accrual_points/presentation/bloc/accrual_bloc.dart';
import 'package:treemov/shared/domain/entities/student_entity.dart';

import '../../data/mocks/mock_points_data.dart';
import '../../domain/entities/point_category_entity.dart';
import 'category_buttons.dart';
import 'custom_action_form.dart';
import 'student_header.dart';

class ActionSelectionDialog extends StatefulWidget {
  final StudentEntity student;
  final AccrualBloc accrualBloc;

  const ActionSelectionDialog({
    super.key,
    required this.student,
    required this.accrualBloc,
  });

  @override
  State<ActionSelectionDialog> createState() => _ActionSelectionDialogState();
}

class _ActionSelectionDialogState extends State<ActionSelectionDialog> {
  PointCategory? _selectedCategory;
  PointAction? _selectedAction;
  List<PointAction> _currentActions = [];
  bool _showCustomAction = false;

  @override
  void initState() {
    super.initState();
    _updateActions();
  }

  void _updateActions() {
    if (_selectedCategory != null) {
      _currentActions = MockPointsData.getActionsByCategory(_selectedCategory!);
    } else {
      _currentActions = [];
    }
  }

  void _onCategorySelected(PointCategory category) {
    setState(() {
      _selectedCategory = category;
      _selectedAction = null;
      _showCustomAction = false;
      _updateActions();
    });
  }

  void _onActionSelected(PointAction action) {
    setState(() {
      _selectedAction = action;
      _showCustomAction = false;
    });
  }

  void _onCustomActionSelected() {
    setState(() {
      _showCustomAction = true;
      _selectedAction = null;
    });
  }

  void _onSaveCustomAction(String title, String description, int points) {
    final customAction = PointAction(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      category: _selectedCategory!,
      title: title,
      description: description,
      points: points,
    );

    setState(() {
      _selectedAction = customAction;
      _showCustomAction = false;
    });
  }

  void _onCancelCustomAction() {
    setState(() {
      _showCustomAction = false;
    });
  }

  void _onClose() {
    Navigator.of(context).pop();
  }

  void _createAccrual() {
    if (_selectedAction != null) {
      // Создаем AccrualRequestModel
      final request = AccrualRequestModel(
        studentId: widget.student.id ?? 0,
        amount: _selectedAction!.points,
        category: _selectedAction!.category.name,
        comment: _selectedAction!.title,
      );

      // Отправляем событие с request моделью
      widget.accrualBloc.add(CreateAccrual(request));

      // Закрываем диалог и передаем действие для показа снекбара
      Navigator.of(context).pop(_selectedAction);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AccrualBloc, AccrualState>(
      bloc: widget.accrualBloc,
      listener: (context, state) {
        if (state is AccrualError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Dialog(
        backgroundColor: isDark
            ? AppColors.darkCard
            : AppColors.notesBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StudentHeader(student: widget.student, onClose: _onClose),

              const SizedBox(height: 16),

              Text(
                'Категория:',
                style: AppTextStyles.arial16W400.copyWith(
                  color: isDark ? AppColors.darkTextSecondary : AppColors.grey,
                ),
              ),
              const SizedBox(height: 8),

              CategoryButtons(
                selectedCategory: _selectedCategory,
                onCategorySelected: _onCategorySelected,
              ),

              const SizedBox(height: 16),

              if (_selectedCategory != null && !_showCustomAction) ...[
                Text(
                  'Действие:',
                  style: AppTextStyles.arial16W400.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.grey,
                  ),
                ),
                const SizedBox(height: 8),

                _buildActionsList(),
              ],

              if (_showCustomAction) ...[
                CustomActionForm(
                  onSave: _onSaveCustomAction,
                  onCancel: _onCancelCustomAction,
                ),
              ],

              const SizedBox(height: 16),

              _buildConfirmationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionsList() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 300),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _currentActions.length + 1,
        itemBuilder: (context, index) {
          if (index < _currentActions.length) {
            final action = _currentActions[index];
            return _buildActionItem(action);
          } else {
            return _buildCustomActionItem();
          }
        },
      ),
    );
  }

  Widget _buildActionItem(PointAction action) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isPositive = action.points > 0;
    final isZero = action.points == 0;
    final isSelected = _selectedAction?.id == action.id;

    // Адаптируем цвета для темной темы
    final chipBgColor = isPositive
        ? (isDark ? AppColors.darkCategoryStudyBg : AppColors.statsTotalBg)
        : isZero
        ? (isDark ? AppColors.darkEventTap : AppColors.eventTap)
        : (isDark
              ? AppColors.darkCategoryGeneralBg
              : AppColors.eventNegativeBg);

    final chipTextColor = isPositive
        ? (isDark ? AppColors.darkCategoryStudyText : AppColors.statsTotalText)
        : isZero
        ? (isDark ? AppColors.darkText : AppColors.teacherPrimary)
        : (isDark ? AppColors.darkCategoryGeneralText : AppColors.activityRed);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: isSelected
          ? (isDark ? AppColors.darkEventTap : AppColors.eventTap)
          : (isDark ? AppColors.darkSurface : AppColors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isSelected
              ? AppColors.teacherPrimary
              : (isDark ? AppColors.darkSurface : AppColors.directoryBorder),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        title: Text(
          action.title,
          style: AppTextStyles.arial14W700.themed(context),
        ),
        subtitle: Text(
          action.description,
          style: AppTextStyles.arial12W400.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.grayFieldText,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: chipBgColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '${isPositive ? '+' : ''}${action.points}',
            style: AppTextStyles.arial14W700.copyWith(color: chipTextColor),
          ),
        ),
        onTap: () => _onActionSelected(action),
      ),
    );
  }

  Widget _buildCustomActionItem() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: isDark ? AppColors.darkSurface : AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isDark ? AppColors.darkSurface : AppColors.directoryBorder,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkEventTap : AppColors.eventTap,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.add,
            color: isDark ? AppColors.darkText : AppColors.teacherPrimary,
          ),
        ),
        title: Text(
          'Создать действие',
          style: AppTextStyles.arial14W700.themed(context),
        ),
        subtitle: Text(
          'Настроить свое действие',
          style: AppTextStyles.arial12W400.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.grayFieldText,
          ),
        ),
        onTap: _onCustomActionSelected,
      ),
    );
  }

  Widget _buildConfirmationButtons() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final buttonText = _selectedAction == null
        ? 'Выберите действие'
        : 'Подтвердить ${_selectedAction!.points > 0 ? '+' : ''}${_selectedAction!.points}';

    // Определяем цвет кнопки в зависимости от количества баллов
    Color buttonColor;
    if (_selectedAction != null) {
      if (_selectedAction!.points > 0) {
        buttonColor = isDark ? AppColors.darkCategoryStudyBg : Colors.green;
      } else if (_selectedAction!.points < 0) {
        buttonColor = isDark
            ? AppColors.darkCategoryGeneralBg
            : AppColors.activityRed;
      } else {
        buttonColor = AppColors.teacherPrimary;
      }
    } else {
      buttonColor = AppColors.teacherPrimary;
    }

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _onClose,
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark
                  ? AppColors.darkText
                  : AppColors.notesDarkText,
              side: BorderSide(
                color: isDark
                    ? AppColors.darkSurface
                    : AppColors.directoryBorder,
              ),
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text(
              'Отмена',
              style: AppTextStyles.arial14W400.themed(context),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: ElevatedButton(
            onPressed: _selectedAction != null ? _createAccrual : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: Colors.white,
              disabledBackgroundColor: isDark
                  ? AppColors.darkSurface
                  : Colors.grey.shade300,
              disabledForegroundColor: isDark
                  ? AppColors.darkTextSecondary
                  : Colors.grey.shade600,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text(buttonText, style: AppTextStyles.arial14W700.white),
          ),
        ),
      ],
    );
  }
}
