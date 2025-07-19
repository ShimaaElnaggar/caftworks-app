import 'package:flutter/material.dart';
import '../core/constants/app_theme.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../l10n/app_localizations.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  int _selectedMethod = 1; 
  bool _showOtpScreen = false;
  String _otp = '';
  int _timer = 60;

  void _goToOtpScreen() {
    setState(() {
      _showOtpScreen = true;
      _timer = 60;
      _otp = '';
    });
    _startTimer();
  }

  void _startTimer() {
    Future.doWhile(() async {
      if (_timer > 0 && _showOtpScreen) {
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          setState(() {
            _timer--;
          });
        }
        return true;
      }
      return false;
    });
  }

  void _submitForgotPassword(String email) async {
    final url = Uri.parse('http://192.168.1.2:5000/api/auth/forgot-password');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email.trim()}),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.password_reset_email_sent), backgroundColor: AppColors.primary),
        );
      
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? AppLocalizations.of(context)!.failed_to_send_reset_email), backgroundColor: AppColors.destructive),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.network_error + e.toString()), backgroundColor: AppColors.destructive),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onBackground),
          onPressed: () {
            if (_showOtpScreen) {
              setState(() {
                _showOtpScreen = false;
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body:
       _showOtpScreen ? _OtpScreen(
        email: 'khad****@gmail.com',
        timer: _timer,
        onResend: () {
          setState(() {
            _timer = 60;
          });
          _startTimer();
        },
        onOtpChanged: (value) {
          setState(() {
            _otp = value;
          });
        },
        onVerify: () {},
      ) : _ContactSelectionScreen(
        selectedMethod: _selectedMethod,
        onSelect: (method) {
          setState(() {
            _selectedMethod = method;
          });
        },
        onNext: _goToOtpScreen,
      ),
    );
  }
}

class _ContactSelectionScreen extends StatelessWidget {
  final int selectedMethod;
  final ValueChanged<int> onSelect;
  final VoidCallback onNext;

  const _ContactSelectionScreen({
    Key? key,
    required this.selectedMethod,
    required this.onSelect,
    required this.onNext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Stack(
      children:[ 
        Positioned(
          top: -100,
          left: -100,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.primary.withOpacity(.01),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.primary.withOpacity(.3),
                  blurRadius: 100,
                  spreadRadius: 100,
                )
              ]
            ),
          ),),
        Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            Center(
              child: Image.asset(
                'assets/images/forget.png',
                height: 140,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.lock, size: 100, color: colorScheme.primary),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.select_contact_details_to_reset_password,
              style: TextStyle(fontSize: 16, color: colorScheme.onBackground),
            ),
            const SizedBox(height: 24),
            _ContactOption(
              icon: Icons.sms,
              label: AppLocalizations.of(context)!.via_sms,
              value: 1,
              selected: selectedMethod == 1,
              detail: '+21365*****52',
              onTap: () => onSelect(1),
            ),
            const SizedBox(height: 16),
            _ContactOption(
              icon: Icons.email,
              label: AppLocalizations.of(context)!.via_email,
              value: 2,
              selected: selectedMethod == 2,
              detail: 'khad****@gmail.com',
              onTap: () => onSelect(2),
            ),
            SizedBox(height: 20,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: onNext,
                child: Text(AppLocalizations.of(context)!.next, style: TextStyle(fontSize: 18, color: colorScheme.onPrimary)),
              ),
            ),
            const SizedBox(height: 16),
          ],
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
            color: colorScheme.primary.withOpacity(.01),
            boxShadow: [
              BoxShadow(color: colorScheme.primary.withOpacity(.6),
                blurRadius: 150,
                spreadRadius: 100,
              )
            ]
          ),
        )
      ),
    ]);
  }
}

class _ContactOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String detail;
  final int value;
  final bool selected;
  final VoidCallback onTap;

  const _ContactOption({
    Key? key,
    required this.icon,
    required this.label,
    required this.detail,
    required this.value,
    required this.selected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? colorScheme.secondary : colorScheme.surface,
          border: Border.all(
            color: selected ? colorScheme.primary : colorScheme.outline,
            width: selected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? colorScheme.primary : colorScheme.onSurface),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                  Text(detail, style: TextStyle(color: colorScheme.onSurface.withOpacity(0.7))),
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_circle, color: colorScheme.primary)
            else
              Icon(Icons.arrow_forward_ios, size: 16, color: colorScheme.onSurface),
          ],
        ),
      ),
    );
  }
}

class _OtpScreen extends StatelessWidget {
  final String email;
  final int timer;
  final VoidCallback onResend;
  final ValueChanged<String> onOtpChanged;
  final VoidCallback onVerify;

  const _OtpScreen({
    Key? key,
    required this.email,
    required this.timer,
    required this.onResend,
    required this.onOtpChanged,
    required this.onVerify,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.otp_code_verification,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colorScheme.onBackground),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.code_sent_to + email,
            style: TextStyle(fontSize: 16, color: colorScheme.onBackground),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          _OtpInputField(
            length: 4,
            onChanged: onOtpChanged,
          ),
          const SizedBox(height: 16),
          timer > 0
              ? Text(AppLocalizations.of(context)!.resend_code_in + timer.toString() + 's', style: TextStyle(color: colorScheme.onBackground.withOpacity(0.7)))
              : TextButton(
                  onPressed: onResend,
                  child: Text(AppLocalizations.of(context)!.resend_code, style: TextStyle(color: colorScheme.primary)),
                ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: onVerify,
              child: Text(AppLocalizations.of(context)!.verify, style: TextStyle(fontSize: 18, color: colorScheme.onPrimary)),
            ),
          ),
        ],
      ),
    );
  }
}

class _OtpInputField extends StatefulWidget {
  final int length;
  final ValueChanged<String> onChanged;

  const _OtpInputField({Key? key, required this.length, required this.onChanged}) : super(key: key);

  @override
  State<_OtpInputField> createState() => _OtpInputFieldState();
}

class _OtpInputFieldState extends State<_OtpInputField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged() {
    String code = _controllers.map((c) => c.text).join();
    widget.onChanged(code);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.length, (i) {
        return Container(
          width: 48,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          child: TextField(
            controller: _controllers[i],
            focusNode: _focusNodes[i],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colorScheme.onBackground),
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: colorScheme.outline),
              ),
              filled: true,
              fillColor: colorScheme.surface,
              contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              errorText: null,
              errorStyle: TextStyle(
                color: colorScheme.error,
                fontSize: 12,
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && i < widget.length - 1) {
                _focusNodes[i + 1].requestFocus();
              }
              if (value.isEmpty && i > 0) {
                _focusNodes[i - 1].requestFocus();
              }
              _onChanged();
            },
          ),
        );
      }),
    );
  }
}
