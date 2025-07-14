import 'package:craftworks_app/l10n/app_localizations.dart';
import 'package:craftworks_app/views/choose_user_type_view.dart';
import 'package:craftworks_app/views/language_theme_toggle_view.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:craftworks_app/providers/language_provider.dart';
import 'package:craftworks_app/providers/theme_provider.dart';
import 'package:craftworks_app/services/preferences_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesServices.initPreferences();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()..loadTheme()),
        ChangeNotifierProvider(
          create: (_) => LanguageProvider()..loadInitialLanguage(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crafworks',
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: languageProvider.fontFamily,
      ),

      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: languageProvider.fontFamily,
      ),
      locale: languageProvider.locale,
      supportedLocales: const [Locale('en'), Locale('ar')],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) return supportedLocales.first;
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      initialRoute: '/language_theme',
      routes: {
        '/language_theme': (context) => LanguageThemeToggleView(),
        '/choose_user': (context) => ChooseUserTypeView(),
      },
    );
  }
}
