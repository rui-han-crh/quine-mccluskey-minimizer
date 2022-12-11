import 'package:equatable/equatable.dart';

class AppException with EquatableMixin implements Exception {
  final String _errorMessage;

  AppException(this._errorMessage);

  String get errorMessage => _errorMessage;

  @override
  List<Object?> get props => [_errorMessage];
}
