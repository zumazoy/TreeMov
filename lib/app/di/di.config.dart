import 'package:get_it/get_it.dart';
import 'package:treemov/core/navigation/navigation_service.dart';
import 'package:treemov/core/network/dio_client.dart';
import 'package:treemov/core/storage/secure_storage_factory.dart';
import 'package:treemov/core/storage/secure_storage_repository.dart';
import 'package:treemov/core/themes/theme_cubit.dart';
import 'package:treemov/features/accrual_points/data/datasources/accrual_remote_data_source.dart';
import 'package:treemov/features/accrual_points/data/repositories/accrual_repository_impl.dart';
import 'package:treemov/features/accrual_points/domain/repositories/accrual_repository.dart';
import 'package:treemov/features/accrual_points/presentation/bloc/accrual_bloc.dart';
import 'package:treemov/features/authorization/data/datasources/auth_remote_data_source.dart';
import 'package:treemov/features/authorization/data/repositories/auth_repository_impl.dart';
import 'package:treemov/features/authorization/domain/repositories/auth_repository.dart';
import 'package:treemov/features/authorization/presentation/bloc/login_bloc.dart';
import 'package:treemov/features/directory/presentation/bloc/directory_bloc.dart';
import 'package:treemov/features/kid_profile/data/datasources/student_profile_remote_data_source.dart';
import 'package:treemov/features/kid_profile/data/repositories/student_profile_repository_impl.dart';
import 'package:treemov/features/kid_profile/domain/repositories/student_profile_repository.dart';
import 'package:treemov/features/kid_profile/presentation/bloc/student_profile_bloc.dart';
import 'package:treemov/features/notes/data/datasources/local_notes_datasource.dart';
// import 'package:treemov/features/notes/data/datasources/teacher_notes_remote_data_source.dart';
import 'package:treemov/features/notes/domain/repositories/local_notes_repository.dart';
import 'package:treemov/features/notes/domain/repositories/local_notes_repository_impl.dart';
import 'package:treemov/features/organizations/data/datasources/orgs_remote_data_source.dart';
import 'package:treemov/features/organizations/data/repositories/orgs_repository_impl.dart';
import 'package:treemov/features/organizations/domain/repositories/orgs_repository.dart';
import 'package:treemov/features/organizations/presentation/bloc/orgs_bloc.dart';
import 'package:treemov/features/raiting/data/datasource/rating_remote_data_source.dart';
import 'package:treemov/features/raiting/data/repositories/rating_repository_impl.dart';
import 'package:treemov/features/raiting/domain/repositories/rating_repository.dart';
import 'package:treemov/features/raiting/presentation/blocs/rating_bloc.dart';
import 'package:treemov/features/registration/data/datasources/register_remote_data_source.dart';
import 'package:treemov/features/registration/data/repositories/register_repository_impl.dart';
import 'package:treemov/features/registration/domain/repositories/register_repository.dart';
import 'package:treemov/features/registration/presentation/bloc/register_bloc.dart';
import 'package:treemov/features/teacher_calendar/data/datasources/schedule_remote_data_source.dart';
import 'package:treemov/features/teacher_calendar/data/repositories/schedule_repository_impl.dart';
import 'package:treemov/features/teacher_calendar/domain/repositories/schedule_repository.dart';
import 'package:treemov/features/teacher_calendar/presentation/bloc/schedules_bloc.dart';
import 'package:treemov/features/teacher_profile/data/services/settings_service.dart';
import 'package:treemov/features/teacher_profile/presentation/bloc/teacher_profile_bloc.dart';
import 'package:treemov/shared/data/datasources/shared_remote_data_source.dart';
import 'package:treemov/shared/data/repositories/shared_repository_impl.dart';
import 'package:treemov/shared/domain/repositories/shared_repository.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Локальные хранилища
  getIt.registerLazySingleton<SecureStorageRepository>(
    () => SecureStorageFactory.create(),
  );
  getIt.registerSingleton<LocalNotesDataSource>(LocalNotesDataSource());

  // Клиент
  getIt.registerSingleton<DioClient>(
    DioClient(secureStorage: getIt<SecureStorageRepository>()),
  );

  // Сервисы
  getIt.registerLazySingleton<NavigationService>(() => NavigationService());
  getIt.registerSingleton<SettingsService>(SettingsService());

  // Источники данных
  getIt.registerSingleton<AuthRemoteDataSource>(
    AuthRemoteDataSource(getIt<DioClient>()),
  );
  getIt.registerSingleton<ScheduleRemoteDataSource>(
    ScheduleRemoteDataSource(
      getIt<DioClient>(),
      getIt<SecureStorageRepository>(),
    ),
  );
  getIt.registerSingleton<SharedRemoteDataSource>(
    SharedRemoteDataSource(
      getIt<DioClient>(),
      getIt<SecureStorageRepository>(),
    ),
  );
  getIt.registerSingleton<AccrualRemoteDataSource>(
    AccrualRemoteDataSource(getIt<DioClient>()),
  );
  getIt.registerSingleton<RegisterRemoteDataSource>(
    RegisterRemoteDataSourceImpl(getIt<DioClient>()),
  );
  getIt.registerSingleton<OrgsRemoteDataSource>(
    OrgsRemoteDataSource(getIt<DioClient>()),
  );
  getIt.registerSingleton<StudentProfileRemoteDataSource>(
    StudentProfileRemoteDataSource(
      getIt<DioClient>(),
      getIt<SecureStorageRepository>(),
    ),
  );
  // getIt.registerSingleton<TeacherNotesRemoteDataSource>(
  //   TeacherNotesRemoteDataSource(getIt<DioClient>()),
  // );
  getIt.registerSingleton<RatingRemoteDataSource>(
    RatingRemoteDataSource(getIt<DioClient>()),
  );

  // Репозитории
  getIt.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(getIt<AuthRemoteDataSource>()),
  );
  getIt.registerSingleton<ScheduleRepository>(
    ScheduleRepositoryImpl(getIt<ScheduleRemoteDataSource>()),
  );
  getIt.registerSingleton<SharedRepository>(
    SharedRepositoryImpl(getIt<SharedRemoteDataSource>()),
  );
  getIt.registerSingleton<AccrualRepository>(
    AccrualRepositoryImpl(getIt<AccrualRemoteDataSource>()),
  );
  getIt.registerSingleton<LocalNotesRepository>(
    LocalNotesRepositoryImpl(getIt<LocalNotesDataSource>()),
  );
  getIt.registerSingleton<RegisterRepository>(
    RegisterRepositoryImpl(getIt<RegisterRemoteDataSource>()),
  );
  getIt.registerSingleton<OrgsRepository>(
    OrgsRepositoryImpl(getIt<OrgsRemoteDataSource>()),
  );
  getIt.registerSingleton<StudentProfileRepository>(
    StudentProfileRepositoryImpl(getIt<StudentProfileRemoteDataSource>()),
  );
  // getIt.registerSingleton<TeacherNotesRepository>(
  //   TeacherNotesRepositoryImpl(getIt<TeacherNotesRemoteDataSource>()),
  // );
  getIt.registerSingleton<RatingRepository>(
    RatingRepositoryImpl(getIt<RatingRemoteDataSource>()),
  );

  // BLoC
  getIt.registerFactory<LoginBloc>(
    () => LoginBloc(getIt<AuthRepository>(), getIt<SecureStorageRepository>()),
  );

  getIt.registerFactory<SchedulesBloc>(
    () => SchedulesBloc(getIt<ScheduleRepository>(), getIt<SharedRepository>()),
  );

  getIt.registerFactory<DirectoryBloc>(
    () => DirectoryBloc(getIt<SharedRepository>()),
  );
  // getIt.registerFactory<NotesBloc>(
  //   () => NotesBloc(
  //     getIt<TeacherNotesRepository>(),
  //     getIt<LocalNotesRepository>(),
  //   ),
  // );
  getIt.registerFactory<AccrualBloc>(
    () => AccrualBloc(getIt<SharedRepository>(), getIt<AccrualRepository>()),
  );

  getIt.registerFactory<TeacherProfileBloc>(
    () => TeacherProfileBloc(getIt<SharedRepository>()),
  );

  getIt.registerFactory<StudentProfileBloc>(
    () => StudentProfileBloc(getIt<StudentProfileRepository>()),
  );

  getIt.registerFactory<RegisterBloc>(
    () => RegisterBloc(repository: getIt<RegisterRepository>()),
  );

  getIt.registerFactory<OrgsBloc>(() => OrgsBloc(getIt<OrgsRepository>()));

  getIt.registerFactory<RatingBloc>(
    () => RatingBloc(getIt<RatingRepository>()),
  );

  // Тема
  getIt.registerSingleton<ThemeCubit>(ThemeCubit(getIt<SettingsService>()));
}
