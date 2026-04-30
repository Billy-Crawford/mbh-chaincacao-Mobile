// lib/core/config/api.dart
class ApiConfig {
  static const String baseUrl =
      "https://mbh-chaincacao-back.onrender.com";

  // Auth
  static const String login = "/api/auth/login/";
  static const String register = "/api/auth/register/";

  // Lots
  static const String lots = "/api/lots/";
  static const String transferts = "/api/transferts/";

  // Certificats
  // static const String certificats = "/api/lots/scanner/";
  static const String certificats = "/api/lots/{id}/verify/";

  // liate cooperatives
  static const String cooperatives = "/api/auth/cooperatives/";
}

