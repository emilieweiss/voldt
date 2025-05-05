import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voldt/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:voldt/core/theme/app_pallete.dart';
import 'package:voldt/widgets/job_card.dart';
import 'package:voldt/init_dependencies.dart';

class JobListPage extends StatefulWidget {
  const JobListPage({super.key});

  @override
  _JobListPageState createState() => _JobListPageState();
}

class _JobListPageState extends State<JobListPage> {
  List<Map<String, dynamic>> jobs = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    final supabase = serviceLocator<SupabaseClient>();
    final response = await supabase.from('job').select();

    print("Fetched jobs: $response"); // debug

    setState(() {
      jobs = List<Map<String, dynamic>>.from(response);
      loading = false;
    });
  }

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
      body:
          loading
              ? const Center(
                child: CircularProgressIndicator(),
              )
              : jobs.isEmpty
              ? const Center(
                child: Text('Ingen opgaver endnu'),
              )
              : ListView.builder(
                itemCount: jobs.length,
                itemBuilder: (context, index) {
                  final job = jobs[index];
                  return JobCard(
                    job: job,
                    onTap: () {
                      context.push('/job-info', extra: job);
                    },
                  );
                },
              ),
    );
  }
}
