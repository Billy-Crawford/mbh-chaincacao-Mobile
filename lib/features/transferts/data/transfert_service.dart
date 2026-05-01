// lib/features/transferts/data/transfert_service.dart
import 'package:dio/dio.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/config/api.dart';

class TransfertService {
  final Dio _dio = DioClient().dio;

  Future<void> envoyerLot({
    required String lotId, // ✅ UUID STRING
    required int destinataireId,
    required double poidsVerifie,
    required String notes,
  }) async {
    try {
      await _dio.post(
        ApiConfig.transferts,
        data: {
          "lot": lotId,
          "destinataire": destinataireId,
          "etape": "ferme_cooperative",
          "poids_verifie": poidsVerifie,
          "notes": notes,
        },
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ?? "Erreur envoi lot",
      );
    }
  }
}

