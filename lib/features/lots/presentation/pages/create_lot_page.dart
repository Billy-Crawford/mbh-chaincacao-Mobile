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
        const SnackBar(content: Text("Complète tous les champs")),
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
      appBar: AppBar(
        title: const Text("Créer un lot"),
        backgroundColor: const Color(0xFF5C3A21),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [

            // ESPÈCE
            DropdownButtonFormField<String>(
              value: espece,
              items: especes.map((e) {
                return DropdownMenuItem(
                  value: e["value"],
                  child: Text(e["label"]!),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => espece = value);
              },
              decoration: const InputDecoration(
                labelText: "Espèce",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // POIDS
            TextField(
              controller: poidsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Poids (kg)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 15),

            // DATE
            ListTile(
              title: Text(dateRecolte == null
                  ? "Choisir date récolte"
                  : DateFormat('yyyy-MM-dd').format(dateRecolte!)),
              trailing: const Icon(Icons.calendar_today),
              onTap: pickDate,
            ),

            const SizedBox(height: 15),

            // GPS
            ElevatedButton.icon(
              onPressed: getLocation,
              icon: const Icon(Icons.location_on),
              label: Text(
                latitude == null
                    ? "Récupérer ma position GPS"
                    : "Position capturée",
              ),
            ),

            const SizedBox(height: 15),

            // NOTES
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: "Notes",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: createLot,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F6B3F),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Créer le lot"),
            ),
          ],
        ),
      ),
    );
  }
}
