import 'package:equatable/equatable.dart';
import 'package:proof_map/exceptions/app_exception.dart';

class TermNotFoundException extends AppException with EquatableMixin {
  TermNotFoundException(super.errorMessage);
}
