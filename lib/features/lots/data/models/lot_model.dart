// lib/features/lots/data/models/lot_model.dart
class Lot {
  final String id;
  final double poids;
  final String statut;
  final double latitude;
  final double longitude;

  Lot({
    required this.id,
    required this.poids,
    required this.statut,
    required this.latitude,
    required this.longitude,
  });
}