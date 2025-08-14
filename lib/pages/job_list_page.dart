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
    fetchJobsForCurrentUser();
  }

  Future<void> fetchJobsForCurrentUser() async {
    try {
      final supabase = serviceLocator<SupabaseClient>();

      // Tjek om der er en indlogget bruger
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) {
        setState(() {
          jobs = [];
          loading = false;
        });
        return;
      }

      final uid = currentUser.id;
      final rows = await supabase
          .from('user_jobs')
          .select('*, job(*)')
          .eq('user_id', uid);

      final mappedJobs =
          List<Map<String, dynamic>>.from(
            rows.map(
              (r) =>
                  Map<String, dynamic>.from(r['job'] ?? {}),
            ),
          ).where((j) => j.isNotEmpty).toList();

      setState(() {
        jobs = mappedJobs;
        loading = false;
      });
    } catch (e) {
      setState(() {
        jobs = [];
        loading = false;
      });
    }
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
