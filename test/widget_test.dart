import 'package:chaincacao_mobile/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const ChainCacaoApp());

    expect(find.text('ChainCacao Mobile Ready'), findsOneWidget);
  });
}