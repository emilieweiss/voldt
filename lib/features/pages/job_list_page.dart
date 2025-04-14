import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:voldt/core/theme/app_pallete.dart';
import 'package:voldt/widgets/job_card.dart';

class JobListPage extends StatefulWidget {
  const JobListPage({super.key});

  @override
  _JobListPageState createState() => _JobListPageState();
}

class _JobListPageState extends State<JobListPage> {
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
      ),

      body: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                JobCard(
                  job: {
                    'title': 'Byg en dør',
                    'description':
                        'Byg en dør af rafter og plader.',
                  },
                  onTap: () {
                    context.push(
                      '/job-info',
                      extra: {
                        'title': 'Byg en dør',
                        'description':
                            'Byg en dør af rafter og plader.',
                      },
                    );
                  },
                ),
                JobCard(
                  job: {
                    'title': 'Væg på bestilling',
                    'description':
                        'Væggen skal bygges af 2x4 og plader.',
                  },
                  onTap: () {
                    context.push(
                      '/job-info',
                      extra: {
                        'title': 'Væg på bestilling',
                        'description':
                            'Væggen skal bygges af 2x4 og plader.',
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
