// lib/features/transferts/providers/transfert_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/transfert_service.dart';

final transfertProvider = Provider((ref) => TransfertService());

