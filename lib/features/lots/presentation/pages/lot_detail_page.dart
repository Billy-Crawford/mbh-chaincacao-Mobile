// lib/features/lots/presentation/pages/lot_detail_page.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class LotDetailPage extends StatelessWidget {
  const LotDetailPage({super.key});

  /// 📄 Génération PDF avec QR code + infos lot
  Future<Uint8List> _generatePdf(Map lot) async {
    final pdf = pw.Document();

    Uint8List? qrImageBytes;

    // 🔥 récupération image QR depuis backend
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

                pw.Text(
                  "CERTIFICAT DE LOT",
                  style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),

                pw.SizedBox(height: 20),

                pw.Text("ID: ${lot["id"] ?? ""}"),
                pw.Text("Espèce: ${lot["espece"] ?? ""}"),
                pw.Text("Poids: ${lot["poids_kg"] ?? ""} kg"),
                pw.Text("Statut: ${lot["statut"] ?? ""}"),
                pw.Text("Date récolte: ${lot["date_recolte"] ?? ""}"),

                pw.SizedBox(height: 10),

                pw.Text(
                  "GPS: ${lot["gps_latitude"] ?? ""}, ${lot["gps_longitude"] ?? ""}",
                ),

                pw.SizedBox(height: 20),

                pw.Text("Notes: ${lot["notes"] ?? ""}"),

                pw.SizedBox(height: 30),

                if (qrImageBytes != null)
                  pw.Center(
                    child: pw.Image(
                      pw.MemoryImage(qrImageBytes),
                      height: 180,
                    ),
                  )
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

            // QR CODE
            if (lot["qr_code_url"] != null)
              Center(
                child: Image.network(
                  lot["qr_code_url"],
                  height: 200,
                ),
              )
            else
              const Text("QR Code non disponible"),

            const SizedBox(height: 20),

            // 📄 BUTTON PDF
            ElevatedButton.icon(
              icon: const Icon(Icons.picture_as_pdf),
              label: const Text("Télécharger QR en PDF"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                final pdfData = await _generatePdf(lot);

                await Printing.sharePdf(
                  bytes: pdfData,
                  filename: "lot_${lot["id"]}.pdf",
                );
              },
            ),

            ElevatedButton.icon(
              icon: const Icon(Icons.send),
              label: const Text("Envoyer à une coopérative"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/send-lot',
                  arguments: lot,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

