import 'package:craftworks_app/services/auth/auth_service.dart';
import 'package:craftworks_app/services/preferences_services.dart';
import 'package:flutter/material.dart';
import '../core/constants/app_theme.dart';

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
      print("Form valid - proceed");

      final res = await AuthService().register(
        fullName: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        password: passwordController.text,
        role: registerAs!,
      );

      if (res['success']) {
        final userJson = await PreferencesServices.getString('user');
        print("User from SharedPreferences (in submitForm): $userJson");
        // Navigator.pushReplacementNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(res['message'] ?? 'Registration failed')),
        );
      }
    }
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty || value.trim().length < 6) {
      return 'Name Field is Required at least 6 characters';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone Field is Required';
    }
    final phoneRegExp = RegExp(r'^01[0-2,5]{1}[0-9]{8}$');
    if (!phoneRegExp.hasMatch(value.trim())) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email Field is Required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null ||
        value.trim().isEmpty ||
        !value.contains(
          RegExp(
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[#$@!%*?&])[A-Za-z\d#$@!%*?&]{6,}$',
          ),
        )) {
      return 'Password Field is Required at least 6 characters, should contain Capital Letters, Small Letters, Number and symbols like #%';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Confirm Password is required";
    }
    if (value != passwordController.text) {
      return "Passwords do not match";
    }
    return null;
  }

  void showTermsDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: AppColors.popover,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6AAED9), Color.fromRGBO(209, 231, 245, 1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error,
                color: Color.fromARGB(255, 187, 21, 21),
                size: 30,
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  "You must agree to \n our terms and \n conditions.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8EC6E6),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Continue",
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
    countryController = TextEditingController(text: 'Egypt');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    countryController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            "Herfa",
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              fontSize: 50,
              shadows: [
                Shadow(
                  offset: Offset(3, 3),
                  blurRadius: .8,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ),

        backgroundColor: AppColors.foreground,
        elevation: 0,
      ),
      backgroundColor: AppColors.foreground,
      body: Stack(
        children: [
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 200,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(.01),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(.3),
                    blurRadius: 100,
                    spreadRadius: 100,
                  ),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 100,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Pleasure to meet you !',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.mutedForeground,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    _CustomTextField(
                      controller: nameController,
                      hintText: 'Name',
                      prefixIcon: Icons.person_outline,
                      errorText: _nameError,
                      onChanged: (value) {
                        if (_nameError != null) {
                          setState(() {
                            _nameError = _validateName(value);
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    _CustomTextField(
                      controller: phoneController,
                      hintText: 'Phone',
                      prefixIcon: Icons.phone_outlined,
                      errorText: _phoneError,
                      onChanged: (value) {
                        if (_phoneError != null) {
                          setState(() {
                            _phoneError = _validatePhone(value);
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: countryController.text,
                      decoration: InputDecoration(
                        labelText: 'Country',
                        labelStyle: TextStyle(color: AppColors.background),
                        prefixIcon: Icon(Icons.flag),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.muted),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: AppColors.foreground,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                      ),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.primary,
                      ),
                      dropdownColor: AppColors.foreground,
                      style: TextStyle(
                        color: AppColors.background,
                        fontSize: 16,
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Egypt', child: Text('Egypt')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          countryController.text = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Register As dropdown
                    DropdownButtonFormField<String>(
                      value: registerAs,
                      decoration: InputDecoration(
                        labelText: 'Register As',
                        labelStyle: TextStyle(color: AppColors.background),
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _registerAsError != null
                                ? AppColors.destructive
                                : AppColors.muted,
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
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.destructive),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.destructive,
                            width: 2,
                          ),
                        ),
                        filled: true,
                        fillColor: AppColors.foreground,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 16,
                        ),
                        errorText: _registerAsError,
                      ),
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.primary,
                      ),
                      dropdownColor: AppColors.foreground,
                      style: TextStyle(
                        color: AppColors.foreground,
                        fontSize: 16,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Client',
                          child: Text('Client'),
                        ),
                        DropdownMenuItem(
                          value: 'Craftsman',
                          child: Text('Craftsman'),
                        ),
                      ],
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
                      hintText: 'Email',
                      prefixIcon: Icons.email_outlined,
                      errorText: _emailError,
                      onChanged: (value) {
                        if (_emailError != null) {
                          setState(() {
                            _emailError = _validateEmail(value);
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    _CustomTextField(
                      controller: passwordController,
                      hintText: 'Password',
                      prefixIcon: Icons.lock_outline,
                      obscureText: !isSeen,
                      errorText: _passwordError,
                      onChanged: (value) {
                        if (_passwordError != null) {
                          setState(() {
                            _passwordError = _validatePassword(value);
                          });
                        }
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          isSeen ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isSeen = !isSeen;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    _CustomTextField(
                      controller: confirmPasswordController,
                      hintText: 'Confirm Password',
                      prefixIcon: Icons.lock_outline,
                      obscureText: !isSeen,
                      errorText: _confirmPasswordError,
                      onChanged: (value) {
                        if (_confirmPasswordError != null) {
                          setState(() {
                            _confirmPasswordError = _validateConfirmPassword(
                              value,
                            );
                          });
                        }
                      },
                      suffixIcon: IconButton(
                        icon: Icon(
                          isSeen ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isSeen = !isSeen;
                          });
                        },
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
                        const Text('I agree to the '),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Terms & Conditions"),
                                content: const Text("............."),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Close"),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text(
                            'Terms & Conditions',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const Text(' and '),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Privacy Policy',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue,
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
                      ),
                      onPressed: submitForm,
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.primaryForeground,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: const [
                        Expanded(child: Divider()),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('Continue with'),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _SocialButton(
                          asset: 'assets/images/Social Button.png',
                          onTap: () {},
                        ),
                        const SizedBox(width: 16),
                        _SocialButton(
                          asset: 'assets/images/Social Buttonface.png',
                          onTap: () {},
                        ),
                        const SizedBox(width: 16),
                        _SocialButton(
                          asset: 'assets/images/Social Buttoni.png',
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account? '),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
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
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(.3),
                    blurRadius: 150,
                    spreadRadius: 100,
                  ),
                ],
              ),
            ),
          ),
        ],
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
  final Function(String)? onChanged;

  const _CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.errorText,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: errorText != null ? AppColors.destructive : AppColors.muted,
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
        fillColor: AppColors.foreground,
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
  final String asset;
  final VoidCallback onTap;

  const _SocialButton({super.key, required this.asset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.muted),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Image.asset(asset, width: 28, height: 28),
      ),
    );
  }
}
