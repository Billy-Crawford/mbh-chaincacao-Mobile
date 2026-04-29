// lib/features/lots/presentation/pages/lots_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/lots_provider.dart';

class LotsPage extends ConsumerWidget {
  const LotsPage({super.key});

  Color _statusColor(String status) {
    switch (status) {
      case "cree":
        return Colors.orange;
      case "certifie":
        return Colors.green;
      case "exporte":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lots = ref.watch(lotsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes lots"),
        backgroundColor: const Color(0xFF5C3A21),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/create-lot'),
        child: const Icon(Icons.add),
      ),
      body: lots.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final lot = data[index];

              return Card(
                child: ListTile(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/lot-detail',
                      arguments: lot,
                    );
                  },
                  title: Text("Lot ${lot["id"]}"),
                  subtitle: Text("${lot["poids_kg"]} kg"),
                  trailing: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _statusColor(lot["statut"]),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      lot["statut"],
                      style: const TextStyle(color: Colors.white),
                    ),
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

