// lib/data/service/api_service.dart

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: dotenv.env['API_BASE_URL'] ?? '',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      LogInterceptor(
        request: true,
        responseBody: true,
        requestBody: true,
        error: true,
      ),
    );
  }

  Future<Response> get(
    String endpoint, {
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await _dio.get(endpoint, queryParameters: queryParams);
      return response;
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<List<dynamic>> fetchHome() async {
    try {
      final response = await _dio.get('/ongoing');
      // print(response.data['data']['animeList']);
      return response.data['data']['animeList'];
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  String _handleError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout) {
      return "Connection timeout";
    } else if (error.type == DioExceptionType.receiveTimeout) {
      return "Receive timeout";
    } else if (error.response != null) {
      return "Error ${error.response?.statusCode}: ${error.response?.data}";
    } else {
      return "Unexpected error: ${error.message}";
    }
  }
}
