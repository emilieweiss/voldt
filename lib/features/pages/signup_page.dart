import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:voldt/core/theme/app_pallete.dart';
import 'package:voldt/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:voldt/widgets/auth_field.dart';
import 'package:voldt/widgets/auth_gradient_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
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
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              context.go('/');
            },
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Text(
                      'Opret profil',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: AppPallete.woltBlue,
                      ),
                    ),
                    const SizedBox(height: 50),
                    AuthField(
                      hintText: 'Navn',
                      controller: nameController,
                    ),
                    const SizedBox(height: 20),
                    AuthField(
                      hintText: 'Email',
                      controller: emailController,
                    ),
                    const SizedBox(height: 20),
                    AuthField(
                      hintText: 'Kodeord',
                      controller: passwordController,
                      isPassword: true,
                    ),
                    const SizedBox(height: 20),
                    AuthGradientButton(
                      name: 'Opret profil',
                      onPressed: () {
                        FocusScope.of(context).unfocus();

                        if (formKey.currentState!
                            .validate()) {
                          context.read<AuthBloc>().add(
                            AuthSignUp(
                              name:
                                  nameController.text
                                      .trim(),
                              email:
                                  emailController.text
                                      .trim(),
                              password:
                                  passwordController.text
                                      .trim(),
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        context.go('/');
                      },
                      child: RichText(
                        text: TextSpan(
                          text:
                              'Har du allerede en profil? ',
                          style: TextStyle(
                            color: AppPallete.black,
                          ),
                          children: [
                            TextSpan(
                              text: 'Log ind',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color:
                                        AppPallete.woltBlue,
                                    fontWeight:
                                        FontWeight.bold,
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
          ),
        ),
      ),
    );
  }
}
