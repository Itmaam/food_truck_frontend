import 'dart:async';

class Debouncer<T> {
  final Duration delay;
  FutureOr<T> Function()? _callback;
  Timer? _timer;

  Debouncer(this.delay, Future<Null> Function() param1);

  Future<T> call(FutureOr<T> Function() callback) async {
    _callback = callback;
    _timer?.cancel();
    Completer<T> completer = Completer();
    _timer = Timer(delay, () async {
      if (_callback != null) {
        completer.complete(await _callback!());
      }
    });
    return completer.future;
  }
}
