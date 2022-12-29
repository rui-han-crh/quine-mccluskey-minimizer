import 'package:equatable/equatable.dart';
import 'package:proof_map/exceptions/app_exception.dart';

class TooManyIterationsException extends AppException with EquatableMixin {
  TooManyIterationsException(super.errorMessage);
}
