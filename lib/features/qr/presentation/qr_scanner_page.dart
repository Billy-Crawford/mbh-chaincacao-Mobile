// lib/features/qr/presentation/qr_scanner_page.dart
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../data/qr_mock_service.dart';

class QrScannerPage extends StatefulWidget {
  const QrScannerPage({super.key});

  @override
  State<QrScannerPage> createState() => _QrScannerPageState();
}

class _QrScannerPageState extends State<QrScannerPage> {
  final service = QrMockService();
  bool isProcessing = false;

  void handleScan(String code) async {
    if (isProcessing) return;
    isProcessing = true;

    try {
      final result = await service.verifyQr(code);

      if (!mounted) return;

      Navigator.pushNamed(
        context,
        '/qr-result',
        arguments: result,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    isProcessing = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scanner QR"),
        backgroundColor: const Color(0xFF5C3A21),
      ),
      body: MobileScanner(
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;

          if (barcodes.isEmpty) return;

          final String? code = barcodes.first.rawValue;

          if (code != null) {
            handleScan(code);
          }
        },
      ),
    );
  }
}