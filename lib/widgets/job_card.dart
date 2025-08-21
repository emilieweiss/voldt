import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voldt/core/theme/app_pallete.dart';

class JobCard extends StatefulWidget {
  final Map<String, dynamic> job;
  final VoidCallback? onTap;
  const JobCard({super.key, required this.job, this.onTap});

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  Timer? _t60, _t15;
  bool _seen = false;

  // nøgle med dato -> nulstilles hver dag
  String get _seenKey {
    final id =
        widget.job['id'] ??
        widget.job['job_id'] ??
        widget.job.hashCode;
    final d = DateTime.now();
    final day = '${d.year}-${d.month}-${d.day}';
    return 'seen_job_${id}_$day';
  }

  @override
  void initState() {
    super.initState();
    _loadSeen();
    _scheduleColorFlips();
  }

  @override
  void didUpdateWidget(covariant JobCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.job != widget.job) {
      _loadSeen();
      _scheduleColorFlips();
    }
  }

  @override
  void dispose() {
    _t60?.cancel();
    _t15?.cancel();
    super.dispose();
  }

  Future<void> _loadSeen() async {
    final sp = await SharedPreferences.getInstance();
    setState(() => _seen = sp.getBool(_seenKey) ?? false);
  }

  Future<void> _markSeen() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool(_seenKey, true);
    if (mounted) setState(() => _seen = true);
  }

  DateTime _deliveryToday() {
    final raw = widget.job['delivery']?.toString() ?? '';
    final p = raw.split(':'); // "08:15"
    final now = DateTime.now();
    final h = int.tryParse(p.isNotEmpty ? p[0] : '0') ?? 0;
    final m = int.tryParse(p.length > 1 ? p[1] : '0') ?? 0;
    return DateTime(now.year, now.month, now.day, h, m);
  }

  Color _bgColor() {
    final now = DateTime.now();
    final del = _deliveryToday();
    // rød fra 15 min før og resten af dagen (også efter leveringstid)
    if (now.isAfter(
      del.subtract(const Duration(minutes: 15)),
    )) {
      return Colors.red.shade100;
    }
    if (now.isAfter(
      del.subtract(const Duration(hours: 1)),
    )) {
      return Colors.amber.shade100;
    }
    return AppPallete.mediumGrey;
  }

  void _scheduleColorFlips() {
    _t60?.cancel();
    _t15?.cancel();
    final now = DateTime.now();
    final del = _deliveryToday();
    final t60 = del.subtract(const Duration(minutes: 60));
    final t15 = del.subtract(const Duration(minutes: 15));
    if (t60.isAfter(now)) {
      _t60 = Timer(t60.difference(now), () {
        if (mounted) setState(() {});
      });
    }
    if (t15.isAfter(now)) {
      _t15 = Timer(t15.difference(now), () {
        if (mounted) setState(() {});
      });
    }
  }

  // helper
  String _hhmm(dynamic v) {
    if (v == null) return '—';
    final parts = v.toString().split(':');
    if (parts.length >= 2) {
      return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
    }
    return v.toString();
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;
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
      onTap: () {
        _markSeen();
        widget.onTap?.call();
      },
      child: Stack(
        children: [
          Card(
            elevation: 0,
            margin: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 20,
            ),
            color: _bgColor(),
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
                          padding:
                              const EdgeInsets.fromLTRB(
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
                          padding:
                              const EdgeInsets.fromLTRB(
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
                  const Center(
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

          // rød prik (forsvinder efter første åbning)
          if (!_seen)
            Positioned(
              right: 28,
              top: 6,
              child: Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
