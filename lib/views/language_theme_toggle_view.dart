import 'package:craftworks_app/core/constants/app_theme.dart';
import 'package:craftworks_app/l10n/app_localizations.dart';
import 'package:craftworks_app/providers/language_provider.dart';
import 'package:craftworks_app/providers/theme_provider.dart';
import 'package:craftworks_app/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageThemeToggleView extends StatefulWidget {
  const LanguageThemeToggleView({super.key});

  @override
  State<LanguageThemeToggleView> createState() =>
      _LanguageThemeToggleViewState();
}

class _LanguageThemeToggleViewState extends State<LanguageThemeToggleView> {
  bool? _isDarkMode;

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

  @override
  Widget build(BuildContext context) {
    final themeProv = Provider.of<ThemeProvider>(context);
    final langProv = Provider.of<LanguageProvider>(context);
    final isDark = _isDarkMode ?? false;

    return Scaffold(
      backgroundColor: isDark ? AppColors.background : AppColors.foreground,
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
          Positioned(
            bottom: -100,
            right: -100,
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
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        isDark ? Icons.dark_mode : Icons.light_mode,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      const SizedBox(width: 8),
                      Switch.adaptive(
                        value: isDark,
                        activeColor: AppColors.primary,
                        onChanged: (val) {
                          themeProv.toggleTheme(val);
                          setState(() {
                            _isDarkMode = val;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.home_repair_service,
                        size: 100,
                        color: isDark ? Colors.white : AppColors.primary,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        AppLocalizations.of(context)!.appTitle,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomElevatedButton(
                        onPressed: () async {
                          await langProv.setLanguage('ar');
                        },
                        backgroundColor: isDark
                            ? Colors.white10
                            : AppColors.primary,
                        color: isDark ? Colors.white : Colors.white,
                        text: AppLocalizations.of(context)!.arabic,
                      ),
                      CustomElevatedButton(
                        onPressed: () async {
                          await langProv.setLanguage('en');
                        },
                        backgroundColor: isDark
                            ? Colors.white10
                            : AppColors.primary,
                        color: isDark ? Colors.white : Colors.white,
                        text: AppLocalizations.of(context)!.english,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
