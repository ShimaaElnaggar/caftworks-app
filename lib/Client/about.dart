import 'package:flutter/material.dart';
import '../core/constants/app_theme.dart';
import '../l10n/app_localizations.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final currentLang = Localizations.localeOf(context).languageCode;

    final team = [
      {
        'name': currentLang == 'ar' ? 'سارة أحمد' : 'Sarah Ahmed',
        'role': currentLang == 'ar' ? 'مديرة المنتج' : 'Product Manager',
        'img': '',
      },
      {
        'name': currentLang == 'ar' ? 'محمد علي' : 'Mohamed Ali',
        'role': currentLang == 'ar' ? 'قائد التطوير' : 'Lead Developer',
        'img': '',
      },
      {
        'name': currentLang == 'ar' ? 'فاطمة نور' : 'Fatima Noor',
        'role': currentLang == 'ar' ? 'مصممة UI/UX' : 'UI/UX Designer',
        'img': '',
      },
      {
        'name': currentLang == 'ar' ? 'عمر خالد' : 'Omar Khaled',
        'role': currentLang == 'ar' ? 'مهندس خلفية' : 'Backend Engineer',
        'img': '',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(currentLang == 'ar' ? 'حول التطبيق' : 'About'),
        backgroundColor: colorScheme.primary,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [colorScheme.primary.withOpacity(0.05), colorScheme.secondary.withOpacity(0.1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  currentLang == 'ar' ? 'من نحن' : 'About Us',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onBackground,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  currentLang == 'ar'
                      ? 'مهمتنا هي ربطك بأفضل الحرفيين في منطقتك. نحن نؤمن بالجودة والثقة والراحة.'
                      : 'Our mission is to connect you with the best craftsmen in your area. We believe in quality, trust, and convenience.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onBackground.withOpacity(0.7),
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Card(
                  color: colorScheme.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: Column(
                            children: [
                              Text(currentLang == 'ar' ? 'مهمتنا' : 'Mission', style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.primary)),
                              const SizedBox(height: 8),
                              Text(currentLang == 'ar'
                                  ? 'تمكين المستخدمين من العثور على محترفين موثوقين بسهولة.'
                                  : 'To empower users to find trusted professionals easily.'),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Column(
                            children: [
                              Text(currentLang == 'ar' ? 'رؤيتنا' : 'Vision', style: TextStyle(fontWeight: FontWeight.bold, color: colorScheme.primary)),
                              const SizedBox(height: 8),
                              Text(currentLang == 'ar'
                                  ? 'أن نكون المنصة الرائدة للحرف والخدمات في المنطقة.'
                                  : 'To be the leading platform for crafts and services in the region.'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  currentLang == 'ar' ? 'فريقنا' : 'Our Team',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: team.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    final member = team[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(member['img']!),
                              radius: 36,
                            ),
                            const SizedBox(height: 12),
                            Text(member['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                            Text(member['role']!, style: TextStyle(color: colorScheme.primary)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 