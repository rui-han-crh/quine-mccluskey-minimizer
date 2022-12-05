import 'package:proof_map/model/literal_term.dart';
import 'preset_variables.dart' as preset;

final LiteralTerm termA = LiteralTerm(preset.a, preset.notA);
final LiteralTerm termNotA = termA.negate() as LiteralTerm;

final LiteralTerm termB = LiteralTerm(preset.b, preset.notB);
final LiteralTerm termNotB = termB.negate() as LiteralTerm;

final LiteralTerm termC = LiteralTerm(preset.c, preset.notC);
final LiteralTerm termNotC = termC.negate() as LiteralTerm;

final LiteralTerm termD = LiteralTerm(preset.d, preset.notD);
final LiteralTerm termNotD = termD.negate() as LiteralTerm;
