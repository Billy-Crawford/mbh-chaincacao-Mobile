// lib/features/dashboard/presentation/dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dashboard_provider.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F1E7),
      appBar: AppBar(
        title: const Text("Dashboard Agriculteur"),
        backgroundColor: const Color(0xFF5C3A21),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: () =>
            ref.read(dashboardProvider.notifier).loadStats(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 👤 HEADER USER
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF2F6B3F),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Bienvenue 👋",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Agriculteur",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _card("Total lots", state.total, Colors.brown),
            const SizedBox(height: 15),

            _card("Lots validés", state.valides, Colors.green),
            const SizedBox(height: 15),

            _card("En attente", state.enAttente, Colors.orange),

            const SizedBox(height: 30),

            _button(
              "Créer un lot",
              Colors.brown,
                  () => Navigator.pushNamed(context, '/create-lot'),
            ),

            const SizedBox(height: 12),

            _button(
              "Voir mes lots",
              const Color(0xFF2F6B3F),
                  () => Navigator.pushNamed(context, '/lots'),
            ),

            // const SizedBox(height: 12),
            //
            // _button(
            //   "Mes parcelles",
            //   Colors.blueGrey,
            //       () {
            //     // futur module parcelle
            //   },
            // ),

            // const SizedBox(height: 12),
            //
            // _button(
            //   "Scanner certificat",
            //   Colors.black,
            //       () => Navigator.pushNamed(context, '/qr'),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _card(String title, int value, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(title,
              style: const TextStyle(color: Colors.white, fontSize: 16)),
          const SizedBox(height: 10),
          Text(
            value.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _button(String text, Color color, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(backgroundColor: color),
        child: Text(text),
      ),
    );
  }
}


