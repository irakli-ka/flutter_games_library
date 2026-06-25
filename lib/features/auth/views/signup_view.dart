import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_theme.dart';
import '../providers/auth_provider.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.myBackground,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              _buildTextField(_emailController, 'Email', Icons.email_outlined),
              const SizedBox(height: 16),
              _buildTextField(
                  _usernameController, 'Username', Icons.person_outline),
              const SizedBox(height: 16),
              _buildTextField(
                  _passwordController, 'Password', Icons.lock_outline,
                  isPassword: true),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: authProvider.isLoading ? null : () async {
                    final success = await authProvider.signUp(
                      _emailController.text.trim(),
                      _usernameController.text.trim(),
                      _passwordController.text.trim(),
                    );
                    if (success && mounted) {
                      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                    } else if (mounted && authProvider.error != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(authProvider.error!)));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                        side: const BorderSide(color: Colors.white38)),
                    backgroundColor: Colors.transparent,
                  ),
                  child: authProvider.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Sign Up'),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text("Log In",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      IconData icon, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword && _isObscured,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppColors.iconColor),
        suffixIcon: isPassword ? IconButton(
            icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => _isObscured = !_isObscured)) : null,
        filled: true,
        fillColor: AppColors.myDarkerBackground.withValues(alpha: 0.5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
    );
  }
}