import 'package:sprintf/sprintf.dart';

extension StringFormatExtension on String {
  String format(var args) => sprintf(this, args is Iterable ? args : [args]);
}
