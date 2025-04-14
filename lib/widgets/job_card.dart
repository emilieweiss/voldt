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
                        0,
                      ),
                      child: Text(
                        job['title'] ?? 'Job titel',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      job['description'] ?? 'Beskrivelse',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.attach_money,
                          color: Colors.grey,
                          size: 25,
                          weight: 100,
                        ),
                        Icon(
                          Icons.schedule,
                          color: Colors.grey,
                          size: 25,
                          weight: 100,
                        ),
                        SvgPicture.asset(
                          'assets/icons/delivery_truck_speed.svg',
                          color: Colors.grey,
                          height: 40,
                          width: 40,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(1),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                  size: 16.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
