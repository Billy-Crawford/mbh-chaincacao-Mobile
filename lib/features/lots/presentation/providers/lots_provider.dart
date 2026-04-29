// lib/features/lots/presentation/providers/lots_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/lots_service.dart';

final lotsProvider =
AsyncNotifierProvider<LotsNotifier, List<dynamic>>(
  LotsNotifier.new,
);

class LotsNotifier extends AsyncNotifier<List<dynamic>> {
  final _service = LotsService();

  @override
  Future<List<dynamic>> build() async {
    return await _service.getLots();
  }

  /// ➕ créer lot + refresh liste
  Future<void> createLot({
    required String espece,
    required double poids,
    required double latitude,
    required double longitude,
    required String date,
    required String notes,
  }) async {
    await _service.createLot(
      espece: espece,
      poidsKg: poids,
      latitude: latitude,
      longitude: longitude,
      dateRecolte: date,
      notes: notes,
    );

    // 🔄 refresh après création
    state = await AsyncValue.guard(() => _service.getLots());
  }

  /// 🔄 refresh manuel
  Future<void> refresh() async {
    state = await AsyncValue.guard(() => _service.getLots());
  }
}
