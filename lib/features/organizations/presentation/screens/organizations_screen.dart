import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treemov/app/di/di.dart';
import 'package:treemov/app/routes/app_routes.dart';
import 'package:treemov/core/storage/secure_storage_repository.dart';
import 'package:treemov/core/themes/app_colors.dart';
import 'package:treemov/core/widgets/auth/logout_dialog.dart';
import 'package:treemov/features/directory/presentation/widgets/app_bar_title.dart';
import 'package:treemov/features/directory/presentation/widgets/search_field.dart';
import 'package:treemov/features/organizations/data/models/invite_response_model.dart';
import 'package:treemov/features/organizations/presentation/bloc/orgs_bloc.dart';
import 'package:treemov/features/organizations/presentation/widgets/dialogs/accept_invite_dialog.dart';
import 'package:treemov/features/organizations/presentation/widgets/empty_states.dart';
import 'package:treemov/features/organizations/presentation/widgets/invite_item.dart';
import 'package:treemov/features/organizations/presentation/widgets/organization_item.dart';
import 'package:treemov/features/organizations/presentation/widgets/section_header.dart';
import 'package:treemov/shared/data/models/org_member_response_model.dart';

class OrganizationsScreen extends StatelessWidget {
  const OrganizationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OrgsBloc>()..add(LoadOrgsEvent()),
      child: const _OrganizationsScreenContent(),
    );
  }
}

class _OrganizationsScreenContent extends StatefulWidget {
  const _OrganizationsScreenContent();

  @override
  State<_OrganizationsScreenContent> createState() =>
      _OrganizationsScreenState();
}

class _OrganizationsScreenState extends State<_OrganizationsScreenContent> {
  final TextEditingController _searchController = TextEditingController();
  late final SecureStorageRepository _secureStorage;

  List<OrgMemberResponseModel> _teacherOrganizations = [];
  List<OrgMemberResponseModel> _studentOrganizations = [];
  List<InviteResponseModel> _pendingInvites = [];

  List<OrgMemberResponseModel> _filteredTeacher = [];
  List<OrgMemberResponseModel> _filteredStudent = [];
  List<InviteResponseModel> _filteredInvites = [];

  bool _hasSearchQuery = false;

  @override
  void initState() {
    super.initState();
    _secureStorage = getIt<SecureStorageRepository>();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Проверяем, пришел ли пользователь с экрана авторизации
  bool _isRootScreen() {
    // Получаем историю навигации
    final navigator = Navigator.of(context);

    // Если нельзя вернуться назад - значит это корневой экран
    return !navigator.canPop();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _hasSearchQuery = query.isNotEmpty;

      if (query.isEmpty) {
        _filteredTeacher = List.from(_teacherOrganizations);
        _filteredStudent = List.from(_studentOrganizations);
        _filteredInvites = List.from(_pendingInvites);
      } else {
        _filteredTeacher = _teacherOrganizations.where((org) {
          return org.org?.title?.toLowerCase().contains(query.toLowerCase()) ??
              false;
        }).toList();

        _filteredStudent = _studentOrganizations.where((org) {
          return org.org?.title?.toLowerCase().contains(query.toLowerCase()) ??
              false;
        }).toList();

        _filteredInvites = _pendingInvites.where((invite) {
          return (invite.org?.title?.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ??
                  false) ||
              (invite.role?.title?.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ??
                  false);
        }).toList();
      }
    });
  }

  void _splitOrganizationsByRole(List<OrgMemberResponseModel> organizations) {
    _teacherOrganizations = organizations.where((org) {
      return org.role?.code == 'crm_admin' || org.role?.code == 'teacher';
    }).toList();

    _studentOrganizations = organizations.where((org) {
      return org.role?.code == 'student';
    }).toList();

    _filteredTeacher = List.from(_teacherOrganizations);
    _filteredStudent = List.from(_studentOrganizations);
  }

  Future<void> _onTeacherOrganizationTap(
    OrgMemberResponseModel organization,
  ) async {
    if (organization.id != null) {
      await _secureStorage.saveOrgMemberId(organization.id!.toString());
    }
    await _secureStorage.saveRole('teacher');

    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.mainApp,
        (route) => false,
      );
    }
  }

  Future<void> _onStudentOrganizationTap(
    OrgMemberResponseModel organization,
  ) async {
    if (organization.id != null) {
      await _secureStorage.saveOrgMemberId(organization.id!.toString());
    }
    await _secureStorage.saveRole('student');

    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.studentApp,
        (route) => false,
      );
    }
  }

  void _acceptInvite(InviteResponseModel invite) {
    final orgsBloc = context.read<OrgsBloc>();

    showDialog(
      context: context,
      builder: (context) => AcceptInviteDialog(
        organizationName: invite.org?.title ?? 'Организация',
        onConfirm: () {
          orgsBloc.add(AcceptInviteEvent(invite.uuid ?? ''));
        },
      ),
    );
  }

  void _declineInvite(InviteResponseModel invite) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Отклонить приглашение',
          style: TextStyle(color: isDark ? AppColors.darkText : Colors.black),
        ),
        content: Text(
          'Вы уверены, что хотите отклонить приглашение?',
          style: TextStyle(color: isDark ? AppColors.darkTextSecondary : null),
        ),
        backgroundColor: isDark ? AppColors.darkCard : null,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Отмена',
              style: TextStyle(
                color: isDark ? AppColors.darkTextSecondary : null,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: отклонение приглашения

              setState(() {
                _pendingInvites.removeWhere((i) => i.uuid == invite.uuid);
                _filteredInvites.removeWhere((i) => i.uuid == invite.uuid);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Приглашение отклонено'),
                  backgroundColor: isDark
                      ? AppColors.darkCategoryGeneralBg
                      : Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isDark
                  ? AppColors.darkCategoryGeneralBg
                  : Colors.red,
              foregroundColor: isDark
                  ? AppColors.darkCategoryGeneralText
                  : AppColors.white,
            ),
            child: const Text('Отклонить'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleLogout() async {
    await LogoutDialog.show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: AppBarTitle(text: 'Мои организации'),
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: isDark ? AppColors.darkText : AppColors.grayFieldText,
        elevation: 0,
        actions: [
          // Кнопка обновления
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: isDark ? AppColors.darkText : null,
            ),
            onPressed: () => context.read<OrgsBloc>().add(LoadOrgsEvent()),
          ),
          // Кнопка выхода
          if (_isRootScreen())
            IconButton(
              icon: Icon(
                Icons.logout,
                color: isDark ? AppColors.darkText : AppColors.activityRed,
              ),
              onPressed: _handleLogout,
              tooltip: 'Выйти из аккаунта',
            ),
        ],
      ),
      body: Column(
        children: [
          SearchField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            hintText: 'Поиск организаций...',
          ),
          Expanded(
            child: BlocConsumer<OrgsBloc, OrgsState>(
              listener: (context, state) {
                if (state is OrgsLoaded) {
                  setState(() {
                    _splitOrganizationsByRole(state.organizations);
                    _pendingInvites = state.invites.toList();
                    _filteredInvites = List.from(state.invites);
                  });
                } else if (state is InviteAccepted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Вы успешно присоединились к организации',
                      ),
                      backgroundColor: isDark
                          ? AppColors.darkCategoryStudyBg
                          : Colors.green,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is OrgsLoading || state is AcceptInviteLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.primary,
                    ),
                  );
                } else if (state is OrgsError || state is AcceptInviteError) {
                  return _buildErrorWidget(isDark);
                } else {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<OrgsBloc>().add(LoadOrgsEvent());
                    },
                    color: theme.colorScheme.primary,
                    child: _buildContent(isDark),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(bool isDark) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Ошибка загрузки данных',
            style: TextStyle(color: isDark ? AppColors.darkText : null),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<OrgsBloc>().add(LoadOrgsEvent()),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Повторить'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(bool isDark) {
    bool hasAnyContent =
        _filteredTeacher.isNotEmpty ||
        _filteredStudent.isNotEmpty ||
        _filteredInvites.isNotEmpty;

    if (_hasSearchQuery && !hasAnyContent) {
      return const EmptySearchView();
    }

    if (!hasAnyContent) EmptyOrganizationsView();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        if (_filteredInvites.isNotEmpty) ...[
          SectionHeader(title: 'Приглашения', icon: Icons.mail_outline),
          ..._filteredInvites.map(
            (invite) => InviteItem(
              organizationName: invite.org?.title ?? 'Организация',
              role: invite.role?.title ?? 'Приглашение',
              email: invite.email ?? '',
              createdAt: invite.createdAt ?? '',
              onAccept: () => _acceptInvite(invite),
              onDecline: () => _declineInvite(invite),
            ),
          ),
          const SizedBox(height: 16),
        ],

        if (_filteredTeacher.isNotEmpty) ...[
          SectionHeader(title: 'Преподавание', icon: Icons.school),
          ..._filteredTeacher.map(
            (org) => OrganizationItem(
              organizationName: org.org?.title ?? 'Без названия',
              userRole: org.role?.title ?? 'Учитель',
              avatarColor: AppColors.plusButton,
              onTap: () => _onTeacherOrganizationTap(org),
            ),
          ),
          const SizedBox(height: 16),
        ],

        if (_filteredStudent.isNotEmpty) ...[
          SectionHeader(title: 'Обучение', icon: Icons.people_outline),
          ..._filteredStudent.map(
            (org) => OrganizationItem(
              organizationName: org.org?.title ?? 'Без названия',
              userRole: org.role?.title ?? 'Ученик',
              avatarColor: AppColors.calendarButton,
              onTap: () => _onStudentOrganizationTap(org),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}
