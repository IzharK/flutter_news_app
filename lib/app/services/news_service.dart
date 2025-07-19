import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../core/config/app_config.dart';

/// Service class for handling all news-related API calls
/// Uses Dio for HTTP requests with proper error handling and logging
class NewsService extends GetxService {
  final String _baseUrl = AppConfig.apiBaseUrl;
  final String _apiKey = AppConfig.apiKey;

  final dio.Dio _dio;

  NewsService({dio.Dio? dioClient}) : _dio = dioClient ?? dio.Dio();

  @override
  void onInit() {
    super.onInit();
    _setupDio();
  }

  /// Configure Dio with base settings, interceptors, and error handling
  void _setupDio() {
    _dio.options
      ..baseUrl = _baseUrl
      ..connectTimeout = AppConfig.networkTimeout
      ..receiveTimeout = AppConfig.networkTimeout
      ..headers = {
        'Content-Type': 'application/json',
        'User-Agent': AppConfig.appDisplayName,
      };

    // Add logging interceptor for debug mode
    if (AppConfig.enableLogging) {
      _dio.interceptors.add(
        dio.LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: false,
          responseHeader: false,
          error: true,
          logPrint: (obj) => debugPrint(obj.toString()),
        ),
      );
    }

    // Add error handling interceptor
    _dio.interceptors.add(
      dio.InterceptorsWrapper(
        onError: (error, handler) {
          debugPrint('API Error: ${error.message}');
          handler.next(error);
        },
      ),
    );
  }

  /// Fetch top headlines for a specific country
  /// [country] - ISO 3166-1 alpha-2 country code (e.g., 'us', 'gb', 'ca')
  /// [category] - Optional category filter
  /// [pageSize] - Number of articles to return (max 100)
  /// [page] - Page number for pagination
  Future<Map<String, dynamic>> getTopHeadlines({
    String country = 'us',
    String? category,
    int? pageSize,
    int page = 1,
  }) async {
    final effectivePageSize = pageSize ?? AppConfig.defaultPageSize;
    try {
      final queryParams = <String, dynamic>{
        'country': country,
        'apiKey': _apiKey,
        'pageSize': effectivePageSize,
        'page': page,
      };

      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }

      final response = await _dio.get(
        '/top-headlines',
        queryParameters: queryParams,
      );

      return _handleResponse(response);
    } on dio.DioException catch (e) {
      throw NewsApiException(_handleDioError(e));
    } catch (e) {
      throw NewsApiException('Unexpected error: ${e.toString()}');
    }
  }

  /// Search for news articles with a query
  /// [query] - Search query string
  /// [sortBy] - Sort order: relevancy, popularity, publishedAt
  /// [pageSize] - Number of articles to return (max 100)
  /// [page] - Page number for pagination
  Future<Map<String, dynamic>> searchNews({
    required String query,
    String sortBy = 'publishedAt',
    int pageSize = 20,
    int page = 1,
  }) async {
    try {
      final response = await _dio.get(
        '/everything',
        queryParameters: {
          'q': query,
          'sortBy': sortBy,
          'pageSize': pageSize,
          'page': page,
          'apiKey': _apiKey,
        },
      );

      return _handleResponse(response);
    } on dio.DioException catch (e) {
      throw NewsApiException(_handleDioError(e));
    } catch (e) {
      throw NewsApiException('Unexpected error: ${e.toString()}');
    }
  }

  /// Get news by category for a specific country
  /// [category] - News category (business, entertainment, general, health, science, sports, technology)
  /// [country] - ISO 3166-1 alpha-2 country code
  Future<Map<String, dynamic>> getNewsByCategory({
    required String category,
    String country = 'us',
    int pageSize = 20,
    int page = 1,
  }) async {
    try {
      final response = await _dio.get(
        '/top-headlines',
        queryParameters: {
          'category': category,
          'country': country,
          'pageSize': pageSize,
          'page': page,
          'apiKey': _apiKey,
        },
      );

      return _handleResponse(response);
    } on dio.DioException catch (e) {
      throw NewsApiException(_handleDioError(e));
    } catch (e) {
      throw NewsApiException('Unexpected error: ${e.toString()}');
    }
  }

  /// Handle and validate API response
  Map<String, dynamic> _handleResponse(dio.Response response) {
    if (response.statusCode == 200) {
      final data = response.data as Map<String, dynamic>;

      // Validate response structure
      if (data.containsKey('status') && data['status'] == 'ok') {
        return data;
      } else if (data.containsKey('status') && data['status'] == 'error') {
        throw NewsApiException(data['message'] ?? 'API returned error status');
      } else {
        throw NewsApiException('Invalid response format');
      }
    } else {
      throw NewsApiException(
        'HTTP ${response.statusCode}: ${response.statusMessage}',
      );
    }
  }

  /// Handle Dio errors and convert them to user-friendly messages
  String _handleDioError(dio.DioException e) {
    switch (e.type) {
      case dio.DioExceptionType.connectionTimeout:
      case dio.DioExceptionType.sendTimeout:
      case dio.DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please check your internet connection and try again.';

      case dio.DioExceptionType.connectionError:
        return 'Unable to connect to the server. Please check your internet connection.';

      case dio.DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        switch (statusCode) {
          case 400:
            return 'Bad request. Please check your search parameters.';
          case 401:
            return 'Invalid API key. Please check your configuration.';
          case 429:
            return 'Too many requests. Please try again later.';
          case 500:
            return 'Server error. Please try again later.';
          default:
            return 'Server error (${statusCode ?? 'Unknown'}). Please try again later.';
        }

      case dio.DioExceptionType.cancel:
        return 'Request was cancelled.';

      case dio.DioExceptionType.unknown:
      default:
        return 'Network error occurred. Please check your connection and try again.';
    }
  }

  /// Get list of supported countries with their codes and names
  static List<Map<String, String>> getSupportedCountries() {
    return [
      {'code': 'us', 'name': 'United States'},
      {'code': 'gb', 'name': 'United Kingdom'},
      {'code': 'ca', 'name': 'Canada'},
      {'code': 'au', 'name': 'Australia'},
      {'code': 'de', 'name': 'Germany'},
      {'code': 'fr', 'name': 'France'},
      {'code': 'it', 'name': 'Italy'},
      {'code': 'jp', 'name': 'Japan'},
      {'code': 'kr', 'name': 'South Korea'},
      {'code': 'in', 'name': 'India'},
      {'code': 'br', 'name': 'Brazil'},
      {'code': 'mx', 'name': 'Mexico'},
      {'code': 'ar', 'name': 'Argentina'},
      {'code': 'za', 'name': 'South Africa'},
      {'code': 'eg', 'name': 'Egypt'},
      {'code': 'ng', 'name': 'Nigeria'},
      {'code': 'cn', 'name': 'China'},
      {'code': 'ru', 'name': 'Russia'},
      {'code': 'nl', 'name': 'Netherlands'},
      {'code': 'be', 'name': 'Belgium'},
    ];
  }

  /// Get list of supported news categories
  static List<String> getSupportedCategories() {
    return [
      'general',
      'business',
      'entertainment',
      'health',
      'science',
      'sports',
      'technology',
    ];
  }
}

/// Custom exception class for News API errors
class NewsApiException implements Exception {
  final String message;

  const NewsApiException(this.message);

  @override
  String toString() => 'NewsApiException: $message';
}
