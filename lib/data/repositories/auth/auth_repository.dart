import 'package:dio/dio.dart';
import 'package:alphalens_fend/utils/api_client.dart';
import 'dart:developer' as developer;


class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<String> loginUser({
  required String username,
  required String password,
}) async {
  try {
    final response = await _apiClient.post(
      '/login',
      data: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final token = response.data['access_token'];
      developer.log("Login success, token received");
      return token;
    }

    throw Exception('Login failed.');

  } on DioException catch (e) {
    if (e.response != null) {
      developer.log("Server responded with error status: ${e.response?.statusCode}");
      developer.log("Error payload data map: ${e.response?.data}");

      final data = e.response!.data;

      // FastAPI auto-validation 422 list format
      if (data is Map && data.containsKey('detail') && data['detail'] is List) {
        final list = data['detail'] as List;
        if (list.isNotEmpty && list.first is Map) {
          throw Exception(list.first['msg'] ?? 'Validation error.');
        }
      }

      // Your custom 400 error format
      if (data is Map && data.containsKey('detail') && data['detail'] is Map) {
        final detailMap = data['detail'] as Map;
        if (detailMap.containsKey('message')) {
          throw Exception(detailMap['message']);
        }
      }

      throw Exception('Login failed (${e.response?.statusCode}).');
    } else {
      developer.log("Network/Server connectivity issue: ${e.message}");
      throw Exception('Unable to reach server terminal module.');
    }
  }
}


Future<bool> deleteAccount() async {
  try {
    final response = await _apiClient.delete('/delete-account');

    if (response.statusCode == 200) {
      developer.log("Account deletion successful: ${response.data}");
      return true;
    }
    return false;

  } on DioException catch (e) {
    if (e.response != null) {
      developer.log("Server responded with error status: ${e.response?.statusCode}");
      developer.log("Error payload data map: ${e.response?.data}");

      final data = e.response!.data;

      if (data is Map && data.containsKey('detail')) {
        final detail = data['detail'];

        if (detail is Map && detail.containsKey('message')) {
          throw Exception(detail['message']);
        }

        if (detail is String) {
          throw Exception(detail);
        }

        if (detail is List && detail.isNotEmpty && detail.first is Map) {
          throw Exception(detail.first['msg'] ?? 'Validation error.');
        }
      }

      throw Exception('Account deletion failed (${e.response?.statusCode}).');
    } else {
      developer.log("Network/Server connectivity issue: ${e.message}");
      throw Exception('Unable to reach server terminal module.');
    }
  }
}


  Future<void> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        '/signup',
        data: {
          'username': username,
          'email': email,
          'password': password,
        },
      );

      // Successfully registered account
      if (response.statusCode == 200) {
        developer.log("Success payload received: ${response.data}");
        return; 
      } 
      
    } on DioException catch (e) {
      // Catching those 400 and 422 errors we saw in your tests
      if (e.response != null) {
        developer.log("Server responded with error status: ${e.response?.statusCode}");
        developer.log("Error payload data map: ${e.response?.data}");
        
        final data = e.response!.data;
        
        // 1. Handle FastAPI's auto-validation 422 list format (like the validation error we saw)
        if (data is Map && data.containsKey('detail') && data['detail'] is List) {
          final list = data['detail'] as List;
          if (list.isNotEmpty && list.first is Map) {
            throw Exception(list.first['msg'] ?? 'Validation validation error.');
          }
        }
        
        // 2. Handle your custom 400 bad request map error format (like "email already taken")
        if (data is Map && data.containsKey('detail') && data['detail'] is Map) {
          final detailMap = data['detail'] as Map;
          if (detailMap.containsKey('message')) {
            throw Exception(detailMap['message']);
          }
        }

        throw Exception('Registration failed (${e.response?.statusCode}).');
      } else {
        developer.log("Network/Server connectivity issue: ${e.message}");
        throw Exception('Unable to reach server terminal module.');
      }
    }
  }



  Future<String> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final response = await _apiClient.post(
        '/otp-verify',
        data: {
          'email': email,
          'otp': otp,
        },
      );

      // Matches: {"statuscode": 200, "message": "account verified..."}
      if (response.statusCode == 200 && response.data is Map) {
        final message = response.data['message'] ?? 'Account verified successfully.';
        developer.log("OTP verification successful message: $message");
        return message;
      }

      throw Exception('Verification failed.');

    } on DioException catch (e) {
      if (e.response != null) {
        developer.log("Server responded with error status: ${e.response?.statusCode}");
        developer.log("Error payload data map: ${e.response?.data}");
        
        final data = e.response!.data;
        
        // Matches your error payload structure: {"detail": {"statuscode": 400, "message": "incorrect otp"}}
        if (data is Map && data.containsKey('detail') && data['detail'] is Map) {
          final detailMap = data['detail'] as Map;
          if (detailMap.containsKey('message')) {
            throw Exception(detailMap['message']); // Will cleanly return "incorrect otp"
          }
        }
        
        // Fallback for standard FastAPI auto-validation 422 lists if they occur
        if (data is Map && data.containsKey('detail') && data['detail'] is List) {
          final list = data['detail'] as List;
          if (list.isNotEmpty && list.first is Map) {
            throw Exception(list.first['msg'] ?? 'Validation error.');
          }
        }

        throw Exception('Verification failed (${e.response?.statusCode}).');
      } else {
        developer.log("Network/Server connectivity issue: ${e.message}");
        throw Exception('Unable to reach server terminal module.');
      }
    }
  }
}