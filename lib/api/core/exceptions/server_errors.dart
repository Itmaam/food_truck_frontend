class ServerConnectionError implements Exception {
  final String message;
  ServerConnectionError({required this.message});
  @override
  String toString() {
    return message;
  }
}
