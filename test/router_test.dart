import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wwwbank/app_state.dart';
import 'package:wwwbank/router.dart';

void main() {
  testWidgets('redirects to /login when not logged in', (tester) async {
    final appState = AppState();
    final router = createRouter(appState);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(router.routeInformationProvider.value.uri.path, '/login');
  });

  testWidgets('redirects to / after login', (tester) async {
    final appState = AppState();
    final router = createRouter(appState);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    appState.login();
    await tester.pumpAndSettle();

    expect(router.routeInformationProvider.value.uri.path, '/');
  });
}
