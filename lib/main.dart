import 'package:craftworks_app/Client/home.dart';
import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'core/constants/app_theme.dart';
import 'Client/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'views/language_theme_toggle_view.dart';
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'providers/language_provider.dart';
import 'Client/login.dart';
import 'Client/forgetPass.dart';
import 'Client/signup.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  ThemeMode _themeMode = ThemeMode.system;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  void setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, languageProvider, child) {
          return MaterialApp(
            title: 'Craftworks App',
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeProvider.themeMode,
            locale: languageProvider.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const LanguageThemeToggleView(),
            routes: {
              '/login': (context) => const LoginScreen(),
              '/forgetpass': (context) => const ForgetPasswordScreen(),
              '/signup': (context) => const SignUp(),
              '/home': (context) => const HomeScreen(),
            },
          );
        },
      ),
    );
  }
}

class HomeScreenWithSettings extends StatelessWidget {
  final void Function(Locale) onLocaleChange;
  final void Function(ThemeMode) onThemeModeChange;
  final ThemeMode themeMode;
  const HomeScreenWithSettings({
    super.key,
    required this.onLocaleChange,
    required this.onThemeModeChange,
    required this.themeMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SettingsDrawer(
        onLocaleChange: onLocaleChange,
        onThemeModeChange: onThemeModeChange,
        themeMode: themeMode,
      ),
      body: const HomeScreen(),
    );
  }
}

class ClientProfileScreenWithSettings extends StatelessWidget {
  final void Function(Locale) onLocaleChange;
  final void Function(ThemeMode) onThemeModeChange;
  final ThemeMode themeMode;
  const ClientProfileScreenWithSettings({
    super.key,
    required this.onLocaleChange,
    required this.onThemeModeChange,
    required this.themeMode,
  });

  @override
  Widget build(BuildContext context) {
    return ClientProfileScreen(
      onLocaleChange: onLocaleChange,
      onThemeModeChange: onThemeModeChange,
      themeMode: themeMode,
    );
  }
}

class SettingsDrawer extends StatelessWidget {
  final void Function(Locale) onLocaleChange;
  final void Function(ThemeMode) onThemeModeChange;
  final ThemeMode themeMode;
  const SettingsDrawer({
    super.key,
    required this.onLocaleChange,
    required this.onThemeModeChange,
    required this.themeMode,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Text(loc.change_language)),
          ListTile(
            title: const Text('English'),
            onTap: () => onLocaleChange(const Locale('en')),
          ),
          ListTile(
            title: const Text('العربية'),
            onTap: () => onLocaleChange(const Locale('ar')),
          ),
          const Divider(),
          ListTile(
            title: Text(loc.change_theme),
            trailing: DropdownButton<ThemeMode>(
              value: themeMode,
              onChanged: (mode) {
                if (mode != null) onThemeModeChange(mode);
              },
              items: [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text(loc.light_mode),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text(loc.dark_mode),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class InitialScreen extends StatefulWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/'); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }
}
