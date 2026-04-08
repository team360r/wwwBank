import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/widgets.dart';

import '../app_state.dart';

// Only import web libraries when running on web
import 'postmessage_bridge_stub.dart'
    if (dart.library.js_interop) 'postmessage_bridge_web.dart' as platform;

class PostMessageBridge {
  PostMessageBridge(this._appState, this._navigatorKey) {
    if (kIsWeb) {
      platform.listenForMessages(_handleMessage);
    }
  }

  final AppState _appState;
  final GlobalKey<NavigatorState> _navigatorKey;

  void _handleMessage(String type, Map<String, dynamic> payload) {
    switch (type) {
      case 'navigate':
        final route = payload['route'] as String?;
        if (route != null && _navigatorKey.currentContext != null) {
          GoRouter.of(_navigatorKey.currentContext!).go(route);
        }
      case 'setAccessible':
        final accessible = payload['accessible'] as bool?;
        if (accessible != null) {
          _appState.setAccessible(accessible);
        }
      case 'toggleAccessible':
        _appState.toggleAccessible();
    }
  }

  void dispose() {
    if (kIsWeb) {
      platform.stopListening();
    }
  }
}
