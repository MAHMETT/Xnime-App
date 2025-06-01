// lib/data/service/api_service.dart

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:xnime_app/data/models/anime_items_model.dart';
import 'package:xnime_app/data/models/detail/detail_model.dart';
import 'package:xnime_app/data/models/home/home_model.dart';

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

  // Future<List<dynamic>> fetchOngoing() async {
  //   try {
  //     final response = await _dio.get('/ongoing');
  //     return response.data['data']['animeList'];
  //   } on DioException catch (e) {
  //     throw Exception(_handleError(e));
  //   }
  // }

  Future<List<dynamic>> fetchExplore() async {
    try {
      final response = await _dio.get('/ongoing');
      return response.data['data']['animeList'];
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<Map<String, dynamic>> fetchOngoing({int page = 1}) async {
    try {
      final response = await _dio.get('/ongoing?page=$page');
      return response.data;
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<Map<String, dynamic>> fetchCompleted({int page = 1}) async {
    try {
      final response = await _dio.get('/completed?page=$page');
      return response.data;
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  Future<HomeModel> fetchHome() async {
    try {
      final response = await _dio.get('/home');
      return HomeModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  // Future<List<AnimeItems>> fetchSearch(String query) async {
  //   try {
  //     final response = await _dio.get('/search?q=$query');
  //     if (response.statusCode == 200) {
  //       final List list = response.data['data']; // sesuaikan dengan struktur
  //       return list.map((item) => AnimeItems.fromJson(item)).toList();
  //     } else {
  //       throw Exception('Anime tidak ditemukan');
  //     }
  //   } on DioException catch (e) {
  //     throw Exception(_handleError(e));
  //   }
  // }

  Future<Map<String, dynamic>> fetchSearch(String query) async {
    try {
      final response = await _dio.get('/search', queryParameters: {'q': query});
      return response.data;
    } catch (e) {
      throw Exception('Failed to fetch search results: $e');
    }
  }

  Future<List<AnimeItems>> fetchSearchAnime(String query) async {
    final data = await fetchSearch(query);
    final List<dynamic> rawList = data['data']['animeList'];
    return rawList.map((json) => AnimeItems.fromJson(json)).toList();
  }

  Future<DetailModel> fetchDetailAnime(String animeId) async {
    final response = await _dio.get('/anime/$animeId');
    final data = response.data['data'];
    return DetailModel.fromJson(data);
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
