// lib/features/users/data/users_service.dart
import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/config/api.dart';

class UsersService {
  final Dio _dio = DioClient().dio;

  /// 📥 Récupérer les coopératives
  Future<List<dynamic>> getCooperatives() async {
    try {
      final response = await _dio.get(
        "${ApiConfig.baseUrl}/api/auth/cooperatives/",
      );

      return response.data;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ?? "Erreur chargement coopératives",
      );
    }
  }
}

