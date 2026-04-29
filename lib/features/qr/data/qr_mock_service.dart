// lib/features/qr/data/qr_mock_service.dart

class QrMockService {

  Future<Map<String, dynamic>> verifyQr(String hash) async {
    await Future.delayed(const Duration(seconds: 2));

    if (hash == "VALID123") {
      return {
        "lot_id": "L001",
        "poids": 120,
        "statut": "exportateur",
        "eudr": "valide",
      };
    } else {
      throw Exception("Certificat invalide");
    }
  }
}

