import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:craftworks_app/models/category.dart';

class CategoryService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['baseUrl']!,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Future<List<Category>> fetchCategories() async {
    final response = await _dio.get('/services/categories');
    return (response.data as List)
        .map((item) => Category.fromJson(item))
        .toList();
  }
}
