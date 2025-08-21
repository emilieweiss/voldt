import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voldt/core/theme/app_pallete.dart';
import 'package:voldt/init_dependencies.dart';
import 'package:voldt/pages/job_success_delivery_page.dart';

class FinishJobDialog extends StatefulWidget {
  final String title;
  final Map<String, dynamic> job;
  final String bucket;
  const FinishJobDialog({
    super.key,
    required this.title,
    required this.job,
    this.bucket = 'job-images',
  });

  @override
  State<FinishJobDialog> createState() =>
      _FinishJobDialogState();
}

class _FinishJobDialogState extends State<FinishJobDialog> {
  final _picker = ImagePicker();
  XFile? _file;
  bool _loading = false;

  Future<void> _pickFromCamera() async {
    final f = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    if (!mounted) return;
    setState(() => _file = f);
  }

  String _ext(XFile f) =>
      f.name.contains('.')
          ? f.name.substring(f.name.lastIndexOf('.'))
          : '.jpg';

  DateTime _deliveryToday() {
    final raw =
        widget.job['delivery']?.toString() ?? '00:00';
    final p = raw.split(':');
    final now = DateTime.now();
    final h = int.tryParse(p.isNotEmpty ? p[0] : '0') ?? 0;
    final m = int.tryParse(p.length > 1 ? p[1] : '0') ?? 0;
    return DateTime(now.year, now.month, now.day, h, m);
  }

  bool get _isOverdue =>
      DateTime.now().isAfter(_deliveryToday());

  Future<bool> _submit() async {
    if (_file == null || _loading || _isOverdue)
      return false;
    setState(() => _loading = true);
    try {
      final supabase = serviceLocator<SupabaseClient>();
      final uid = supabase.auth.currentUser!.id;
      final jobId =
          widget.job['job_id'] ?? widget.job['id'];
      final path =
          'solved/$uid/${jobId}_${DateTime.now().millisecondsSinceEpoch}${_ext(_file!)}';

      await supabase.storage
          .from(widget.bucket)
          .upload(
            path,
            File(_file!.path),
            fileOptions: const FileOptions(upsert: false),
          );

      final publicUrl = supabase.storage
          .from(widget.bucket)
          .getPublicUrl(path);

      await supabase
          .from('user_jobs')
          .update({
            'solved': true,
            'approved': false,
            'image_solved_url': publicUrl,
          })
          .eq('user_id', uid)
          .eq('job_id', jobId);

      return true;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Fejl: $e')));
      }
      return false;
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 24,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            20,
            16,
            20,
            20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed:
                        () => Navigator.of(
                          context,
                        ).pop(false),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'OBS! Før opgaven kan afleveres, skal der tages/uploades et billede som bevis.',
                style: TextStyle(
                  color: Colors.black87,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 20),

              Center(
                child: InkWell(
                  onTap:
                      _pickFromCamera, // åbner kameraet direkte
                  borderRadius: BorderRadius.circular(60),
                  child: Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(
                        60,
                      ),
                    ),
                    child: const Icon(
                      Icons.photo_camera,
                      size: 42,
                      color: AppPallete.woltBlue,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text('Tag foto med kamera'),
              ),
              const SizedBox(height: 12),

              if (_file != null)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _file!.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                  ],
                ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isOverdue
                            ? Colors.grey
                            : AppPallete.woltBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        14,
                      ),
                    ),
                  ),
                  onPressed:
                      (_file == null ||
                              _loading ||
                              _isOverdue)
                          ? null
                          : () async {
                            final ok = await _submit();
                            if (!mounted || !ok) return;
                            Navigator.of(context).pop();
                            Navigator.of(
                              context,
                              rootNavigator: true,
                            ).push(
                              MaterialPageRoute(
                                builder:
                                    (_) =>
                                        const JobSuccessDeliveryPage(),
                              ),
                            );
                          },
                  child: Text(
                    _isOverdue
                        ? 'Frist overskredet'
                        : (_loading
                            ? 'Afleverer…'
                            : 'Aflever nu'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
