import 'package:flutter_test/flutter_test.dart';
import 'package:pos_retail_pro/main.dart';

void main() {
  testWidgets('App starts on the splash screen', (tester) async {
    await tester.pumpWidget(const PosApp());
    expect(find.text('POS Retail Pro'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}
