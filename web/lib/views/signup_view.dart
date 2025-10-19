import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_validator/form_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_buddy/global/app_routes.dart';
import 'package:job_buddy/global/widgets/error_dialog.dart';
import 'package:job_buddy/services/auth_service.dart';
import 'package:job_buddy/widgets/custom_textfieldform.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();
  final authService = AuthService();

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  bool _isValid = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController()..addListener(_validateForm);
    _emailController = TextEditingController()..addListener(_validateForm);
    _passwordController = TextEditingController()..addListener(_validateForm);
    _confirmPasswordController = TextEditingController()
      ..addListener(_validateForm);
  }

  void _validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    setState(() => _isValid = isValid);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width > 600;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Container(
          width: isWide ? 400 : width * 0.9,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Form(
            key: _formKey,
            onChanged: _validateForm,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Create Account',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Join us and start your journey 🚀',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),

                // Full Name
                CustomTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  validator: ValidationBuilder()
                      .required('Please enter your full name')
                      .minLength(6, 'Name must be at least 6 characters long')
                      .maxLength(50, 'Name cannot exceed 50 characters')
                      .regExp(
                        RegExp(r'^[\p{L}. ]+$', unicode: true),
                        'Name can only contain letters, spaces, and periods.',
                      )
                      .build(),
                ),
                const SizedBox(height: 16),

                // Email
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  validator: ValidationBuilder()
                      .required('Email is required')
                      .email('Enter a valid email')
                      .build(),
                ),
                const SizedBox(height: 16),

                // Password
                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: true,
                  validator: ValidationBuilder()
                      .required('Password is required')
                      .regExp(
                        RegExp(
                          r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#\$%^&*()_\-+=<>?{}[\]~]).{8,}$',
                        ),
                        'Password must include upper, lower, number & special character',
                      )
                      .build(),

                  onChanged: (_) => Future.delayed(
                    const Duration(milliseconds: 300),
                    _validateForm,
                  ),
                ),
                const SizedBox(height: 16),

                // Confirm Password
                CustomTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirm Password',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  ),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isValid ? () => _signUp(context) : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.blueAccent,
                      disabledBackgroundColor: Colors.grey[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey[300])),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'OR',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey[300])),
                  ],
                ),
                const SizedBox(height: 16),

                // Google Sign-in
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _loginWithGoogle(context),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFFFFF),
                      side: const BorderSide(
                        color: Color(0xFF747775),
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      foregroundColor: const Color(0xFF1F1F1F),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/Google Icon/light/web_light_rd_na.svg',
                          height: 24,
                          width: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Sign in with Google',
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            height: 20 / 14,
                            color: const Color(0xFF1F1F1F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoute.login.path,
                          (route) => false,
                        );
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signUp(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final user = await authService.signUp(email, password);

      if (user == null) return;

      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoute.emailVerification.path,
        (route) => false,
      );

      await authService.sendEmailVerification();
    } catch (e) {
      if (!context.mounted) return;
      await AppDialog.show(
        context,
        message: 'Sign up failed: $e',
        type: DialogType.error,
      );
    }
  }

  Future<void> _loginWithGoogle(BuildContext context) async {
    try {
      final user = await authService.signInWithGoogle();
      if (!context.mounted) return;

      if (user != null) {
        await AppDialog.show(
          context,
          message: 'Logged in successfully with Google!',
          type: DialogType.success,
        );
        if (!context.mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoute.home.path,
          (route) => false,
        );
      }
    } catch (e) {
      if (!context.mounted) return;
      await AppDialog.show(
        context,
        message: 'Google sign-in failed: $e',
        type: DialogType.error,
      );
    }
  }
}
