import 'package:proof_map/model/answer.dart';

class MutableCombinationalStorage {
  Answer answer = const Answer.empty();
  String algebraicExpression = "";
  String mintermVariables = "";
  String maxtermVariables = "";
  List<String> termHeaders = [];
}
