import 'package:flutter/material.dart';
import 'package:voldt/core/theme/app_pallete.dart';
import 'package:flutter_svg/flutter_svg.dart';

class JobCard extends StatelessWidget {
  final Map<String, dynamic> job;
  final VoidCallback? onTap;

  const JobCard({super.key, required this.job, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0.0,
        margin: const EdgeInsets.symmetric(
          vertical: 8.0,
          horizontal: 20,
        ),
        color: AppPallete.mediumGrey,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            16,
            10,
            10,
            10,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        5,
                        5,
                        0,
                        5,
                      ),
                      child: Text(
                        job['title'] ?? 'Job titel',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                        5,
                        0,
                        0,
                        10,
                      ),
                      child: Text(
                        job['description'] ?? 'Beskrivelse',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/attach_money.svg',
                          color: Colors.grey,
                          height: 30,
                          width: 30,
                        ),
                        const SizedBox(width: 5),
                        Text('100 kr'),
                        const SizedBox(width: 20),
                        SvgPicture.asset(
                          'assets/icons/schedule.svg',
                          color: Colors.grey,
                          height: 30,
                          width: 30,
                        ),
                        const SizedBox(width: 10),
                        Text('20 min'),
                        const SizedBox(width: 20),
                        SvgPicture.asset(
                          'assets/icons/delivery_truck_speed.svg',
                          color: Colors.grey,
                          height: 30,
                          width: 30,
                        ),
                        const SizedBox(width: 10),
                        Text('11:45'),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(1),
                child: SvgPicture.asset(
                  'assets/icons/arrow_forward.svg',
                  color: Colors.grey,
                  height: 25,
                  width: 25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
