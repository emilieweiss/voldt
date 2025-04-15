import 'package:go_router/go_router.dart';
import 'package:voldt/pages/job_list_page.dart';
import 'package:voldt/pages/login_page.dart';
import 'package:voldt/pages/signup_page.dart';
import 'package:voldt/pages/job_info_page.dart';

final GoRouter appRouter = GoRouter(
  routes: [
    // GoRoute(
    //   path: '/',
    //   builder: (context, state) => JobListPage(),
    // ),
    GoRoute(
      path: '/',
      builder: (context, state) => LogInPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => SignUpPage(),
    ),
    //GoRoute(path: '/jobs', builder: (context, state) => JobListPage()),
    GoRoute(
      path: '/job-info',
      builder:
          (context, state) => JobInfoPage(
            job: state.extra as Map<String, dynamic>,
          ),
    ),
  ],
);
