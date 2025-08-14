import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:voldt/init_dependencies.dart';

class JobHeaderImage extends StatelessWidget {
  final Map<String, dynamic> job;
  final String bucket;
  const JobHeaderImage({
    super.key,
    required this.job,
    this.bucket = 'job-images',
  });

  @override
  Widget build(BuildContext context) {
    final raw =
        (job['image_url'] ?? job['job_image_url'])
            ?.toString();
    if (raw == null || raw.isEmpty)
      return const SizedBox.shrink();

    final url =
        raw.startsWith('http')
            ? raw
            : serviceLocator<SupabaseClient>().storage
                .from(bucket)
                .getPublicUrl(raw);

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(16),
        bottomRight: Radius.circular(16),
      ),
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder:
              (_, __, ___) => Container(
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                child: const Icon(
                  Icons.image_not_supported,
                ),
              ),
        ),
      ),
    );
  }
}
