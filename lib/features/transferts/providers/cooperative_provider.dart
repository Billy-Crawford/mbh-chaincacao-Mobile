// lib/features/transferts/providers/cooperative_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../users/data/users_service.dart';

final cooperativesProvider = FutureProvider<List<dynamic>>((ref) async {
  return UsersService().getCooperatives();
});
