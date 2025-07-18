import 'package:craftworks_app/core/constants/app_theme.dart';
import 'package:craftworks_app/l10n/app_localizations.dart';
import 'package:craftworks_app/providers/language_provider.dart';
import 'package:craftworks_app/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LanguageThemeToggleView extends StatefulWidget {
  const LanguageThemeToggleView({super.key});

  @override
  State<LanguageThemeToggleView> createState() =>
      _LanguageThemeToggleViewState();
}

class _LanguageThemeToggleViewState extends State<LanguageThemeToggleView> {
  bool? _isDarkMode;
  double _scale = 1.0;
  bool _isLoading = false;
  String? _selectedLanguage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final themeProv = Provider.of<ThemeProvider>(context);
    final systemDark =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    _isDarkMode =
        themeProv.themeMode == ThemeMode.dark ||
        (themeProv.themeMode == ThemeMode.system && systemDark);
  }

  Future<void> _handleLanguageSelection(String languageCode) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _selectedLanguage = languageCode;
    });

    try {
      final langProv = Provider.of<LanguageProvider>(context, listen: false);
      await langProv.setLanguage(languageCode);

      if (mounted) {
        await Future.delayed(500.ms);
        Navigator.of(context).pushReplacementNamed('/signup');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProv = Provider.of<ThemeProvider>(context);
    final isDark = _isDarkMode ?? false;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: isDark ? AppColors.background : AppColors.foreground,
      body: Stack(
        children: [
          AnimatedContainer(
            duration: 500.ms,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [Colors.blueGrey.shade900, Colors.black]
                    : [Colors.blue.shade50, Colors.white],
              ),
            ),
          ),

          ...List.generate(5, (index) {
            return Positioned(
              left: MediaQuery.of(context).size.width * 0.2 * index,
              top: MediaQuery.of(context).size.height * 0.1 * (index % 3),
              child:
                  Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (isDark ? Colors.blueGrey : Colors.blue)
                              .withOpacity(0.1),
                        ),
                      )
                      .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: true),
                      )
                      .move(
                        duration: 3000.ms,
                        curve: Curves.easeInOut,
                        begin: Offset(0, 0),
                        end: Offset(0, 20),
                      ),
            );
          }),

          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),

          IgnorePointer(
            ignoring: _isLoading,
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white10
                                : Colors.black.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isDark
                                    ? Icons.nightlight_round
                                    : Icons.wb_sunny,
                                color: isDark ? Colors.white : Colors.black,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Switch.adaptive(
                                value: isDark,
                                activeColor: AppColors.primary,
                                inactiveThumbColor: Colors.grey.shade300,
                                onChanged: (val) {
                                  setState(() {
                                    _isDarkMode = val;
                                    _scale = 1.1;
                                  });
                                  Future.delayed(100.ms, () {
                                    setState(() => _scale = 1.0);
                                  });
                                  themeProv.toggleTheme(val);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  AnimatedScale(
                    scale: _scale,
                    duration: 200.ms,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDark
                                ? Colors.white10
                                : Colors.black.withOpacity(0.05),
                          ),
                          child: Icon(
                            Icons.translate,
                            size: 60,
                            color: isDark ? Colors.white : AppColors.primary,
                          ),
                        ).animate().fadeIn(duration: 500.ms).scale(),
                        const SizedBox(height: 32),
                        Text(
                          localizations.chooseLanguage,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.5),
                      ],
                    ),
                  ),

                  const Spacer(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        _buildLanguageButton(
                          context: context,
                          isDark: isDark,
                          languageCode: 'en',
                          languageName: localizations.english,
                          isLoading: _isLoading && _selectedLanguage == 'en',
                        ),
                        const SizedBox(height: 16),
                        _buildLanguageButton(
                          context: context,
                          isDark: isDark,
                          languageCode: 'ar',
                          languageName: localizations.arabic,
                          isLoading: _isLoading && _selectedLanguage == 'ar',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton({
    required BuildContext context,
    required bool isDark,
    required String languageCode,
    required String languageName,
    required bool isLoading,
  }) {
    return AnimatedContainer(
      duration: 300.ms,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.blue.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _handleLanguageSelection(languageCode),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.white24 : Colors.grey.shade200,
              ),
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: isDark ? Colors.white : AppColors.primary,
                      ),
                    )
                  : Text(
                      languageName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.5);
  }
}
