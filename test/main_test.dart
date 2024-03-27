import 'package:flutter_test/flutter_test.dart';
import 'package:rabenkorb/main.dart';

void main() {
  testWidgets('MainApp displays "Hello World!"', (WidgetTester tester) async {
    await tester.pumpWidget(const MainApp());
    expect(find.text('Hello World!'), findsOneWidget);
  });
}
