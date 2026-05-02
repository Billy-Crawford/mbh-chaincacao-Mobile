// lib/features/lots/presentation/pages/create_lot_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import '../providers/lots_provider.dart';

class CreateLotPage extends ConsumerStatefulWidget {
  const CreateLotPage({super.key});

  @override
  ConsumerState<CreateLotPage> createState() => _CreateLotPageState();
}

class _CreateLotPageState extends ConsumerState<CreateLotPage> {
  final poidsController = TextEditingController();
  final notesController = TextEditingController();

  String? espece;
  DateTime? dateRecolte;
  double? latitude;
  double? longitude;

  final List<Map<String, String>> especes = const [
    {"value": "forastero", "label": "Forastero"},
    {"value": "trinitario", "label": "Trinitario"},
    {"value": "criollo", "label": "Criollo"},
    {"value": "arabica", "label": "Arabica"},
    {"value": "robusta", "label": "Robusta"},
  ];

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF2F6B3F),
              onPrimary: Colors.white,
              onSurface: Color(0xFF5C3A21),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() => dateRecolte = date);
    }
  }

  Future<void> getLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    final pos = await Geolocator.getCurrentPosition();
    setState(() {
      latitude = pos.latitude;
      longitude = pos.longitude;
    });
  }

  Future<void> createLot() async {
    if (espece == null ||
        dateRecolte == null ||
        latitude == null ||
        longitude == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez remplir tous les champs obligatoires"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      await ref.read(lotsProvider.notifier).createLot(
        espece: espece!,
        poids: double.parse(poidsController.text),
        latitude: latitude!,
        longitude: longitude!,
        date: DateFormat('yyyy-MM-dd').format(dateRecolte!),
        notes: notesController.text,
      );
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF9F4),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF5C3A21)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Nouveau Lot",
          style: TextStyle(color: Color(0xFF5C3A21), fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Informations du produit"),
            const SizedBox(height: 16),

            // ESPÈCE DROPDOWN
            _buildCardWrapper(
              child: DropdownButtonFormField<String>(
                value: espece,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF2F6B3F)),
                decoration: _inputDecoration("Espèce de cacao/café", Icons.psychology_outlined),
                items: especes.map((e) {
                  return DropdownMenuItem(value: e["value"], child: Text(e["label"]!));
                }).toList(),
                onChanged: (value) => setState(() => espece = value),
              ),
            ),

            const SizedBox(height: 16),

            // POIDS
            _buildCardWrapper(
              child: TextField(
                controller: poidsController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration("Poids total (kg)", Icons.scale_outlined),
              ),
            ),

            const SizedBox(height: 32),
            _buildSectionTitle("Traçabilité & Logistique"),
            const SizedBox(height: 16),

            // DATE PICKER
            _buildActionTile(
              label: dateRecolte == null ? "Date de récolte" : DateFormat('dd MMMM yyyy').format(dateRecolte!),
              icon: Icons.calendar_today_rounded,
              isSet: dateRecolte != null,
              onTap: pickDate,
            ),

            const SizedBox(height: 12),

            // GPS
            _buildActionTile(
              label: latitude == null ? "Localisation GPS" : "Position enregistrée",
              icon: Icons.location_on_outlined,
              isSet: latitude != null,
              onTap: getLocation,
            ),

            const SizedBox(height: 32),
            _buildSectionTitle("Observations"),
            const SizedBox(height: 16),

            // NOTES
            _buildCardWrapper(
              child: TextField(
                controller: notesController,
                maxLines: 4,
                decoration: _inputDecoration("Notes additionnelles...", Icons.edit_note_rounded),
              ),
            ),

            const SizedBox(height: 40),

            // BOUTON VALIDER
            ElevatedButton(
              onPressed: createLot,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F6B3F),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                elevation: 0,
              ),
              child: const Text(
                "Enregistrer le lot",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- UI HELPERS ---

  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
        color: Color(0xFF5C3A21),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildCardWrapper({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: child,
    );
  }

  Widget _buildActionTile({required String label, required IconData icon, required bool isSet, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        decoration: BoxDecoration(
          color: isSet ? const Color(0xFF2F6B3F).withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSet ? const Color(0xFF2F6B3F) : Colors.transparent),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSet ? const Color(0xFF2F6B3F) : Colors.grey),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSet ? FontWeight.bold : FontWeight.normal,
                color: isSet ? const Color(0xFF2F6B3F) : Colors.black87,
              ),
            ),
            const Spacer(),
            if (isSet) const Icon(Icons.check_circle, color: Color(0xFF2F6B3F))
            else const Icon(Icons.add_circle_outline, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: const Color(0xFF2F6B3F)),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      filled: true,
      fillColor: Colors.white,
      labelStyle: const TextStyle(color: Colors.grey),
      floatingLabelStyle: const TextStyle(color: Color(0xFF2F6B3F)),
    );
  }
}

