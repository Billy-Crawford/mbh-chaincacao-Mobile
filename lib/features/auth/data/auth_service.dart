// lib/features/auth/data/auth_service.dart
import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/config/api.dart';

class AuthService {
  final Dio _dio = DioClient().dio;

  Future<void> register({
    required String username,
    required String telephone,
    required String password,
  }) async {
    try {
      await _dio.post(
        ApiConfig.register,
        data: {
          "username": username,
          "email": "$username@gmail.com",
          "password": password,
          "role": "agriculteur",
          "telephone": telephone,
          "village": "Non défini",
          "region": "Non défini",
        },
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data.toString() ?? "Erreur serveur");
    }
  }

  // ✅ LOGIN CORRIGÉ
  Future<String> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiConfig.login,
        data: {
          "username": username,
          "password": password,
        },
      );

      return response.data["access"];
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ?? "Identifiants incorrects",
      );
    }
  }
}

