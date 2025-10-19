import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_validator/form_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_buddy/global/app_routes.dart';
import 'package:job_buddy/global/widgets/error_dialog.dart';
import 'package:job_buddy/services/auth_service.dart';
import 'package:job_buddy/widgets/custom_textfieldform.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final authService = AuthService();

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;

  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController()..addListener(_validateForm);
    _passwordController = TextEditingController()..addListener(_validateForm);
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  void _validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    setState(() => _isValid = isValid);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
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
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Welcome 👋',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Please log in to continue',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),

                // Email Field
                CustomTextField(
                  controller: _emailController,
                  label: 'Email',
                  validator: ValidationBuilder()
                      .required('Email is required')
                      .email('Please enter a valid email address')
                      .build(),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  focusNode: _emailFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                ),

                const SizedBox(height: 16),

                // Password Field
                CustomTextField(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: true,
                  validator: ValidationBuilder()
                      .required('Password is required')
                      .build(),
                  textInputAction: TextInputAction.done,
                  focusNode: _passwordFocusNode,
                ),

                const SizedBox(height: 24),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isValid ? () => _login(context) : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.blueAccent,
                      disabledBackgroundColor: Colors.grey[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Forgot Password
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoute.forgotPassword.path,
                    );
                  },
                  style: TextButton.styleFrom(alignment: Alignment.centerRight),
                  child: const Text('Forgot your Password?'),
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

                // Sign up prompt
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoute.signup.path,
                        );
                      },
                      child: const Text('Sign Up'),
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

  Future<void> _login(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final user = await authService.signIn(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!context.mounted) return;

      if (user == null) {
        await AppDialog.show(
          context,
          message: 'User not found or credentials invalid.',
          type: DialogType.error,
        );
        return;
      }

      if (!user.emailVerified) {
        await AppDialog.show(
          context,
          message: 'Please verify your email before logging in.',
          type: DialogType.info,
        );
        if (!context.mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoute.emailVerification.path,
          (route) => false,
        );
      } else {
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
        message: e.toString(),
        type: DialogType.error,
      );
    }
  }

  Future<void> _loginWithGoogle(BuildContext context) async {
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
  }
}
