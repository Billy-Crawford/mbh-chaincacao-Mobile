// lib/features/auth/data/datasources/auth_mock_service.dart
class AuthMockService {

  Future<Map<String, dynamic>> login(String phone, String pin) async {
    await Future.delayed(const Duration(seconds: 2));

    if (pin == "1234") {
      return {
        "access": "fake_token_123",
        "role": "agriculteur"
      };
    } else {
      throw Exception("PIN incorrect");
    }
  }

  // 🔥 NOUVEAU
  Future<Map<String, dynamic>> register(
      String name,
      String phone,
      String pin,
      ) async {
    await Future.delayed(const Duration(seconds: 2));

    if (name.isEmpty || phone.isEmpty || pin.length != 4) {
      throw Exception("Champs invalides");
    }

    return {
      "access": "fake_token_new_user",
      "role": "agriculteur"
    };
  }
}

