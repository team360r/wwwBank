import 'dart:js_interop';
import 'package:web/web.dart' as web;

void Function(String, Map<String, dynamic>)? _handler;
void Function(web.Event)? _dartListener;

void listenForMessages(void Function(String type, Map<String, dynamic> payload) handler) {
  _handler = handler;
  _dartListener = (web.Event event) {
    if (event is! web.MessageEvent) return;
    final messageEvent = event;
    final data = messageEvent.data;
    if (data == null) return;

    // Convert JSAny to Dart map
    try {
      final dartObj = data.dartify();
      if (dartObj is! Map) return;
      final map = Map<String, dynamic>.from(dartObj);

      final source = map['source'] as String?;
      if (source != 'wwwbank-tutorial') return;

      final type = map['type'] as String?;
      if (type == null) return;

      _handler?.call(type, map);
    } catch (_) {
      // Ignore malformed messages
    }
  };
  web.window.addEventListener('message', _dartListener!.toJS);
}

void stopListening() {
  if (_dartListener != null) {
    web.window.removeEventListener('message', _dartListener!.toJS);
    _dartListener = null;
  }
  _handler = null;
}
