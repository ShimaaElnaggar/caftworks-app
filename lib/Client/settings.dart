import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_theme.dart';
import '../providers/theme_provider.dart';
import '../providers/language_provider.dart';
import '../l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile.dart';
import 'about.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? userName;
  String? userAvatar;
  bool isLoadingUser = false;
  String? userError;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    setState(() {
      isLoadingUser = true;
      userError = null;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      if (token == null) {
        setState(() {
          userError = 'Not logged in.';
        });
        return;
      }
      final url = Uri.parse('http://192.168.1.2:5000/api/users/me');
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer ' + token,
      });
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userName = data['full_name'] ?? 'User';
          userAvatar = data['profile_image'];
        });
      } else {
        setState(() {
          userError = 'Failed to load user info.';
        });
      }
    } catch (e) {
      setState(() {
        userError = 'Network error: ' + e.toString();
      });
    } finally {
      setState(() {
        isLoadingUser = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final currentLang = languageProvider.currentLanguage;
    final loc = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final cardColor = Theme.of(context).cardColor;
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final textColor = colorScheme.onBackground;

    return Directionality(
      textDirection: languageProvider.textDirection,
      child: Scaffold(
        backgroundColor: scaffoldBg,
        appBar: AppBar(
          backgroundColor: colorScheme.primary,
          elevation: 0,
          title: Text(loc.settings, style: const TextStyle(color: Colors.white)),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                children: [
                  Text(currentLang == 'ar' ? loc.arabic : loc.english, style: const TextStyle(color: Colors.white)),
                  const SizedBox(width: 4),
                  const Icon(Icons.language, color: Colors.white, size: 20),
                ],
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ClientProfileScreen()),
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.primary, cardColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: isLoadingUser
                          ? const Center(child: CircularProgressIndicator())
                          : (userAvatar != null && userAvatar!.isNotEmpty)
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    userAvatar!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.person, size: 60, color: Colors.grey);
                                    },
                                  ),
                                )
                              : const Icon(Icons.person, size: 60, color: Colors.grey),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isLoadingUser)
                          const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        else if (userError != null)
                          Text(
                            userError!,
                            style: const TextStyle(fontSize: 16, color: Colors.red),
                          )
                        else
                          Text(
                            userName ?? 'User',
                            style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        const SizedBox(height: 4),
                        Text('${loc.profile}', style: const TextStyle(fontSize: 14, color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    color: colorScheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(loc.settings, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  // _SettingsTile(icon: Icons.edit, label: loc.profile),
                  _SettingsTile(icon: Icons.notifications, label: currentLang == 'ar' ? 'الإشعارات' : 'Notifications'),
                  _SettingsTile(icon: Icons.chat, label: currentLang == 'ar' ? 'سجل الدردشة' : 'Chat History'),
                  _SettingsTile(icon: Icons.card_giftcard, label: currentLang == 'ar' ? 'رموز ترويجية' : 'Promo Codes'),
                  _SettingsTile(
                    icon: Icons.info_outline,
                    label: currentLang == 'ar' ? 'حول التطبيق' : 'About',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AboutScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.brightness_6, color: colorScheme.primary),
                    title: Text(loc.theme, style: TextStyle(fontWeight: FontWeight.w500, color: textColor)),
                    trailing: Switch(
                      value: isDark,
                      onChanged: (val) {
                        themeProvider.toggleTheme(val);
                      },
                    ),
                    tileColor: cardColor,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    dense: true,
                  ),
                  ListTile(
                    leading: Icon(Icons.language, color: colorScheme.primary),
                    title: Text(loc.language, style: TextStyle(fontWeight: FontWeight.w500, color: textColor)),
                    trailing: Text(currentLang == 'ar' ? loc.arabic : loc.english),
                    onTap: () async {
                      final selected = await showDialog<String>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(loc.change_language),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: Text(loc.english),
                                onTap: () => Navigator.pop(context, 'en'),
                                selected: currentLang == 'en',
                              ),
                              ListTile(
                                title: Text(loc.arabic),
                                onTap: () => Navigator.pop(context, 'ar'),
                                selected: currentLang == 'ar',
                              ),
                            ],
                          ),
                        ),
                      );
                      if (selected != null && selected != currentLang) {
                        await languageProvider.setLanguage(selected);
                      }
                    },
                    tileColor: cardColor,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    dense: true,
                  ),
                  Container(
                    color: colorScheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    margin: const EdgeInsets.only(top: 12),
                    child: Text(loc.settings, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  _SettingsTile(icon: Icons.policy, label: loc.privacyPolicy),
                  _SettingsTile(icon: Icons.share, label: currentLang == 'ar' ? 'مشاركة التطبيق' : 'Share App'),
                  _SettingsTile(icon: Icons.phone, label: currentLang == 'ar' ? 'اتصل بنا' : 'Contact Us'),
                  _SettingsTile(icon: Icons.language, label: loc.language),
                  _SettingsTile(icon: Icons.delete, label: currentLang == 'ar' ? 'حذف الحساب' : 'Delete Account'),
                  _SettingsTile(icon: Icons.logout, label: loc.logout),
                  const SizedBox(height: 24),
                  Center(
                    child: Column(
                      children: [
                        Text((currentLang == 'ar' ? 'تابعنا' : 'Follow us'), style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            _SocialIcon(icon: Icons.facebook, color: Color(0xFF4267B2)),
                            SizedBox(width: 16),
                            // _SocialIcon(icon: Icons.youtube_searched_for, color: Color(0xFFFF0000)),
                            // SizedBox(width: 16),
                            _SocialIcon(icon: Icons.g_mobiledata, color: Color(0xFFDB4437)),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text('App Version 12.9.1', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _SettingsTile({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final cardColor = Theme.of(context).cardColor;
    final textColor = colorScheme.onBackground;
    return ListTile(
      leading: Icon(icon, color: colorScheme.primary),
      title: Text(label, style: TextStyle(fontWeight: FontWeight.w500, color: textColor)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
      tileColor: cardColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      dense: true,
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _SocialIcon({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: color.withOpacity(0.1),
      child: Icon(icon, color: color, size: 28),
      radius: 22,
    );
  }
} 