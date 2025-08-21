import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voldt/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:voldt/widgets/app_bar.dart';
import 'package:voldt/widgets/job_card.dart';
import 'package:voldt/init_dependencies.dart';

class JobListPage extends StatefulWidget {
  const JobListPage({super.key});

  @override
  JobListPageState createState() => JobListPageState();
}

class JobListPageState extends State<JobListPage> {
  List<Map<String, dynamic>> jobs = [];
  bool loading = true;
  RealtimeChannel? _jobsSub;

  @override
  void initState() {
    super.initState();
    fetchJobsForCurrentUser();
    _subscribeToJobs();
  }

  @override
  void dispose() {
    _jobsSub?.unsubscribe();
    super.dispose();
  }

  Future<void> fetchJobsForCurrentUser() async {
    try {
      final supabase = serviceLocator<SupabaseClient>();
      final user = supabase.auth.currentUser;
      if (user == null) {
        setState(() {
          jobs = [];
          loading = false;
        });
        return;
      }

      final uid = user.id;

      final rows = await supabase
          .from('user_jobs')
          .select(
            // fjern image_url, findes ikke på user_jobs
            'id, job_id, title, description, address, duration, delivery, money, job_image_url, image_solved_url, approved, solved',
          )
          .eq('user_id', uid)
          .order('id', ascending: false);

      // kompatibilitet: hvis widgets forventer 'image_url'
      final list =
          List<Map<String, dynamic>>.from(rows).map((r) {
            final m = Map<String, dynamic>.from(r);
            m['image_url'] ??= m['job_image_url'];
            return m;
          }).toList();

      // Check for (solved == null eller false)
      final filtered =
          list.where((r) => r['solved'] != true).toList();

      setState(() {
        jobs = filtered;
        loading = false;
      });
    } catch (e, st) {
      debugPrint('fetch ERROR: $e\n$st');
      setState(() {
        jobs = [];
        loading = false;
      });
    }
  }

  void _subscribeToJobs() {
    final supabase = serviceLocator<SupabaseClient>();
    final uid = supabase.auth.currentUser?.id;
    if (uid == null) {
      debugPrint('realtime: no uid, not subscribing');
      return;
    }

    _jobsSub =
        supabase
            .channel('user_jobs-$uid')
            .onPostgresChanges(
              event: PostgresChangeEvent.insert,
              schema: 'public',
              table: 'user_jobs',
              filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'user_id',
                value: uid,
              ),
              callback: (payload) {
                debugPrint(
                  'realtime INSERT: ${payload.newRecord}',
                );
                fetchJobsForCurrentUser();
              },
            )
            // UPDATE -> fjern hvis solved blev true, ellers hent igen
            .onPostgresChanges(
              event: PostgresChangeEvent.update,
              schema: 'public',
              table: 'user_jobs',
              filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'user_id',
                value: uid,
              ),
              callback: (payload) {
                final row = payload.newRecord;
                debugPrint('realtime UPDATE: $row');
                if (row != null && row['solved'] == true) {
                  setState(() {
                    jobs.removeWhere(
                      (j) => j['id'] == row['id'],
                    );
                  });
                } else {
                  fetchJobsForCurrentUser();
                }
              },
            )
            // DELETE -> hent igen
            .onPostgresChanges(
              event: PostgresChangeEvent.delete,
              schema: 'public',
              table: 'user_jobs',
              filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'user_id',
                value: uid,
              ),
              callback: (payload) {
                debugPrint(
                  'realtime DELETE: ${payload.oldRecord}',
                );
                fetchJobsForCurrentUser();
              },
            )
            .subscribe();

    debugPrint(
      'realtime: subscribed on channel user_jobs-$uid',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VoldtAppBar(
        onLogout: () {
          context.read<AppUserCubit>().logOut();
          context.go('/');
        },
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
                itemCount: jobs.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const SizedBox(height: 10);
                  }
                  final job = jobs[index - 1];
                  return JobCard(
                    job: job,
                    onTap:
                        () => context.push(
                          '/job-info',
                          extra: job,
                        ),
                  );
                },
              ),
    );
  }
}
