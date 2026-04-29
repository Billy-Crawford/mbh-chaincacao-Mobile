// lib/features/auth/presentation/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/auth_service.dart';
import '../../../../core/storage/secure_storage.dart';
import 'auth_state.dart';

final authProvider =
StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState());

  final _service = AuthService();
  final _storage = SecureStorage();

  Future<void> login(
      String username,
      String password,
      ) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final token = await _service.login(
        username: username,
        password: password,
      );

      await _storage.saveToken(token);

      state = state.copyWith(
        isLoading: false,
        token: token,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> register(
      String username,
      String telephone,
      String password,
      ) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _service.register(
        username: username,
        telephone: telephone,
        password: password,
      );

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> checkAuth() async {
    final token = await _storage.getToken();

    if (token != null) {
      state = state.copyWith(token: token);
    }
  }

  Future<void> logout() async {
    await _storage.clear();
    state = AuthState();
  }
}

