import 'dart:convert';

import 'package:craftworks_app/services/preferences_services.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['baseUrl']!,
      headers: {'Content-Type': 'application/json'},
    ),
  );
  
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String role,
  }) async {
    try {
      final res = await _dio.post(
        '/auth/register',
        data: {
          "full_name": fullName,
          "email": email,
          "phone": phone,
          "password": password,
          "role": role.toLowerCase(),
        },
      );
      // print("Response data: ${res.data}");
      final token = res.data['token'];
      final user = res.data['user'];

      await PreferencesServices.setString('token', token);
      await PreferencesServices.setString('user', jsonEncode(user));

      final userJson = await PreferencesServices.getString('user');
      print("User from SharedPreferences: $userJson");

      return {'success': true, 'user': user};
    } on DioException catch (e) {
      print("Dio error: ${e.response?.data}");
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Registration failed',
      };
    }
  }

Future<Map<String, dynamic>> login({
  required String email,
  required String password,
}) async {
  try {
    final res = await _dio.post(
      '/auth/login',
      data: {
        "email": email,
        "password": password,
      },
    );

    final token = res.data['token'];
    final user = res.data['user'];

    await PreferencesServices.setString('token', token);
    await PreferencesServices.setString('user', jsonEncode(user));

    print("Login successful. User: ${user['full_name']}");
    return {'success': true, 'user': user};
  } on DioException catch (e) {
    print("Login error: ${e.response?.data}");
    return {
      'success': false,
      'message': e.response?.data['message'] ?? 'Login failed',
    };
  }
}

}
