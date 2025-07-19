import 'dart:ui';
import 'package:craftworks_app/services/preferences_services.dart';
import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _locale = const Locale('en');
  String _fontFamily = 'Roboto';
  TextDirection _textDirection = TextDirection.ltr;
  String _currentLanguageCode = 'en';

  Locale get locale => _locale;
  String get fontFamily => _fontFamily;
  TextDirection get textDirection => _textDirection;
  String get currentLanguage => _currentLanguageCode;

  Future<void> initialize() async {
    await loadInitialLanguage();
  }

  Future<void> loadInitialLanguage() async {
    if (await PreferencesServices.containsKey('languageCode')) {
      final savedLang = PreferencesServices.getString('languageCode');
      if (savedLang != null) {
        await _setLanguage(savedLang as String);
      }
    } else {
      final deviceLang = PlatformDispatcher.instance.locale.languageCode;
      await _setLanguage(deviceLang);
    }
  }

  Future<void> setLanguage(String langCode) async {
    if (_currentLanguageCode != langCode) {
      await PreferencesServices.setString('languageCode', langCode);
      await _setLanguage(langCode);
    }
  }

  Future<void> _setLanguage(String langCode) async {
    _currentLanguageCode = langCode;
    
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

  Future<void> toggleLanguage() async {
    final newLang = _currentLanguageCode == 'en' ? 'ar' : 'en';
    await setLanguage(newLang);
  }
}