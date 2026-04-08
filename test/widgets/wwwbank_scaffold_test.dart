import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wwwbank/widgets/wwwbank_scaffold.dart';

void main() {
  Widget buildScaffold({double width = 800}) {
    return MaterialApp(
      home: MediaQuery(
        data: MediaQueryData(size: Size(width, 600)),
        child: WwwBankScaffold(
          accessible: true,
          currentIndex: 0,
          onTabChanged: (_) {},
          onToggleAccessible: () {},
          body: const Text('Content'),
        ),
      ),
    );
  }

  testWidgets('shows NavigationRail on wide screens', (tester) async {
    await tester.pumpWidget(buildScaffold(width: 800));
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('shows NavigationBar on narrow screens', (tester) async {
    await tester.pumpWidget(buildScaffold(width: 500));
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
  });

  testWidgets('shows app title in AppBar', (tester) async {
    await tester.pumpWidget(buildScaffold());
    expect(find.text('wwwBank'), findsOneWidget);
  });

  testWidgets('shows accessibility toggle button', (tester) async {
    await tester.pumpWidget(buildScaffold());
    expect(find.byIcon(Icons.accessibility_new), findsOneWidget);
  });
}
