import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:voldt/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:voldt/pages/job_list_page.dart';
import 'package:voldt/pages/login_page.dart';
import 'package:voldt/pages/signup_page.dart';
import 'package:voldt/pages/job_info_page.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => LogInPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => SignUpPage(),
    ),
    GoRoute(
      path: '/job-list',
      builder: (context, state) => JobListPage(),
    ),
    GoRoute(
      path: '/job-info',
      builder:
          (context, state) => JobInfoPage(
            job: state.extra as Map<String, dynamic>,
          ),
    ),
  ],
  redirect: (context, state) {
    final isLoggedIn =
        context.read<AppUserCubit>().state
            is AppUserLoggedIn;
    final isLoggingIn = state.uri.path == '/';
    final isSigningUp = state.uri.path == '/signup';

    if (!isLoggedIn && (isLoggingIn || isSigningUp)) {
      return null;
    }
    if (!isLoggedIn) {
      return '/';
    }
    if (isLoggedIn && (isLoggingIn || isSigningUp)) {
      return '/job-list';
    }
    return null;
  },
);
