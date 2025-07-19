import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:craftworks_app/l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

List<_OnboardingPageData> _pages(BuildContext context) => [
  _OnboardingPageData(
    image: 'assets/images/onboarding1.png',
    title: AppLocalizations.of(context)?.onboarding_title_1 ?? 'All Crafts in One Place',
    description: AppLocalizations.of(context)?.onboarding_desc_1 ?? 'Need a plumber? Electrician? Painter? Find them all in one app — you choose who works for you!',
    buttonText: AppLocalizations.of(context)?.next ?? 'Next',
  ),
  _OnboardingPageData(
    image: 'assets/images/onboarding2.png',
    title: AppLocalizations.of(context)?.onboarding_title_2 ?? 'Trusted Professionals with Real Ratings',
    description: AppLocalizations.of(context)?.onboarding_desc_2 ?? 'Check each technician\'s reviews from previous clients and pick the best with confidence.',
    buttonText: AppLocalizations.of(context)?.next ?? 'Next',
  ),
  _OnboardingPageData(
    image: 'assets/images/onboarding3.png',
    title: AppLocalizations.of(context)?.onboarding_title_3 ?? 'The Nearest Technician is On the Way',
    description: AppLocalizations.of(context)?.onboarding_desc_3 ?? 'Track your technician live on the map until they reach your door.',
    buttonText: AppLocalizations.of(context)?.next ?? 'Next',
  ),
  _OnboardingPageData(
    image: 'assets/images/onboarding4.png',
    title: AppLocalizations.of(context)?.onboarding_title_4 ?? 'Emergency Services Anytime',
    description: AppLocalizations.of(context)?.onboarding_desc_4 ?? 'Water leak? Electric short? Request an urgent technician in seconds.',
    buttonText: AppLocalizations.of(context)?.next ?? 'Next',
  ),
  _OnboardingPageData(
    image: 'assets/images/onboarding5.png',
    title: AppLocalizations.of(context)?.onboarding_title_5 ?? 'Everything is Documented',
    description: AppLocalizations.of(context)?.onboarding_desc_5 ?? 'Receive a digital invoice, rate your technician, and keep track of every service.',
    buttonText: AppLocalizations.of(context)?.getStarted ?? 'Get Started',
  ),
];

  void _onNext() {
    if (_currentPage < _pages(context).length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pages = _pages(context);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return _OnboardingPage(
                    data: page,
                    isLast: index == pages.length - 1,
                    onNext: _onNext,
                    isDark: isDark,
                    colorScheme: colorScheme,
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pages.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 3,
                    vertical: 12,
                  ),
                  width: 16,
                  height: 4,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? colorScheme.primary
                        : colorScheme.onBackground,
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  final String image;
  final String title;
  final String description;
  final String buttonText;

  const _OnboardingPageData({
    required this.image,
    required this.title,
    required this.description,
    required this.buttonText,
  });
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingPageData data;
  final bool isLast;
  final VoidCallback onNext;
  final bool isDark;
  final ColorScheme colorScheme;

  const _OnboardingPage({
    Key? key,
    required this.data,
    required this.isLast,
    required this.onNext,
    required this.isDark,
    required this.colorScheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: colorScheme.primary.withOpacity(0.2),
                              width: 2,
                            ),
                          ),
                          child: Image.asset(
                            data.image,
                            width: 200,
                            height: 200,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Icon(
                                    Icons.image,
                                    size: 60,
                                    color: colorScheme.primary,
                                  ),
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 32,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (data.title.isNotEmpty)
                        Text(
                          data.title,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onBackground,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      const SizedBox(height: 16),
                      Text(
                        data.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: colorScheme.onBackground,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      if (data.buttonText.isNotEmpty)
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
                            child: Text(
                              data.buttonText,
                              style: TextStyle(
                                fontSize: 18,
                                color: colorScheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
} 