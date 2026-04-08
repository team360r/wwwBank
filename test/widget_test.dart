import 'package:flutter_test/flutter_test.dart';

import 'package:wwwbank/app.dart';

void main() {
  testWidgets('app renders login screen when not logged in', (WidgetTester tester) async {
    await tester.pumpWidget(const WwwBankApp());
    await tester.pumpAndSettle();

    expect(find.text('wwwBank'), findsOneWidget);
    expect(find.text('Sign in to your account'), findsOneWidget);
  });
}
