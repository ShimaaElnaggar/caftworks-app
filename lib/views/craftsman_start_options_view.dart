import 'package:craftworks_app/core/constants/app_theme.dart';
import 'package:craftworks_app/l10n/app_localizations.dart';
import 'package:craftworks_app/providers/theme_provider.dart';
import 'package:craftworks_app/widgets/craftsmanOptions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CraftsmanStartOptionsView extends StatefulWidget {
  const CraftsmanStartOptionsView({super.key});

  @override
  State<CraftsmanStartOptionsView> createState() =>
      _CraftsmanStartOptionsViewState();
}

class _CraftsmanStartOptionsViewState extends State<CraftsmanStartOptionsView>
    with SingleTickerProviderStateMixin {
  String selectedOption = 'add_post';

  void _handleStart() {
    if (selectedOption == 'add_post') {
      Navigator.pushNamed(context, '/post-skills');
    } else if (selectedOption == 'view_posts') {
      Navigator.pushNamed(context, '/craftsman_categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final localizations = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.howToStart,
          style: textTheme.titleLarge?.copyWith(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDark ? AppColors.background : AppColors.foreground,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      backgroundColor: isDark ? AppColors.background : AppColors.foreground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  Expanded(
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: isWide
                            ? Row(
                                key: const ValueKey('wide'),
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: _buildOptions(localizations, isDark),
                              )
                            : Column(
                                key: const ValueKey('narrow'),
                                children: _buildOptions(localizations, isDark),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _handleStart,
                      icon: const Icon(Icons.arrow_forward_ios),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      label: Text(
                        localizations.start,
                        style: textTheme.titleMedium?.copyWith(
                          color: AppColors.primaryForeground,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildOptions(AppLocalizations localizations, bool isDark) {
    return [
      Expanded(
        child: CraftsmanOptions(
          title: localizations.addPost,
          subTitle: localizations.addPostSubtitle,
          icon: Icons.add_circle_outline,
          value: 'add_post',
          selectedOption: selectedOption,
          isDark: isDark,
          onTap: () => setState(() => selectedOption = 'add_post'),
        ),
      ),
      const SizedBox(width: 16, height: 16),
      Expanded(
        child: CraftsmanOptions(
          title: localizations.viewPosts,
          subTitle: localizations.viewPostsSubtitle,
          icon: Icons.visibility_outlined,
          value: 'view_posts',
          selectedOption: selectedOption,
          isDark: isDark,
          onTap: () => setState(() => selectedOption = 'view_posts'),
        ),
      ),
    ];
  }
}
