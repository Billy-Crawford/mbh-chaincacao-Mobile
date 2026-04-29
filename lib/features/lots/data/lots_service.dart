// lib/features/lots/data/lots_service.dart
import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/config/api.dart';

class LotsService {
  final Dio _dio = DioClient().dio;

  Future<void> createLot({
    required String espece,
    required double poidsKg,
    required double latitude,
    required double longitude,
    required String dateRecolte,
    required String notes,
  }) async {
    await _dio.post(
      ApiConfig.lots,
      data: {
        "espece": espece,
        "poids_kg": poidsKg,
        "gps_latitude": latitude,
        "gps_longitude": longitude,
        "date_recolte": dateRecolte,
        "notes": notes,
      },
    );
  }

  /// 🔥 Liste lots user connecté
  Future<List<dynamic>> getLots() async {
    final response = await _dio.get(ApiConfig.lots);
    return response.data;
  }

  /// 🔥 Détail lot
  Future<Map<String, dynamic>> getLot(String id) async {
    final response = await _dio.get("${ApiConfig.lots}$id/");
    return response.data;
  }
}
