// lib/app.dart
import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/dashboard/presentation/dashboard_page.dart';
import 'features/lots/presentation/pages/create_lot_page.dart';
import 'features/lots/presentation/pages/lot_detail_page.dart';
import 'features/lots/presentation/pages/lots_page.dart';
import 'features/qr/presentation/qr_result_page.dart';
import 'features/qr/presentation/qr_scanner_page.dart';
import 'features/transferts/presentation/pages/create_transfert_page.dart';
import 'features/transferts/presentation/pages/send_lot_page.dart';

class ChainCacaoApp extends StatelessWidget {
  const ChainCacaoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChainCacao',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/dashboard': (context) => const DashboardPage(),
        '/lots': (context) => const LotsPage(),
        '/lot-detail': (context) => const LotDetailPage(),
        '/create-lot': (context) => const CreateLotPage(),
        '/qr': (context) => const QrScannerPage(),
        '/qr-result': (context) => const QrResultPage(),
        '/send-lot': (context) => const SendLotPage(),
      },
    );
  }
}

