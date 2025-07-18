import 'package:craftworks_app/core/constants/app_theme.dart';
import 'package:craftworks_app/l10n/app_localizations.dart';
import 'package:craftworks_app/providers/language_provider.dart';
import 'package:craftworks_app/providers/theme_provider.dart';
import 'package:craftworks_app/services/auth/auth_service.dart';
import 'package:craftworks_app/services/preferences_services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;
  late TextEditingController countryController;
  String? registerAs;

  bool isSeen = false;
  bool agreeToTerms = false;
  bool _isLoading = false;
  String? _nameError;
  String? _phoneError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _registerAsError;

  void submitForm() async {
  if (!agreeToTerms) {
    showTermsDialog();
    return;
  }

  setState(() {
    _nameError = _validateName(nameController.text);
    _phoneError = _validatePhone(phoneController.text);
    _emailError = _validateEmail(emailController.text);
    _passwordError = _validatePassword(passwordController.text);
    _confirmPasswordError = _validateConfirmPassword(
      confirmPasswordController.text,
    );
    _registerAsError = registerAs == null ? 'Please select a role' : null;
  });

  if (_nameError == null &&
      _phoneError == null &&
      _emailError == null &&
      _passwordError == null &&
      _confirmPasswordError == null &&
      _registerAsError == null) {
    setState(() => _isLoading = true);

    try {

      final englishRole = registerAs == AppLocalizations.of(context)!.craftsman
          ? 'craftsman'
          : 'client';

      final res = await AuthService().register(
        fullName: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        password: passwordController.text,
        role: englishRole,
      );

      if (res['success']) {
        Navigator.pushReplacementNamed(context, '/craftsman_start');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'] ?? 'Registration failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration error: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty || value.trim().length < 6) {
      return AppLocalizations.of(context)!.nameValidation;
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.phoneRequired;
    }
    final phoneRegExp = RegExp(r'^01[0-2,5]{1}[0-9]{8}$');
    if (!phoneRegExp.hasMatch(value.trim())) {
      return AppLocalizations.of(context)!.phoneValidation;
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.emailRequired;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return AppLocalizations.of(context)!.emailValidation;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.passwordRequired;
    }
    if (!value.contains(
      RegExp(
        r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[#$@!%*?&])[A-Za-z\d#$@!%*?&]{6,}$',
      ),
    )) {
      return AppLocalizations.of(context)!.passwordValidation;
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.confirmPasswordRequired;
    }
    if (value != passwordController.text) {
      return AppLocalizations.of(context)!.passwordMismatch;
    }
    return null;
  }

  void showTermsDialog() {
    final isDark = Provider.of<ThemeProvider>(
      context,
      listen: false,
    ).isDarkMode;

    final localizations = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: isDark ? AppColors.popover : AppColors.popoverLight,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [AppColors.primary800, AppColors.primary]
                  : [AppColors.primary100Light, AppColors.primaryLight],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error, color: AppColors.destructive, size: 30),
              const SizedBox(height: 16),
              Text(
                localizations.termsAlertMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  localizations.continueText,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    phoneController = TextEditingController();
    countryController = TextEditingController();
    super.initState();
  }

  bool _didSetInitialValues = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_didSetInitialValues) {
      final localizations = AppLocalizations.of(context)!;
      countryController.text = localizations.egypt;
      registerAs ??= localizations.client;
      _didSetInitialValues = true;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProv = Provider.of<ThemeProvider>(context);
    final langProv = Provider.of<LanguageProvider>(context);
    final isDark = themeProv.isDarkMode;
    final localizations = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Directionality(
      textDirection: langProv.currentLanguage == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
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
                    color: Colors.blue.withOpacity(.01),
                    boxShadow: [AppColors.glowBlue],
                  ),
                ),
              ),
            ],

            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.3),
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
                          localizations.signup,
                          style: textTheme.headlineSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          localizations.welcome,
                          style: textTheme.bodyMedium?.copyWith(
                            color: isDark
                                ? AppColors.mutedForeground
                                : AppColors.mutedForegroundLight,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        _CustomTextField(
                          controller: nameController,
                          hintText: localizations.name,
                          prefixIcon: Icons.person_outline,
                          errorText: _nameError,
                          isDark: isDark,
                          onChanged: (value) {
                            if (_nameError != null) {
                              setState(() => _nameError = _validateName(value));
                            }
                          },
                        ),
                        const SizedBox(height: 16),

                        _CustomTextField(
                          controller: phoneController,
                          hintText: localizations.phone,
                          prefixIcon: Icons.phone_outlined,
                          errorText: _phoneError,
                          isDark: isDark,
                          onChanged: (value) {
                            if (_phoneError != null) {
                              setState(
                                () => _phoneError = _validatePhone(value),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 16),

                        DropdownButtonFormField<String>(
                          value: countryController.text,
                          decoration: InputDecoration(
                            labelText: localizations.country,
                            labelStyle: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            prefixIcon: Icon(
                              Icons.flag,
                              color: isDark ? Colors.white70 : Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: isDark
                                    ? AppColors.muted
                                    : AppColors.mutedLight,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.primary,
                                width: 2,
                              ),
                            ),
                            filled: true,
                            fillColor: isDark
                                ? AppColors.card
                                : AppColors.cardLight,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                          ),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.primary,
                          ),
                          dropdownColor: isDark
                              ? AppColors.card
                              : AppColors.cardLight,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                          items: [localizations.egypt].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) =>
                              setState(() => countryController.text = value!),
                        ),
                        const SizedBox(height: 16),

                        DropdownButtonFormField<String>(
                          value: registerAs,
                          decoration: InputDecoration(
                            labelText: localizations.registerAs,
                            labelStyle: TextStyle(
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            prefixIcon: Icon(
                              Icons.person,
                              color: isDark ? Colors.white70 : Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: _registerAsError != null
                                    ? AppColors.destructive
                                    : isDark
                                    ? AppColors.muted
                                    : AppColors.mutedLight,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: _registerAsError != null
                                    ? AppColors.destructive
                                    : AppColors.primary,
                                width: 2,
                              ),
                            ),
                            errorText: _registerAsError,
                            filled: true,
                            fillColor: isDark
                                ? AppColors.card
                                : AppColors.cardLight,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 16,
                            ),
                          ),
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: AppColors.primary,
                          ),
                          dropdownColor: isDark
                              ? AppColors.card
                              : AppColors.cardLight,
                          style: TextStyle(
                            color: isDark ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                          items: [localizations.client, localizations.craftsman]
                              .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              })
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              registerAs = value;
                              _registerAsError = null;
                            });
                          },
                        ),
                        const SizedBox(height: 16),

                        _CustomTextField(
                          controller: emailController,
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
                          controller: passwordController,
                          hintText: localizations.password,
                          prefixIcon: Icons.lock_outline,
                          obscureText: !isSeen,
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
                              isSeen ? Icons.visibility : Icons.visibility_off,
                              color: isDark ? Colors.white70 : Colors.grey,
                            ),
                            onPressed: () => setState(() => isSeen = !isSeen),
                          ),
                        ),
                        const SizedBox(height: 16),

                        _CustomTextField(
                          controller: confirmPasswordController,
                          hintText: localizations.confirm_password,
                          prefixIcon: Icons.lock_outline,
                          obscureText: !isSeen,
                          errorText: _confirmPasswordError,
                          isDark: isDark,
                          onChanged: (value) {
                            if (_confirmPasswordError != null) {
                              setState(
                                () => _confirmPasswordError =
                                    _validateConfirmPassword(value),
                              );
                            }
                          },
                          suffixIcon: IconButton(
                            icon: Icon(
                              isSeen ? Icons.visibility : Icons.visibility_off,
                              color: isDark ? Colors.white70 : Colors.grey,
                            ),
                            onPressed: () => setState(() => isSeen = !isSeen),
                          ),
                        ),
                        const SizedBox(height: 8),

                        Row(
                          children: [
                            Checkbox(
                              value: agreeToTerms,
                              onChanged: (val) =>
                                  setState(() => agreeToTerms = val!),
                              activeColor: AppColors.primary,
                              checkColor: AppColors.primaryForeground,
                            ),
                            Flexible(
                              child: RichText(
                                text: TextSpan(
                                  style: textTheme.bodyMedium?.copyWith(
                                    color: isDark ? Colors.white : Colors.black,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: '${localizations.iAgreeTo} ',
                                    ),
                                    TextSpan(
                                      text: localizations.termsAndConditions,
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: AppColors.primary,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: Text(
                                              localizations.termsAndConditions,
                                            ),
                                            content: Text(
                                              localizations.termsContent,
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text(
                                                  localizations.close,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ),
                                    TextSpan(text: ' ${localizations.and} '),
                                    TextSpan(
                                      text: localizations.privacyPolicy,
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: AppColors.primary,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: Text(
                                              localizations.privacyPolicy,
                                            ),
                                            content: Text(
                                              localizations.privacyContent,
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text(
                                                  localizations.close,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ),
                                  ],
                                ),
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
                          onPressed: submitForm,
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
                                  localizations.signup,
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

                        Text.rich(
                          TextSpan(
                            text: '${localizations.alreadyHaveAccount} ',
                            style: textTheme.bodyMedium?.copyWith(
                              color: isDark
                                  ? Colors.white70
                                  : Colors.grey.shade600,
                            ),
                            children: [
                              TextSpan(
                                text: localizations.login,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () =>
                                      Navigator.pushReplacementNamed(
                                        context,
                                        '/login',
                                      ),
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
