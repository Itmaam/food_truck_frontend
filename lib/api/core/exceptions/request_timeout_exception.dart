class RequestTimeoutException implements Exception {
  final String message;
  RequestTimeoutException({required this.message});
  @override
  String toString() {
    return message;
  }
}
