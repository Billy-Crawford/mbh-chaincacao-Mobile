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
      backgroundColor: const Color(0xFFFBF9F4),
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "Tableau de bord",
          style: TextStyle(color: Color(0xFF2E1E12), fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {}, // Logique déconnexion éventuelle
            icon: const Icon(Icons.logout_rounded, color: Color(0xFF5C3A21)),
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF2F6B3F)))
          : RefreshIndicator(
        onRefresh: () => ref.read(dashboardProvider.notifier).loadStats(),
        color: const Color(0xFF2F6B3F),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          children: [
            // --- HEADER USER ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2F6B3F), Color(0xFF1E4D2B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2F6B3F).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Bonjour 👋",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.notifications_none, color: Colors.white, size: 20),
                      ),
                    ],
                  ),
                  const Text(
                    "Agriculteur",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- SECTION STATISTIQUES (GRID VIEW) ---
            const Text(
              "Aperçu de vos lots",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E1E12),
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _statCard(
                    "Total lots",
                    state.total.toString(),
                    Icons.inventory_2_rounded,
                    const Color(0xFF5C3A21),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _statCard(
                    "Validés",
                    state.valides.toString(),
                    Icons.check_circle_rounded,
                    const Color(0xFF2F6B3F),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _statCard(
              "Lots en attente de validation",
              state.enAttente.toString(),
              Icons.pending_actions_rounded,
              const Color(0xFFE67E22),
              isFullWidth: true,
            ),

            const SizedBox(height: 35),

            // --- ACTIONS ---
            const Text(
              "Actions rapides",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E1E12),
              ),
            ),
            const SizedBox(height: 16),

            _actionButton(
              context,
              "Créer un nouveau lot",
              "Enregistrer une nouvelle récolte",
              Icons.add_box_rounded,
              const Color(0xFF5C3A21),
                  () => Navigator.pushNamed(context, '/create-lot'),
            ),
            const SizedBox(height: 12),
            _actionButton(
              context,
              "Consulter mes lots",
              "Historique et suivi des transferts",
              Icons.list_alt_rounded,
              const Color(0xFF2F6B3F),
                  () => Navigator.pushNamed(context, '/lots'),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // Widget de carte statistique moderne
  Widget _statCard(String title, String value, IconData icon, Color color, {bool isFullWidth = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: isFullWidth ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // Widget de bouton d'action stylisé
  Widget _actionButton(BuildContext context, String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: color.withOpacity(0.7)),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: color, size: 16),
          ],
        ),
      ),
    );
  }
}
