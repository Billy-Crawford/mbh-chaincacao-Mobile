// lib/core/network/dio_client.dart
import 'package:dio/dio.dart';
import '../config/api.dart';
import '../storage/secure_storage.dart';

class DioClient {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  )..interceptors.add(AuthInterceptor());
}

class AuthInterceptor extends Interceptor {
  final _storage = SecureStorage();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {

    // 🚨 NE PAS envoyer token sur auth endpoints
    if (!options.path.contains("/auth/")) {
      final token = await _storage.getToken();

      if (token != null && token.isNotEmpty) {
        options.headers["Authorization"] = "Bearer $token";
      }
    }

    handler.next(options);
  }

  // @override
  // void onRequest(
  //     RequestOptions options,
  //     RequestInterceptorHandler handler,
  //     ) async {
  //   final token = await _storage.getToken();
  //
  //   if (token != null) {
  //     options.headers["Authorization"] = "Bearer $token";
  //   }
  //
  //   return handler.next(options);
  // }
}

