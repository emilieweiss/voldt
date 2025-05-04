import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:voldt/widgets/loader.dart';
import 'package:voldt/core/theme/app_pallete.dart';
import 'package:voldt/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:voldt/widgets/auth_field.dart';
import 'package:voldt/widgets/auth_gradient_button.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<LogInPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is AuthSuccess) {
          context.go('/');
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return Scaffold(
            body:
                state is AuthLoading
                    ? const Loader() // Sørger for, at Loader fylder hele skærmen
                    : Padding(
                      padding: const EdgeInsets.all(15),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            Text(
                              'Log ind',
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: AppPallete.woltBlue,
                              ),
                            ),
                            const SizedBox(height: 50),
                            AuthField(
                              hintText: 'Email',
                              controller: emailController,
                            ),
                            const SizedBox(height: 20),
                            AuthField(
                              hintText: 'Kodeord',
                              controller:
                                  passwordController,
                              isPassword: true,
                            ),
                            const SizedBox(height: 20),
                            AuthGradientButton(
                              name: 'Log ind',
                              onPressed: () {
                                if (formKey.currentState!
                                    .validate()) {
                                  context.read<AuthBloc>().add(
                                    AuthLogin(
                                      email:
                                          emailController
                                              .text
                                              .trim(),
                                      password:
                                          passwordController
                                              .text
                                              .trim(),
                                    ),
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: () {
                                context.go('/signup');
                              },
                              child: RichText(
                                text: TextSpan(
                                  text:
                                      'Har du ikke en profil? ',
                                  style: TextStyle(
                                    color: AppPallete.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Opret profil',
                                      style: Theme.of(
                                            context,
                                          )
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color:
                                                AppPallete
                                                    .woltBlue,
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
          );
        },
      ),
    );
  }
}
