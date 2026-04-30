// lib/features/transferts/presentation/pages/send_lot_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/cooperative_provider.dart';
import '../../providers/transfert_provider.dart';

class SendLotPage extends ConsumerStatefulWidget {
  const SendLotPage({super.key});

  @override
  ConsumerState<SendLotPage> createState() => _SendLotPageState();
}

class _SendLotPageState extends ConsumerState<SendLotPage> {
  int? selectedCoopId;
  final TextEditingController poidsCtrl = TextEditingController();
  final TextEditingController notesCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final lot = ModalRoute.of(context)!.settings.arguments as Map;
    final cooperatives = ref.watch(cooperativesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Envoyer à une coopérative"),
        backgroundColor: const Color(0xFF5C3A21),
      ),

      // =========================
      // BODY
      // =========================
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: cooperatives.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(e.toString())),

          // =========================
          // DATA SUCCESS
          // =========================
          data: (data) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                // =========================
                // COOPERATIVES LIST
                // =========================
                DropdownButtonFormField<int>(
                  value: selectedCoopId,
                  decoration: const InputDecoration(
                    labelText: "Choisir une coopérative",
                    border: OutlineInputBorder(),
                  ),
                  items: data.map<DropdownMenuItem<int>>((coop) {
                    final id = int.parse(coop["id"].toString()); // ✅ FIX

                    return DropdownMenuItem<int>(
                      value: id,
                      child: Text(coop["username"] ?? "Coop"),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedCoopId = value);
                  },
                ),

                const SizedBox(height: 20),

                // =========================
                // POIDS
                // =========================
                TextField(
                  controller: poidsCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Poids vérifié (kg)",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                // =========================
                // NOTES
                // =========================
                TextField(
                  controller: notesCtrl,
                  decoration: const InputDecoration(
                    labelText: "Notes",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 30),

                // =========================
                // BUTTON SUBMIT
                // =========================
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () async {
                    if (selectedCoopId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Veuillez choisir une coopérative"),
                        ),
                      );
                      return;
                    }

                    try {
                      await ref.read(transfertProvider).envoyerLot(
                        lotId: lot["id"].toString(), // ✅ FORCER STRING
                        destinataireId: selectedCoopId!,
                        poidsVerifie: double.tryParse(poidsCtrl.text) ?? 0,
                        // poidsVerifie: double.parse(poidsCtrl.text),
                        notes: notesCtrl.text,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Lot envoyé avec succès"),
                        ),
                      );

                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  },
                  child: const Text("Envoyer le lot"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

