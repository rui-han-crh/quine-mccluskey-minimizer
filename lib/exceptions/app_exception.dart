import 'package:equatable/equatable.dart';

class AppException with EquatableMixin implements Exception {
  final String _errorMessage;

  AppException(this._errorMessage);

  @override
  String toString() => _errorMessage;

  @override
  List<Object?> get props => [_errorMessage];
}
