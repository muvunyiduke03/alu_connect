import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../data/app_data.dart';
import '../../providers/user_provider.dart';
import '../home_screen.dart';

class RegistrationScreen extends StatefulWidget{
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  bool _passwordVisible = false;
  String _errorMessage = '';

  void _handleRegistration() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();

    //To check if all fields are filled
    if(name.isEmpty || email.isEmpty ||
      password.isEmpty || confirm.isEmpty) {
        setState(() => _errorMessage = 'Please fill in all fields.');
        return;
    }

    //Check ALU email
    if (!email.endsWith('@alustudent.com') && !email.endsWith('@alustaff')) {
      setState(() => _errorMessage = 'Please use your ALU email(@alustudent.com/@alustaff.com)');
      return;
    }

    // Check password length
    if (password.length < 8) {
      setState(() => _errorMessage = 'Password must be at least 8 characters.');
      return;
    }

    //Check if password match
    if (password != confirm) {
      setState(() => _errorMessage = 'Passwords do not match.');
      return;
    }

    //Check if email is already registered
    if (registeredUsers.containsKey(email)) {
      setState(() => _errorMessage = 'An account with this email already exists.');
      return;
    }

    // Save credentials and name
    registeredUsers[email] = password;
    registeredUserNames[email] = name;

    // Set user profile in provider
    context.read<UserProvider>().setUserFromLogin(name: name, email: email);

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.navyBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.white,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create Account',
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w700,
            fontSize: 17,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 28,
          vertical: 32,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Join the\nOur Community',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: AppColors.navyBlue,
                height: 1.2,
                letterSpacing: -0.5,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Create an account to get started.',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.gray,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 32),

            _buildLabel('Full name'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _nameController,
              hint:'Alex Scott',
              icon: Icons.badge_outlined,
            ),

            const SizedBox(height: 18),

            _buildLabel('Email'),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _emailController,
              hint: 'email@alustudent.com or @alustaff.com',
              icon: Icons.email_outlined,
            ),

            const SizedBox(height: 18),

            _buildLabel('Password'),
            const SizedBox(height: 8),
            _buildPasswordField(
              controller: _passwordController,
              hint: 'At least 8 characters',
            ),

            const SizedBox(height: 18),

            _buildLabel('Confirm Password'),
            const SizedBox(height: 8),
            _buildPasswordField(
              controller: _confirmController,
              hint: 'Re-enter your password',
            ),

            const SizedBox(height: 28),

            //error box
            if(_errorMessage.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.offWhite,
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
            //Registration button
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _handleRegistration,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppColors.gray,
          fontSize: 14
        ),
        prefixIcon: Icon(
          icon,
          color: AppColors.gray,
          size: 20
        ),
        filled: true,
        fillColor: AppColors.offWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.red,
            width: 1.5),
        ),
      ),
    );
  }

  //Password field
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      obscureText: !_passwordVisible,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppColors.gray,
          fontSize: 14
        ),
        prefixIcon: const Icon(
          Icons.lock_outline_rounded,
          color: AppColors.gray,
          size: 20,
        ),
        suffixIcon: GestureDetector(
          onTap: () => setState(() => _passwordVisible = !_passwordVisible,
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
          borderSide: const BorderSide(color: AppColors.lightGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.red,
            width: 1.5
          ),
        ),
      ),
    );
  }
}
