import 'package:proof_map/app_object.dart';
import 'package:proof_map/utils/linear_programming/expression_relation.dart';

class Expression extends AppObject {
  final List<double> _coefficients;
  final double _result;
  final ExpressionRelation _expressionRelation;

  List<double> get coefficients => _coefficients;
  double get result => _result;
  ExpressionRelation get relationship => _expressionRelation;

  Expression(this._coefficients, this._expressionRelation, this._result);

  @override
  String toString() {
    if (_expressionRelation == ExpressionRelation.greaterThanOrEqualsTo) {
      return "${_coefficients.join(" ")} >= $_result";
    } else if (_expressionRelation == ExpressionRelation.lessThanOrEqualsTo) {
      return "${_coefficients.join(" ")} <= $_result";
    } else {
      return "${_coefficients.join(" ")} = $_result";
    }
  }
}
