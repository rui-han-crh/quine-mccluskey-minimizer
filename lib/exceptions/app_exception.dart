class AppException implements Exception {
  final String _errorMessage;

  AppException(this._errorMessage);

  @override
  String toString() => _errorMessage;
}
