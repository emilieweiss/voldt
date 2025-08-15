import 'package:flutter/material.dart';
import 'package:voldt/core/theme/app_pallete.dart';

class JobSuccessDeliveryPage extends StatelessWidget {
  const JobSuccessDeliveryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            24,
            24,
            24,
            32,
          ),
          child: Column(
            children: [
              const Spacer(),
              Image.asset(
                'assets/job_finished.png',
                width: 260,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 24),
              const Text(
                'Tillykke, dit job er nu afsluttet',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Mens du venter på at dit job bliver godkendt, '
                'kan du tage et nyt',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.35,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPallete.woltBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        14,
                      ),
                    ),
                  ),
                  onPressed: () {
                    // Tilbage til job-listen (pop alt indtil første skærm)
                    Navigator.of(
                      context,
                    ).popUntil((r) => r.isFirst);
                  },
                  child: const Text(
                    'Tilbage til jobs',
                    style: TextStyle(
                      fontSize: 18,
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
