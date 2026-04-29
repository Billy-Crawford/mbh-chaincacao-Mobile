// lib/features/lots/data/datasources/lots_mock_service.dart
import '../models/lot_model.dart';

class LotsMockService {

  List<Lot> _storage = [
    Lot(
      id: "L001",
      poids: 120,
      statut: "cree",
      latitude: 6.1725,
      longitude: 1.2314,
    ),
    Lot(
      id: "L002",
      poids: 200,
      statut: "cooperative",
      latitude: 6.1800,
      longitude: 1.2500,
    ),
  ];

  Future<List<Lot>> getLots() async {
    await Future.delayed(const Duration(seconds: 1));
    return _storage;
  }

  Future<Lot> createLot(
      double poids,
      double latitude,
      double longitude,
      ) async {
    await Future.delayed(const Duration(seconds: 1));

    final newLot = Lot(
      id: "L00${_storage.length + 1}",
      poids: poids,
      statut: "cree",
      latitude: latitude,
      longitude: longitude,
    );

    _storage.add(newLot);

    return newLot;
  }
}
