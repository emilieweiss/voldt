import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:voldt/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:voldt/core/theme/app_pallete.dart';
import 'package:voldt/widgets/job_header_image.dart'; // serviceLocator<SupabaseClient>()

class JobInfoPage extends StatelessWidget {
  final Map<String, dynamic> job;

  const JobInfoPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'voldt',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: AppPallete.white,
          ),
        ),
        backgroundColor: AppPallete.woltBlue,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AppUserCubit>().logOut();
              context.go('/');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            JobHeaderImage(job: job),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    job['title'] ?? 'No Title',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    job['description'] ?? 'No Description',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
