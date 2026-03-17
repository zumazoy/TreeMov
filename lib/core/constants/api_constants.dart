class ApiConstants {
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);

  static const String baseUrl = 'http://10.0.2.2:8001/api/v1/';
  static const String authUrl = 'http://10.0.2.2:8000/api/v1/';
  static const String emailUrl = 'http://10.0.2.2:8002/email/';

  // Auth
  static const String register = 'auth/register';
  static const String login = 'auth/login';
  static const String refresh = 'auth/refresh';
  static const String logout = 'auth/logout';

  // Email
  static const String sendEmail = 'send';
  static const String verifyEmail = 'verify';

  // Main
  static const String invites = 'invites';
  static const String acceptInvite = 'invites/accept';
  static const String orgs = 'organizations';
  static const String students = 'students';
  static const String teachers = 'teachers';
  static const String classrooms = 'classrooms';
  static const String subjects = 'subjects';
  static const String lessons = 'lessons';
  static const String periodLessons = 'lessons/period';
  static const String studentGroups = 'student-groups';
  static const String studentGroupMembers = 'student-group-members';
  static const String attendances = 'attendances';
  static const String accruals = 'accruals';
  static const String teacherNotes = 'teacher-notes';

  //
  static const String me = '/me';

  // Endpoints requiring org-id header
  static const List<String> endpointsRequiringOrgMemberId = [
    students,
    teachers,
    classrooms,
    subjects,
    lessons,
    studentGroups,
    studentGroupMembers,
    attendances,
    accruals,
    teacherNotes,
  ];

  // Endpoints not requiring org-id header
  static const List<String> excludedOrgMemberIdPaths = [
    register,
    login,
    refresh,
    logout,
    invites,
    acceptInvite,
    orgs,
  ];

  // Endpoints not requiring token
  static const List<String> excludedTokenPaths = [
    register,
    login,
    refresh,
    logout,
    sendEmail,
    verifyEmail,
  ];
}
