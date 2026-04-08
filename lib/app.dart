import 'package:flutter/material.dart';

import 'app_state.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class WwwBankApp extends StatefulWidget {
  const WwwBankApp({super.key});

  @override
  State<WwwBankApp> createState() => _WwwBankAppState();
}

class _WwwBankAppState extends State<WwwBankApp> {
  final AppState _appState = AppState();
  late final _router = createRouter(_appState);

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'wwwBank',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: _router,
    );
  }
}
