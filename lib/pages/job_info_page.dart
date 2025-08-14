import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:voldt/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:voldt/core/theme/app_pallete.dart';
import 'package:voldt/widgets/app_bar.dart';
import 'package:voldt/widgets/job_header_image.dart';
import 'package:voldt/widgets/finish_job_dialog.dart';
import 'package:image_picker/image_picker.dart';

class JobInfoPage extends StatelessWidget {
  final Map<String, dynamic> job;

  const JobInfoPage({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    final title =
        (job['title'] ?? 'Opgavetitle').toString();
    final description =
        (job['description'] ?? 'Ingen beskrivelse')
            .toString();
    final address = (job['address'] ?? 'Ukendt').toString();
    final durationTxt = _formatDuration(job['duration']);
    final deliveryTxt = _formatDelivery(job['delivery']);
    final pointsTxt =
        'Løn ${_formatPoints(job['money'])}kr.';

    return Scaffold(
      appBar: VoldtAppBar(
        onLogout: () {
          context.read<AppUserCubit>().logOut();
          context.go('/');
        },
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
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pointsTxt,
                    style: const TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text(
                    'Opgavebeskrivelse',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  _KV('Leveringstidspunkt', deliveryTxt),
                  _KV('Adresse', address),
                  _KV('Estimat', durationTxt),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 30),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPallete.woltBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                barrierDismissible: false,
                builder:
                    (_) => FinishJobDialog(
                      title: title,
                      job: job,
                    ),
              );

              if (ok == true && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Opgave afleveret'),
                  ),
                );
                // valgfrit: Navigator.of(context).maybePop();
              }
            },
            child: const Text(
              'Aflever opgave',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// helpers
String _formatDuration(dynamic v) {
  if (v == null) return '—';
  try {
    final n =
        (v is num) ? v.toInt() : int.parse(v.toString());
    return '$n min';
  } catch (_) {
    return v.toString();
  }
}

String _formatDelivery(dynamic v) {
  if (v == null) return '—';
  final s = v.toString();
  final m = RegExp(r'(\d{2}):(\d{2})').firstMatch(s);
  return m != null ? '${m.group(1)}:${m.group(2)}' : s;
}

String _formatPoints(dynamic v) {
  if (v == null) return '—';
  final n = (v is num) ? v : num.tryParse(v.toString());
  if (n == null) return '—';
  final i = n.toInt();
  return (n - i).abs() < 0.01 ? '$i' : n.toString();
}

class _KV extends StatelessWidget {
  final String k, v;
  const _KV(this.k, this.v);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              k,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(v, textAlign: TextAlign.right),
        ],
      ),
    );
  }
}
