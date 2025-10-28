sealed class Result<T> {}

class Failure<_> extends Result {
  final String message;
  Failure(this.message);
}

class Success<T> extends Result<T> {
  final T data;
  final String? message;
  Success(this.data, [this.message]);
}
