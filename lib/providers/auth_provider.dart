import 'dart:convert';

import 'package:craftworks_app/services/preferences_services.dart';

class AuthManager {
  static Future<bool> isLoggedIn() async {
    final token = await PreferencesServices.getString('token');
    return token != null && token.isNotEmpty;
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final userJson = await PreferencesServices.getString('user');
    if (userJson == null) return null;
    return jsonDecode(userJson);
  }

  static Future<void> logout() async {
    await PreferencesServices.remove('token');
    await PreferencesServices.remove('user');
  }
}
