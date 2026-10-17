/// Kegagalan domain yang aman untuk UI. Jangan menampilkan stack trace.
class AppFailure implements Exception {
  const AppFailure({required this.message, this.isRetryable = false});

  final String message;
  final bool isRetryable;

  @override
  String toString() => 'AppFailure($message)';
}
