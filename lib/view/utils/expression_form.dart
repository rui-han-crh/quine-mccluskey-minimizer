import 'package:flutter/foundation.dart';

enum ExpressionForm { algebraic, minterms, maxterms }

extension ExpressionFormName on ExpressionForm {
  String get name => describeEnum(this).replaceAllMapped(
      RegExp(r'^([a-z])|[A-Z]'),
      (Match m) => m[1] == null ? " ${m[0]}" : m[1]!.toUpperCase());
}
