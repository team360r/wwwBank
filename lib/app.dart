import 'package:flutter/material.dart';

import 'app_state.dart';
import 'router.dart';
import 'theme/app_theme.dart';
import 'tutorial/postmessage_bridge.dart';

class WwwBankApp extends StatefulWidget {
  const WwwBankApp({super.key});

  @override
  State<WwwBankApp> createState() => _WwwBankAppState();
}

class _WwwBankAppState extends State<WwwBankApp> {
  final AppState _appState = AppState();
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final _router = createRouter(_appState, navigatorKey: _navigatorKey);
  late final PostMessageBridge _bridge;

  @override
  void initState() {
    super.initState();
    _bridge = PostMessageBridge(_appState, _navigatorKey);
  }

  @override
  void dispose() {
    _bridge.dispose();
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
