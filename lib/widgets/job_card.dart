import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:voldt/core/theme/app_pallete.dart';

class JobCard extends StatelessWidget {
  final Map<String, dynamic> job;
  final VoidCallback? onTap;

  const JobCard({super.key, required this.job, this.onTap});

  // helper
  String _hhmm(dynamic v) {
    if (v == null) return '—';
    final parts = v.toString().split(
      ':',
    ); // ["10","45","00"]
    if (parts.length >= 2) {
      return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    }
    return v.toString();
  }

  @override
  Widget build(BuildContext context) {
    final title = (job['title'] ?? 'Job titel').toString();
    final desc =
        (job['description'] ?? 'Beskrivelse').toString();
    final money =
        job['money'] == null ? '—' : '${job['money']} kr';
    final duration =
        job['duration'] == null
            ? '—'
            : '${job['duration']} min';
    final delivery = _hhmm(job['delivery']);

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        margin: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 20,
        ),
        color: AppPallete.mediumGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            16,
            12,
            10,
            14,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    // Titel
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        2,
                        6,
                        16,
                        0,
                      ),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Beskrivelse
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        2,
                        6,
                        16,
                        10,
                      ),
                      child: Text(
                        desc,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                          height: 1.25,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Løn • Tidsestimat • Leveringstidspunkt
                    Row(
                      children: [
                        const Icon(
                          Icons.attach_money,
                          size: 22,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          money,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(width: 18),
                        const Icon(
                          Icons.schedule,
                          size: 20,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          duration,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(width: 18),
                        SvgPicture.asset(
                          'assets/icons/delivery_truck_speed.svg',
                          height: 22,
                          width: 22,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          delivery,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Center(
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.black38,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
