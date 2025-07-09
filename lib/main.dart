import 'package:craftworks_app/core/constants/app_fonts.dart';
import 'package:craftworks_app/providers/theme_provider.dart';
import 'package:craftworks_app/services/preferences_services.dart';
import 'package:craftworks_app/views/language_theme_toggle_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesServices.initPreferences();
  runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) => ThemeProvider()..loadTheme(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crafworks',
      themeMode: Provider.of<ThemeProvider>(context).themeMode,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: AppFonts.primaryFont,
      ),
      home: LanguageThemeToggleView(),
    );
  }
}
