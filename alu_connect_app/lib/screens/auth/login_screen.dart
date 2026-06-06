import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import 'registration_screen.dart';
import '../home_screen.dart';
import '../../data/app_data.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _passwordVisible = false;
  String _errorMessage = '';

  void _handleLogin() {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    //To check if fields are empty
    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all the required fields.');
      return;
    }

    //Check if email exists
    if (!registeredUsers.containsKey(email)) {
      setState(() => _errorMessage = 'No account found. Please register!');
      return;
    }

    //Check if password is true
    if (registeredUsers[email] != password) {
      setState(() => _errorMessage = 'Incorrect password. Please try again!');
      return;
    }

    //Correct credentials
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          //Navy blue header
          _buildHeader(),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 28,
                vertical: 32,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Email field
                  _buildLabel('Email Address'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _emailController,
                    hint: 'email@alustudent.com',
                    icon: Icons.person_outline_rounded,
                  ),

                  const SizedBox(height: 18),

                  //Password field
                  _buildLabel('Password'),
                  const SizedBox(height: 8),
                  _buildPasswordField(),

                  const SizedBox(height: 8),

                  //Forgot password
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  //Error box
                  if(_errorMessage.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.errorBox,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          color: AppColors.red,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage,
                            style: const TextStyle(
                              color: AppColors.red,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Sign in bttn
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(14),
                        ),
                      ), 
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  //To registration page
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegistrationScreen(),
                        ),
                      ),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.gray,
                          ),
                          children: [
                            TextSpan(text: "Don't have an account? "),
                            TextSpan(
                              text: 'Create an account',
                              style: TextStyle(
                                color: AppColors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Navy blue header
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      color: AppColors.navyBlue,
      padding: const EdgeInsets.only(
        top: 60,
        left: 28,
        right: 28,
        bottom: 28,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.15),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(width: 6),
                const Text(
                  'ALU Rwanda - Kigali',
                  style: TextStyle(
                    color: Colors.white60,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 14),

          //Tittle
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
              children: [
                TextSpan(
                  text: 'Welcome to\n',
                  style: TextStyle(color: AppColors.white),
                ),
                TextSpan(
                  text: 'ALU',
                  style: TextStyle(color: AppColors.offWhite),
                ),
                TextSpan(
                  text: 'Connect',
                  style: TextStyle(color: AppColors.red),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget _buildLabel(String text){
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: AppColors.gray,
        letterSpacing: 1.5,
      ),
    );
  }

  //Text field
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppColors.gray,
          fontSize: 16,
          fontWeight: FontWeight.w400
        ),
        prefixIcon: Icon(icon, color: AppColors.gray, size: 20),
        filled: true,
        fillColor: AppColors.offWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightGray)
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightGray)
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.red,
            width: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextField(
      controller: _passwordController,
      obscureText: !_passwordVisible,
      decoration: InputDecoration(
        hintText: 'Enter your password',
        hintStyle: const TextStyle(
          color: AppColors.gray,
          fontSize: 16,
          fontWeight: FontWeight.w400
        ),
        prefixIcon: const Icon(
          Icons.lock_outline_rounded,
          color: AppColors.gray,
          size: 20,
        ),
        suffixIcon: GestureDetector(
          onTap: () => setState(
            () => _passwordVisible = !_passwordVisible,
          ),
          child: Icon(
            _passwordVisible
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
            color: AppColors.gray,
            size: 20,
          ),
        ),
        filled: true,
        fillColor: AppColors.offWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightGray)
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightGray)
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.red,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
