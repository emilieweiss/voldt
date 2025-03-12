import 'package:flutter/material.dart';
import 'package:voldt/core/theme/app_pallete.dart';
import 'package:voldt/features/auth/presentation/widgets/auth_field.dart';
import 'package:voldt/features/auth/presentation/widgets/auth_gradient_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: AppPallete.woltBlue,
              ),
            ),
            SizedBox(height: 50),
            AuthField(hintText: 'Name'),
            SizedBox(height: 20),
            AuthField(hintText: 'Email'),
            SizedBox(height: 20),
            AuthField(hintText: 'Password'),
            SizedBox(height: 20),
            AuthGradientButton(),
          ],
        ),
      ),
    );
  }
}
