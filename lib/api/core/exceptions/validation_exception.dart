class ValidationException implements Exception {
  final Map<String, dynamic> errors;

  ValidationException(this.errors);

  @override
  String toString() => 'ValidationException: $errors';
}
