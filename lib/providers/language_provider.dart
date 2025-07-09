import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:craftworks_app/services/preferences_services.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  String _fontFamily = 'Roboto';
  TextDirection _textDirection = TextDirection.ltr;

  Locale get locale => _locale;
  String get fontFamily => _fontFamily;
  TextDirection get textDirection => _textDirection;

  Future<void> loadInitialLanguage() async {
    if (PreferencesServices.containsKey('languageCode')) {
      final savedLang = PreferencesServices.getString('languageCode');
      if (savedLang != null) _setLanguage(savedLang);
    } else {
      final deviceLang = PlatformDispatcher.instance.locale.languageCode;
      _setLanguage(deviceLang);
    }
  }

  Future<void> setLanguage(String langCode) async {
    await PreferencesServices.setString('languageCode', langCode);
    _setLanguage(langCode);
  }

  void _setLanguage(String langCode) {
    if (langCode == 'ar') {
      _locale = const Locale('ar');
      _fontFamily = 'Cairo';
      _textDirection = TextDirection.rtl;
    } else {
      _locale = const Locale('en');
      _fontFamily = 'Roboto';
      _textDirection = TextDirection.ltr;
    }
    notifyListeners();
  }
}
