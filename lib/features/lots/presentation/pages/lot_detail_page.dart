// lib/features/lots/presentation/pages/lot_detail_page.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class LotDetailPage extends StatelessWidget {
  const LotDetailPage({super.key});

  /// 📄 Génération PDF avec QR code + infos lot (Logique métier préservée)
  Future<Uint8List> _generatePdf(Map lot) async {
    final pdf = pw.Document();
    Uint8List? qrImageBytes;

    if (lot["qr_code_url"] != null) {
      try {
        final response = await http.get(Uri.parse(lot["qr_code_url"]));
        if (response.statusCode == 200) {
          qrImageBytes = response.bodyBytes;
        }
      } catch (_) {
        qrImageBytes = null;
      }
    }

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text("CERTIFICAT DE LOT",
                    style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Text("ID: ${lot["id"] ?? ""}"),
                pw.Text("Espèce: ${lot["espece"] ?? ""}"),
                pw.Text("Poids: ${lot["poids_kg"] ?? ""} kg"),
                pw.Text("Statut: ${lot["statut"] ?? ""}"),
                pw.Text("Date récolte: ${lot["date_recolte"] ?? ""}"),
                pw.SizedBox(height: 10),
                pw.Text("GPS: ${lot["gps_latitude"] ?? ""}, ${lot["gps_longitude"] ?? ""}"),
                pw.SizedBox(height: 20),
                pw.Text("Notes: ${lot["notes"] ?? ""}"),
                pw.SizedBox(height: 30),
                if (qrImageBytes != null)
                  pw.Center(child: pw.Image(pw.MemoryImage(qrImageBytes), height: 180))
                else
                  pw.Text("QR Code non disponible"),
              ],
            ),
          );
        },
      ),
    );
    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    final lot = ModalRoute.of(context)!.settings.arguments as Map;

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
        title: Text(
          "Lot #${lot["id"]}",
          style: const TextStyle(color: Color(0xFF5C3A21), fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- CARTE PRINCIPALE DES INFOS ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, 5)),
                ],
              ),
              child: Column(
                children: [
                  _infoRow(Icons.category_outlined, "Espèce", lot["espece"].toString().toUpperCase()),
                  const Divider(height: 30),
                  _infoRow(Icons.scale_outlined, "Poids", "${lot["poids_kg"]} kg"),
                  const Divider(height: 30),
                  _infoRow(Icons.event_note_outlined, "Récolte", lot["date_recolte"].toString()),
                  const Divider(height: 30),
                  _infoRow(Icons.location_on_outlined, "Position GPS", "${lot["gps_latitude"]}, ${lot["gps_longitude"]}"),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- SECTION NOTES ---
            const Text("  Notes additionnelles", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF5C3A21))),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12),
              ),
              child: Text(
                (lot["notes"] == null || lot["notes"].isEmpty) ? "Aucune note pour ce lot." : lot["notes"],
                style: const TextStyle(color: Colors.black87, height: 1.4),
              ),
            ),

            const SizedBox(height: 30),

            // --- SECTION QR CODE / CERTIFICAT ---
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF2F6B3F).withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    if (lot["qr_code_url"] != null)
                      Image.network(lot["qr_code_url"], height: 180)
                    else
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text("QR Code non disponible", style: TextStyle(color: Colors.grey)),
                      ),
                    const SizedBox(height: 10),
                    const Text("Certificat de Traçabilité", style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2F6B3F))),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // --- ACTIONS ---
            ElevatedButton.icon(
              icon: const Icon(Icons.picture_as_pdf_outlined),
              label: const Text("TÉLÉCHARGER LE CERTIFICAT PDF"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5C3A21),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              onPressed: () async {
                final pdfData = await _generatePdf(lot);
                await Printing.sharePdf(bytes: pdfData, filename: "lot_${lot["id"]}.pdf");
              },
            ),

            const SizedBox(height: 12),

            ElevatedButton.icon(
              icon: const Icon(Icons.send_rounded),
              label: const Text("ENVOYER À UNE COOPÉRATIVE"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2F6B3F),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/send-lot', arguments: lot);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget Helper pour les lignes d'information
  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFFF6F1E7), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: const Color(0xFF5C3A21), size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF2E1E12))),
          ],
        ),
      ],
    );
  }
}

