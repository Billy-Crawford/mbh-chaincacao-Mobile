import 'package:dio/dio.dart';
import '../../../../core/config/api.dart';
import '../../../../core/network/dio_client.dart';


class TransfertService {
  final Dio _dio = DioClient().dio;

  Future<void> envoyerLot({
    required int lotId,
    required int destinataireId,
    required double poids,
    required String notes,
  }) async {
    try {
      await _dio.post(
        ApiConfig.transferts,
        data: {
          "lot": lotId,
          "destinataire": destinataireId,
          "etape": "ferme_cooperative",
          "poids_verifie": poids,
          "notes": notes,
        },
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data.toString() ?? "Erreur transfert",
      );
    }
  }
}