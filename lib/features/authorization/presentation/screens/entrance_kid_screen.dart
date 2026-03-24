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

class EntranceKidScreen extends StatefulWidget {
  const EntranceKidScreen({super.key});

  @override
  State<EntranceKidScreen> createState() => _EntranceKidScreenState();
}

class _EntranceKidScreenState extends State<EntranceKidScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kidPrimary,
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
                    BlocProvider(
                      create: (context) => LoginBloc(
                        getIt<AuthRepository>(),
                        getIt<SecureStorageRepository>(),
                      ),
                      child: _LoginButton(
                        emailController: _emailController,
                        passwordController: _passwordController,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.registration);
                      },
                      child: Text(
                        'Регистрация',
                        style: AppTextStyles.ttNorms16W700.white,
                      ),
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
  }
}

// Отдельный виджет для кнопки с Bloc
class _LoginButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const _LoginButton({
    required this.emailController,
    required this.passwordController,
  });

  void _handleLogin(BuildContext context) {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      _showErrorSnackbar(context, 'Пожалуйста, заполните все поля');
      return;
    }

    context.read<LoginBloc>().add(
      LoginSubmitted(
        email: emailController.text,
        password: passwordController.text,
      ),
    );
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.myOrgs,
            (route) => false,
          );
        } else if (state is LoginError) {
          _showErrorSnackbar(context, state.error);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return SizedBox(
            width: double.infinity,
            height: 44,
            child: AppPrimaryButton(
              text: 'Войти',
              onPressed: state is LoginLoading
                  ? null
                  : () => _handleLogin(context),
              isLoading: state is LoginLoading,
              backgroundColor: AppColors.kidButton,
            ),
          );
        },
      ),
    );
  }
}
