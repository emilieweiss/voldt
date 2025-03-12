import 'package:flutter/material.dart';
import 'package:voldt/core/theme/theme.dart';
import 'package:voldt/features/auth/presentation/pages/signup_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Voldt App',
      theme: AppTheme.lightThemeMode,
      home: const SignUpPage(),
    );
  }
}
