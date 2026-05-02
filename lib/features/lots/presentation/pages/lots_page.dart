// lib/features/lots/presentation/pages/lots_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/lots_provider.dart';

class LotsPage extends ConsumerWidget {
  const LotsPage({super.key});

  // Amélioration de la palette de couleurs des statuts
  Color _statusColor(String status) {
    switch (status) {
      case "cree":
        return const Color(0xFFE67E22); // Orange plus doux
      case "certifie":
        return const Color(0xFF2F6B3F); // Ton vert agriculture
      case "exporte":
        return const Color(0xFF2980B9); // Bleu professionnel
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lots = ref.watch(lotsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F4),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF5C3A21)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Mes Récoltes",
          style: TextStyle(color: Color(0xFF5C3A21), fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/create-lot'),
        backgroundColor: const Color(0xFF2F6B3F),
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      body: lots.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF2F6B3F))),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, size: 48, color: Colors.redAccent),
              const SizedBox(height: 16),
              Text("Erreur: ${e.toString()}"),
            ],
          ),
        ),
        data: (data) {
          if (data.isEmpty) {
            return const Center(child: Text("Aucun lot enregistré pour le moment."));
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            itemCount: data.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final lot = data[index];
              final statusColor = _statusColor(lot["statut"]);

              return InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/lot-detail',
                    arguments: lot,
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Indicateur visuel ID
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF6F1E7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.inventory_2_outlined, color: Color(0xFF5C3A21)),
                      ),
                      const SizedBox(width: 16),
                      // Infos du lot
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Lot #${lot["id"]}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E1E12),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.monitor_weight_outlined, size: 14, color: Colors.grey.shade600),
                                const SizedBox(width: 4),
                                Text(
                                  "${lot["poids_kg"]} kg",
                                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Badge de Statut
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          lot["statut"].toUpperCase(),
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

