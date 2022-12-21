import 'package:sprintf/sprintf.dart';

extension StringExtension on String {
  /// Formats this string by replacing all `%s` with the values in the argument
  /// list by positional index
  String format(var args) => sprintf(this, args is Iterable ? args : [args]);

  /// Gets the character in the last index of this string
  String last() => this[length - 1];
}
