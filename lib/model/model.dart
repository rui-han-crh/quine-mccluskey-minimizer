import 'package:proof_map/app_object.dart';
import 'package:proof_map/model/parser.dart';

class Model extends AppObject {
  Parser _parser;

  Model(this._parser);

  Future<String> simplifyBooleanExpression(String expression) async {
    return _parser.toBooleanExpression(expression).simplify().statement;
  }
}
