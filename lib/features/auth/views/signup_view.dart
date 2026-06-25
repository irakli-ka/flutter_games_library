import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../utils/auth_validation_mixin.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> with AuthValidationMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? get _emailError {
    final text = _emailController.text;
    if (text.isEmpty) return null;
    return isEmailValid(text) ? null : 'Enter a valid email address';
  }

  String? get _usernameError {
    final text = _usernameController.text;
    if (text.isEmpty) return null;
    return isUsernameValid(text) ? null : '3+ alphanumeric characters required';
  }

  String? get _passwordError {
    final text = _passwordController.text;
    if (text.isEmpty) return null;
    return isPasswordValid(text) ? null : 'Password must be at least 6 characters';
  }

  bool get _isFormValid =>
      _emailError == null &&
          _usernameError == null &&
          _passwordError == null &&
          _emailController.text.isNotEmpty &&
          _usernameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.myBackground,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              _buildTextField(
                controller: _emailController,
                hintText: 'Email',
                icon: Icons.email_outlined,
                errorText: _emailError,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _usernameController,
                hintText: 'Username',
                icon: Icons.person_outline,
                errorText: _usernameError,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _passwordController,
                hintText: 'Password',
                icon: Icons.lock_outline,
                isPassword: true,
                errorText: _passwordError,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: (_isFormValid && !authProvider.isLoading)
                      ? () async {
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
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                      side: BorderSide(
                        color: _isFormValid ? Colors.white38 : Colors.white10,
                      ),
                    ),
                    backgroundColor: Colors.transparent,
                    disabledBackgroundColor: Colors.white.withValues(alpha: 0.05),
                  ),
                  child: authProvider.isLoading
                      ? const CircularProgressIndicator()
                      : Text(
                    'Sign Up',
                    style: TextStyle(
                      color: _isFormValid ? Colors.white : Colors.white24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text("Log In", style: TextStyle(fontWeight: FontWeight.bold)),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    String? errorText,
    required ValueChanged<String> onChanged,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      obscureText: isPassword && _isObscured,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white24),
        errorText: errorText,
        errorStyle: const TextStyle(color: Colors.redAccent),
        prefixIcon: Icon(icon, color: AppColors.iconColor),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _isObscured = !_isObscured),
        )
            : null,
        filled: true,
        fillColor: AppColors.myDarkerBackground.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white24),
        ),
      ),
    );
  }
}