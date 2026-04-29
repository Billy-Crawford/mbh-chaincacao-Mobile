// lib/features/dashboard/presentation/providers/dashboard_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../lots/data/lots_service.dart';

final dashboardProvider =
StateNotifierProvider<DashboardNotifier, DashboardState>(
        (ref) => DashboardNotifier());

class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier() : super(DashboardState.initial()) {
    loadStats();
  }

  final _service = LotsService();

  Future<void> loadStats() async {
    state = state.copyWith(isLoading: true);

    try {
      final lots = await _service.getLots();

      final total = lots.length;

      final valides = lots.where((l) {
        final statut = l["statut"];
        return statut == "cooperative" || statut == "exportateur";
      }).length;

      final enAttente =
          lots.where((l) => l["statut"] == "cree").length;

      state = state.copyWith(
        isLoading: false,
        total: total,
        valides: valides,
        enAttente: enAttente,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

class DashboardState {
  final bool isLoading;
  final int total;
  final int valides;
  final int enAttente;
  final String? error;

  DashboardState({
    required this.isLoading,
    required this.total,
    required this.valides,
    required this.enAttente,
    this.error,
  });

  factory DashboardState.initial() {
    return DashboardState(
      isLoading: false,
      total: 0,
      valides: 0,
      enAttente: 0,
      error: null,
    );
  }

  DashboardState copyWith({
    bool? isLoading,
    int? total,
    int? valides,
    int? enAttente,
    String? error,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      total: total ?? this.total,
      valides: valides ?? this.valides,
      enAttente: enAttente ?? this.enAttente,
      error: error,
    );
  }
}

