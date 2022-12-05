import 'package:equatable/equatable.dart';

import '../app_object.dart';

class Variable extends AppObject with EquatableMixin {
  final String _statement;

  @override
  List<Object?> get props => [_statement];

  /// Defines how to express this variable in words
  String get statement => _statement;

  /// Creates a new variables defined by the statement
  const Variable(this._statement) : super();
}
