import 'package:alphalens_fend/utils/endpoint.dart' as Endpoint;
import 'package:alphalens_fend/utils/token_storage.dart';
import 'package:dio/dio.dart';



class ApiClient {
  final Dio _dio;

  ApiClient()
      : _dio = Dio(
          BaseOptions(
            baseUrl: Endpoint.baseUrl,
            connectTimeout: const Duration(seconds: 20),
            receiveTimeout: const Duration(seconds: 20),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ),
        ) {
   
_dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await TokenStorage.getToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    },
  ),
);
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('🚀 [API REQ] ${options.method} -> ${options.baseUrl}${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('✅ [API RESP] Status: ${response.statusCode}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print('❌ [API ERR] Failure on ${e.requestOptions.path}: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  // ================= GENERALIZED METHOD IMPLEMENTATIONS =================

  /// Handles standard data retrieval fetches
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return response;
    } on DioException {
      rethrow;
    }
  }

  /// Handles mutations, logins, registrations, and general payload transfers
  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.post(path, data: data, queryParameters: queryParameters);
      return response;
    } on DioException {
      rethrow;
    }
  }

  /// Handles data entity modification updates
  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.put(path, data: data, queryParameters: queryParameters);
      return response;
    } on DioException {
      rethrow;
    }
  }

  /// Handles structural asset removal destructions
  Future<Response> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.delete(path, data: data, queryParameters: queryParameters);
      return response;
    } on DioException {
      rethrow;
    }
  }
}