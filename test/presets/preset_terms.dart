import 'package:proof_map/model/literal_term.dart';
import 'preset_variables.dart' as preset;

final LiteralTerm termA = LiteralTerm(preset.a, preset.notA);
final LiteralTerm termNotA = termA.negate();

final LiteralTerm termB = LiteralTerm(preset.b, preset.notB);
final LiteralTerm termNotB = termB.negate();

final LiteralTerm termC = LiteralTerm(preset.c, preset.notC);
final LiteralTerm termNotC = termC.negate();

final LiteralTerm termD = LiteralTerm(preset.d, preset.notD);
final LiteralTerm termNotD = termD.negate();

final LiteralTerm termE = LiteralTerm(preset.e, preset.notE);
final LiteralTerm termNotE = termE.negate();
