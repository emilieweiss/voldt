import 'package:go_router/go_router.dart';
import 'package:voldt/features/auth/presentation/pages/login_page.dart';
import 'package:voldt/features/auth/presentation/pages/signup_page.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => LogInPage()),
    GoRoute(path: '/signup', builder: (context, state) => SignUpPage()),
  ],
);
