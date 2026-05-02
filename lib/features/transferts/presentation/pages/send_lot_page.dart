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
      backgroundColor: const Color(0xFFFBF9F4),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF5C3A21)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Transfert de Lot",
          style: TextStyle(color: Color(0xFF5C3A21), fontWeight: FontWeight.bold),
        ),
      ),
      body: cooperatives.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF2F6B3F))),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Text("Erreur de chargement : ${e.toString()}", textAlign: TextAlign.center),
          ),
        ),
        data: (data) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- RÉCAPITULATIF DU LOT ---
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2F6B3F).withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF2F6B3F).withOpacity(0.1)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.inventory_2_rounded, color: Color(0xFF2F6B3F)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Envoi du Lot #${lot["id"]}",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Text(
                        "${lot["poids_kg"]} kg déclarés",
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                _sectionTitle("DESTINATAIRE"),
                const SizedBox(height: 12),

                // --- SELECT COOPERATIVE ---
                _buildFieldWrapper(
                  child: DropdownButtonFormField<int>(
                    value: selectedCoopId,
                    icon: const Icon(Icons.business_rounded, color: Color(0xFF2F6B3F)),
                    decoration: _inputDecoration("Choisir une coopérative"),
                    items: data.map<DropdownMenuItem<int>>((coop) {
                      final id = int.parse(coop["id"].toString());
                      return DropdownMenuItem<int>(
                        value: id,
                        child: Text(coop["username"] ?? "Coopérative"),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => selectedCoopId = value),
                  ),
                ),

                const SizedBox(height: 24),
                _sectionTitle("VÉRIFICATION LOGISTIQUE"),
                const SizedBox(height: 12),

                // --- POIDS VÉRIFIÉ ---
                _buildFieldWrapper(
                  child: TextField(
                    controller: poidsCtrl,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration("Poids pesé au départ (kg)", icon: Icons.scale_rounded),
                  ),
                ),

                const SizedBox(height: 20),

                // --- NOTES ---
                _buildFieldWrapper(
                  child: TextField(
                    controller: notesCtrl,
                    maxLines: 2,
                    decoration: _inputDecoration("Notes de transfert (ex: état des sacs)", icon: Icons.edit_note_rounded),
                  ),
                ),

                const SizedBox(height: 48),

                // --- SUBMIT BUTTON ---
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2F6B3F),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    elevation: 8,
                    shadowColor: const Color(0xFF2F6B3F).withOpacity(0.4),
                  ),
                  onPressed: () async {
                    if (selectedCoopId == null) {
                      _showSnackBar(context, "Veuillez choisir une coopérative", Colors.orange);
                      return;
                    }

                    try {
                      await ref.read(transfertProvider).envoyerLot(
                        lotId: lot["id"].toString(),
                        destinataireId: selectedCoopId!,
                        poidsVerifie: double.tryParse(poidsCtrl.text) ?? 0,
                        notes: notesCtrl.text,
                      );

                      _showSnackBar(context, "Lot transféré avec succès", const Color(0xFF2F6B3F));
                      if (!mounted) return;
                      Navigator.pop(context);
                    } catch (e) {
                      _showSnackBar(context, e.toString(), Colors.redAccent);
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("CONFIRMER L'ENVOI", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1)),
                      SizedBox(width: 10),
                      Icon(Icons.send_rounded, size: 20),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade600, letterSpacing: 1.1),
    );
  }

  Widget _buildFieldWrapper({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }

  InputDecoration _inputDecoration(String hint, {IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: icon != null ? Icon(icon, color: const Color(0xFF2F6B3F), size: 20) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(20),
      ),
    );
  }
}

