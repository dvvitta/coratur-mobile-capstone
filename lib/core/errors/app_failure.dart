/// Kegagalan domain yang aman untuk UI. Jangan menampilkan stack trace.
class AppFailure implements Exception {
  const AppFailure({
    required this.message,
    this.isRetryable = false,
    this.code,
  });

  final String message;
  final bool isRetryable;

  /// Kode mesin dari backend, mis. `EMAIL_NOT_CONFIRMED`.
  final String? code;

  @override
  String toString() => 'AppFailure($message)';
}
