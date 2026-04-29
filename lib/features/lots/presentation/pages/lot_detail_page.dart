// lib/features/lots/presentation/pages/lot_detail_page.dart
import 'package:flutter/material.dart';

class LotDetailPage extends StatelessWidget {
  const LotDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final lot = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Détail Lot"),
        backgroundColor: const Color(0xFF5C3A21),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text("ID: ${lot["id"]}"),
            Text("Espèce: ${lot["espece"]}"),
            Text("Poids: ${lot["poids_kg"]} kg"),
            Text("Statut: ${lot["statut"]}"),
            Text("Date récolte: ${lot["date_recolte"]}"),

            const SizedBox(height: 10),

            Text("GPS: ${lot["gps_latitude"]}, ${lot["gps_longitude"]}"),

            const SizedBox(height: 10),

            Text("Notes: ${lot["notes"] ?? ""}"),

            const SizedBox(height: 20),

            // QR CODE backend
            if (lot["qr_code_url"] != null)
              Center(
                child: Image.network(
                  lot["qr_code_url"],
                  height: 200,
                ),
              )
            else
              const Text("QR Code non disponible"),
          ],
        ),
      ),
    );
  }
}

