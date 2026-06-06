import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'onboarding_screen.dart';
import '../constants/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navyBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ALU logo box
            Container(
              width: 118,
              height: 108,
              decoration: BoxDecoration(
                color: AppColors.red,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.red.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'CONNECT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
                children: [
                  TextSpan(
                    text: 'ALU',
                    style: TextStyle(color: AppColors.white),
                  ),
                  TextSpan(
                    text: 'Connect',
                    style: TextStyle(color: AppColors.red),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'YOUR CAMPUS CONNECTED',
              style: TextStyle(
                color: AppColors.offWhite,
                fontSize: 12,
                letterSpacing: 2,
                fontWeight: FontWeight.w500,
              ),
            ),

          ],
        ),
      ),
    );
  }
}
