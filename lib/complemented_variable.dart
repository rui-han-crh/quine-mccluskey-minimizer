import 'package:proof_map/exceptions/already_initialised_exception.dart';
import 'package:proof_map/exceptions/not_yet_initialised_exception.dart';
import 'package:proof_map/variable.dart';

import 'messages.dart';

class ComplementedVariable extends Variable {
  late Variable _negation;
  bool isNegationSet = false;

  /// Retrieves the negated form of the variable only if it is set, otherwise a
  ///  NotInitialisedException will be thrown
  Variable get negation {
    if (!isNegationSet) {
      throw NotInitialisedException(Messages.negationNotSet);
    }
    return _negation;
  }

  /// Sets the negated form of the variable only if it is not set,
  /// otherwise an AlreadyInitialisedException will be thrown
  set negation(Variable negatedForm) {
    if (!isNegationSet) {
      isNegationSet = true;
      _negation = negatedForm;
    } else {
      throw AlreadyInitialisedException(Messages.negationAlreadySet);
    }
  }

  /// Constructs a complemented variable, with the negated form unset
  ComplementedVariable(super.statement);

  /// Constructs a complemented variable with an existing variable serving as
  /// the negated form
  ComplementedVariable.withNegation(super.statement, this._negation)
      : isNegationSet = true;
}
