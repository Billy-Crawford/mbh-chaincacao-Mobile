// lib/features/qr/presentation/qr_result_page.dart
import 'package:flutter/material.dart';

class QrResultPage extends StatelessWidget {
  const QrResultPage({super.key});

  @override
  Widget build(BuildContext context) {

    final data =
    ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Résultat"),
        backgroundColor: const Color(0xFF5C3A21),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            _item("Lot ID", data["lot_id"]),
            _item("Poids", "${data["poids"]} kg"),
            _item("Statut", data["statut"]),
            _item("EUDR", data["eudr"]),

          ],
        ),
      ),
    );
  }

  Widget _item(String title, String value) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}
