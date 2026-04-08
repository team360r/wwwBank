import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_state.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/login/login_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/transactions/transactions_screen.dart';
import 'screens/transfer/transfer_screen.dart';
import 'widgets/wwwbank_scaffold.dart';

GoRouter createRouter(AppState appState) {
  return GoRouter(
    refreshListenable: appState,
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = appState.isLoggedIn;
      final isLoginRoute = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoginRoute) return '/login';
      if (isLoggedIn && isLoginRoute) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(
          accessible: appState.accessible,
          onLogin: appState.login,
        ),
      ),
      ShellRoute(
        builder: (context, state, child) => ListenableBuilder(
          listenable: appState,
          builder: (context, _) {
            final index = _indexFromLocation(state.matchedLocation);
            return WwwBankScaffold(
              accessible: appState.accessible,
              currentIndex: index,
              onTabChanged: (i) => _navigateToTab(context, i),
              onToggleAccessible: appState.toggleAccessible,
              body: child,
            );
          },
        ),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => DashboardScreen(
              accessible: appState.accessible,
            ),
          ),
          GoRoute(
            path: '/transactions',
            builder: (context, state) => TransactionsScreen(
              accessible: appState.accessible,
            ),
          ),
          GoRoute(
            path: '/transfer',
            builder: (context, state) => TransferScreen(
              accessible: appState.accessible,
            ),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => SettingsScreen(
              accessible: appState.accessible,
              appState: appState,
            ),
          ),
        ],
      ),
    ],
  );
}

int _indexFromLocation(String location) {
  return switch (location) {
    '/' => 0,
    '/transactions' => 1,
    '/transfer' => 2,
    '/settings' => 3,
    _ => 0,
  };
}

void _navigateToTab(BuildContext context, int index) {
  final path = switch (index) {
    0 => '/',
    1 => '/transactions',
    2 => '/transfer',
    3 => '/settings',
    _ => '/',
  };
  context.go(path);
}
