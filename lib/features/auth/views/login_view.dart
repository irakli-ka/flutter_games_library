import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_theme.dart';
import '../providers/auth_provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isObscured = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.myBackground,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            _buildTextField(
              controller: _usernameController,
              hintText: 'Username',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _passwordController,
              hintText: 'Password',
              icon: Icons.lock_outline,
              isPassword: true,
              isObscured: _isObscured,
              onToggle: () => setState(() => _isObscured = !_isObscured),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: authProvider.isLoading ? null : () async {
                  final success = await authProvider.login(
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
                    : const Text('Log In'),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/signup'),
                  child: const Text(
                      "Sign Up", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller, required String hintText, required IconData icon, bool isPassword = false, bool isObscured = false, VoidCallback? onToggle}) {
    return TextField(
      controller: controller,
      obscureText: isPassword && isObscured,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: AppColors.iconColor),
        suffixIcon: isPassword ? IconButton(
            icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off),
            onPressed: onToggle) : null,
        filled: true,
        fillColor: AppColors.myDarkerBackground.withValues(alpha: 0.5),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
      ),
    );
  }
}