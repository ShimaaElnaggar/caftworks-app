import 'package:craftworks_app/core/constants/app_theme.dart';
import 'package:craftworks_app/l10n/app_localizations.dart';
import 'package:craftworks_app/providers/language_provider.dart';
import 'package:craftworks_app/providers/theme_provider.dart';
import 'package:craftworks_app/services/auth/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;
  String? _emailError;
  String? _passwordError;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.emailRequired;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return AppLocalizations.of(context)!.emailValidation;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context)!.passwordRequired;
    }
    if (value.length < 6) {
      return AppLocalizations.of(context)!.passwordValidation;
    }
    return null;
  }

  Future<void> _handleSubmit() async {
    final emailError = _validateEmail(_emailController.text);
    final passwordError = _validatePassword(_passwordController.text);

    setState(() {
      _emailError = emailError;
      _passwordError = passwordError;
    });

    if (emailError == null && passwordError == null) {
      setState(() => _isLoading = true);
      await _performLogin();
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _performLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final res = await AuthService().login(email: email, password: password);

    if (res['success'] && mounted) {
      final user = res['user'];
      final role = user['role'];

      Navigator.pushReplacementNamed(
        context,
        role == 'craftsman' ? '/craftsman_start' : '/client-home',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.loginSuccess),
          backgroundColor: AppColors.success,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            res['message'] ?? AppLocalizations.of(context)!.loginFailed,
          ),
          backgroundColor: AppColors.destructive,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final langProvider = Provider.of<LanguageProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final localizations = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Directionality(
      textDirection: langProvider.textDirection,
      child: Scaffold(
        
        backgroundColor: isDark ? AppColors.background : AppColors.foreground,
        body: Stack(
          children: [
            if (!isDark) ...[
              Positioned(
                top: -100,
                left: -100,
                child: Container(
                  width: 200,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.withOpacity(.01),
                    boxShadow: [AppColors.glowBlue],
                  ),
                ),
              ),
              Positioned(
                bottom: -100,
                right: -100,
                child: Container(
                  width: 200,
                  height: 500,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(.01),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(.3),
                        blurRadius: 150,
                        spreadRadius: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ],

            if (_isLoading)
              Container(
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),

            IgnorePointer(
              ignoring: _isLoading,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 32,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 16),
                        Text(
                          localizations.login,
                          style: textTheme.headlineSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          localizations.welcomeBack,
                          style: textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? AppColors.mutedForeground
                                : AppColors.mutedForegroundLight,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        _CustomTextField(
                          controller: _emailController,
                          hintText: localizations.email,
                          prefixIcon: Icons.email_outlined,
                          errorText: _emailError,
                          isDark: isDark,
                          onChanged: (value) {
                            if (_emailError != null) {
                              setState(
                                () => _emailError = _validateEmail(value),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 16),

                        _CustomTextField(
                          controller: _passwordController,
                          hintText: localizations.password,
                          prefixIcon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          errorText: _passwordError,
                          isDark: isDark,
                          onChanged: (value) {
                            if (_passwordError != null) {
                              setState(
                                () => _passwordError = _validatePassword(value),
                              );
                            }
                          },
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: isDark ? Colors.white70 : Colors.grey,
                            ),
                            onPressed: () {
                              setState(
                                () => _obscurePassword = !_obscurePassword,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: _rememberMe,
                                  onChanged: (value) {
                                    setState(
                                      () => _rememberMe = value ?? false,
                                    );
                                  },
                                  activeColor: AppColors.primary,
                                  checkColor: AppColors.primaryForeground,
                                ),
                                Text(localizations.rememberMe),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/forgetpass');
                              },
                              child: Text(
                                localizations.forgotPassword,
                                style: TextStyle(color: AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),


                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 2,
                          ),
                          onPressed: _handleSubmit,
                          child: _isLoading
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.primaryForeground,
                                  ),
                                )
                              : Text(
                                  localizations.login,
                                  style: textTheme.titleMedium?.copyWith(
                                    color: AppColors.primaryForeground,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 24),

                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: isDark
                                    ? Colors.white24
                                    : Colors.grey.shade300,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Text(
                                localizations.continueWith,
                                style: textTheme.bodySmall?.copyWith(
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: isDark
                                    ? Colors.white24
                                    : Colors.grey.shade300,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Social Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _SocialButton(
                              icon: Icons.g_mobiledata,
                              onTap: () {},
                              isDark: isDark,
                            ),
                            const SizedBox(width: 16),
                            _SocialButton(
                              icon: Icons.facebook,
                              onTap: () {},
                              isDark: isDark,
                            ),
                            const SizedBox(width: 16),
                            _SocialButton(
                              icon: Icons.apple,
                              onTap: () {},
                              isDark: isDark,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Sign Up Prompt
                        Text.rich(
                          TextSpan(
                            text: '${localizations.noAccount} ',
                            style: textTheme.bodyMedium?.copyWith(
                              color: isDark
                                  ? Colors.white70
                                  : Colors.grey.shade600,
                            ),
                            children: [
                              TextSpan(
                                text: localizations.signup,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () =>
                                      Navigator.pushNamed(context, '/signup'),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? errorText;
  final bool isDark;
  final Function(String)? onChanged;

  const _CustomTextField({
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.errorText,
    required this.isDark,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          color: isDark ? Colors.white54 : Colors.grey.shade500,
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: isDark ? Colors.white70 : Colors.grey)
            : null,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: errorText != null
                ? AppColors.destructive
                : isDark
                ? AppColors.muted
                : AppColors.mutedLight,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: errorText != null
                ? AppColors.destructive
                : AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.destructive),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.destructive, width: 2),
        ),
        filled: true,
        fillColor: isDark ? AppColors.card : AppColors.cardLight,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        errorText: errorText,
        errorStyle: TextStyle(color: AppColors.destructive, fontSize: 12),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;

  const _SocialButton({
    required this.icon,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? Colors.white24 : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isDark ? Colors.white : Colors.black,
          size: 28,
        ),
      ),
    );
  }
}
