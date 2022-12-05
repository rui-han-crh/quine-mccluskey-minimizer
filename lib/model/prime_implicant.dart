import 'package:proof_map/model/implicant.dart';

abstract class PrimeImplicant extends Implicant {
  Iterable<int> get coveredMintermIndices;
}
