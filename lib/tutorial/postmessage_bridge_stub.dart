void listenForMessages(void Function(String type, Map<String, dynamic> payload) handler) {
  // No-op on non-web platforms
}

void stopListening() {
  // No-op on non-web platforms
}
