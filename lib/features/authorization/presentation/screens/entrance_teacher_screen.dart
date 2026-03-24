import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treemov/app/di/di.config.dart';
import 'package:treemov/app/routes/app_routes.dart';
import 'package:treemov/core/storage/secure_storage_repository.dart';
import 'package:treemov/core/themes/app_colors.dart';
import 'package:treemov/core/themes/app_text_styles.dart';
import 'package:treemov/core/widgets/auth/auth_header.dart';
import 'package:treemov/features/authorization/domain/repositories/auth_repository.dart';
import 'package:treemov/features/authorization/presentation/bloc/login_bloc.dart';
import 'package:treemov/shared/presentation/widgets/app_primary_button.dart';
import 'package:treemov/shared/presentation/widgets/app_text_field.dart';

class EntranceTeacherScreen extends StatelessWidget {
  const EntranceTeacherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          LoginBloc(getIt<AuthRepository>(), getIt<SecureStorageRepository>()),
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.mainApp,
              (route) => false,
            );
          } else if (state is LoginError) {
            _showErrorDialog(context, state.error);
          }
        },
        child: const _EntranceTeacherContent(),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          'Ошибка входа',
          style: AppTextStyles.ttNorms20W500.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.teacherPrimary,
          ),
        ),
        content: Text(
          _parseError(error),
          style: AppTextStyles.ttNorms16W400.copyWith(color: AppColors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: AppTextStyles.ttNorms16W400.primary),
          ),
        ],
      ),
    );
  }

  String _parseError(String error) {
    if (error.contains('No active account found with the given credentials')) {
      return 'Неверный email или пароль. Проверьте введенные данные.';
    } else {
      return error;
    }
  }
}

class _EntranceTeacherContent extends StatefulWidget {
  const _EntranceTeacherContent();

  @override
  State<_EntranceTeacherContent> createState() =>
      _EntranceTeacherContentState();
}

class _EntranceTeacherContentState extends State<_EntranceTeacherContent> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showValidationError();
      return;
    }

    context.read<LoginBloc>().add(
      LoginSubmitted(email: email, password: password),
    );
  }

  void _showValidationError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.teacherPrimary,
        content: Text(
          'Заполните все поля',
          style: AppTextStyles.ttNorms14W400.white,
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final isLoading = state is LoginLoading;

        return Scaffold(
          backgroundColor: AppColors.teacherPrimary,
          body: Stack(
            children: [
              const AuthHeader(),
              Center(
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        Text('Вход', style: AppTextStyles.ttNorms24W900.white),
                        const SizedBox(height: 40),
                        AppTextField(
                          controller: _emailController,
                          hintText: 'Email',
                          fillColor: AppColors.white,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        AppTextField(
                          controller: _passwordController,
                          hintText: 'Пароль',
                          obscureText: _obscurePassword,
                          fillColor: AppColors.white,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: AppColors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        AppPrimaryButton(
                          text: 'Войти',
                          onPressed: isLoading ? null : _login,
                          isLoading: isLoading,
                          backgroundColor: AppColors.teacherButton,
                          width: double.infinity,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
