import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget{
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  int _currentStep = 0; //Tracks the step of onboarding

  final List<String> _selectedInterests = []; // To store chosen interests in step 2

  //To store cohort and Role
  String _selectedIntake = 'S2024';
  String _selectedRole = 'Student';

  // Interests
  final List<String> _allInterests = [
    'Tech & Software', 'Entrepreneurship', 'Leadership', 'Social Impact', 'Design', 'Finance', 'Arts & Culture', 'Health'
  ];

  final List<String> _intakes = [
    'J2023', 'M2023', 'S2023', 'J2024', 'M2024', 'S2024', 'J2025', 'M2025', 'S2025', 'J2026', 'M2026'
  ];

  final List<String> _roles = [
    'Student', 'Club Leader', 'Event Organizer'
  ];

  // When User taps continue or Get Started
  void _nextStep() {
    if(_currentStep < 2){
      setState(() => _currentStep++); //Move to the next step
    } else {
      // Moves to login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              _buildProgressDots(),
              const SizedBox(height: 36),

              // Show the right step
              if (_currentStep == 0) _buildStep1(),
              if (_currentStep == 1) _buildStep2(),
              if (_currentStep == 2) _buildStep3(),

              const Spacer(),

              _builContinueButton(),

              const SizedBox(height: 36),

            ],
          ),
          ),
        ),
    );
  }

  //Progress dots
  Widget _buildProgressDots() {
    return Row(
      children: List.generate(3, (i) {
        final bool active = i == _currentStep;
        return AnimatedContainer(
          duration: const Duration(microseconds: 300),
          margin: const EdgeInsets.only(right: 8),
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? AppColors.red : AppColors.lightGray,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }

  // Step 1: Welcome
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Icon box
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.red,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.school_rounded,
            color: AppColors.white,
            size: 28,
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          'Welcome to\nALU Connect',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: AppColors.navyBlue,
            height: 1.15,
            letterSpacing: -0.5,
          ),
        ),

        const SizedBox(height: 14),

        const Text(
          'Discover events, join communities and collaborate with the ALU community in one place.',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.gray,
            height: 1.5,
          ),
        ),

      ],
    );
  }

  //Step 2: Interest pick
  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text('Interests',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w800,
          color: AppColors.navyBlue,
          height: 1.15,
          letterSpacing: -0.5,
        ),
      ),

      const SizedBox(height: 8),

      const Text(
        'Pick your interests for the most relevant opportunities.',
        style: TextStyle(
          fontSize: 18,
          color: AppColors.gray,
          height: 1.5,
        ),
      ),

      const SizedBox(height: 16),

      Wrap(
        spacing: 10,
        runSpacing: 10,
        children: _allInterests.map((interest) {
          final bool selected = _selectedInterests.contains(interest);
          return GestureDetector(
            onTap: () {
              setState(() {
                if (selected) {
                  _selectedInterests.remove(interest);
                } else {
                  _selectedInterests.add(interest);
                }
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: selected ? AppColors.red : AppColors.offWhite,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: selected ? AppColors.red : AppColors.lightGray,
                ),
              ),
              child: Text(
                interest,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppColors.navyBlue,
                ),
              ),
            ),
          );
        }).toList(),
      ),

      ],
    );
  }
  //Step 3: Intake & Role
  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          'Almost there!',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w800,
            color: AppColors.navyBlue,
            letterSpacing: -0.5,
          ),
        ),

        const SizedBox(height: 8),

        const Text(
          'What is your role at ALU ?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.gray,
            height: 1.5,
          ),
        ),

        const SizedBox(height: 20),

        //Intake label
        const Text(
          'Select your intake',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.gray,
            letterSpacing: 1.5,
          ),
        ),

        const SizedBox(height: 15),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _intakes.map((c) => _buildChoiceChip(
            label: c,
            selected: _selectedIntake == c,
            onTap: () => setState(() => _selectedIntake = c),
          )).toList(),
        ),

        const SizedBox(height: 30),

        //Role label
        const Text(
          'Your Role',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.gray,
            letterSpacing: 1.5,
          ),
        ),

        const SizedBox(height: 15),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _roles.map((r) => _buildChoiceChip(
            label: r,
            selected: _selectedRole == r,
            onTap: () => setState(() => _selectedRole = r),
          )).toList(),
        ),

      ],
    );
  }

  // Step 3
  Widget _buildChoiceChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.navyBlue : AppColors.offWhite,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? AppColors.navyBlue : AppColors.lightGray,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppColors.navyBlue,
          ),
        ),
      ),
    );
  }

  //Continue or Get started button
  Widget _builContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _nextStep,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.red,
          foregroundColor: AppColors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(14),
          ),
        ),
        child: Text(
          _currentStep == 2 ? 'Get Started' : 'Continue',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
