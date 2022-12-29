Iterable<Set<T>> setCoverApproximation<T>(Iterable<Set<T>> sets) {
  Set<T> includedSoFar = {};
  Set<T> universe = sets.expand((e) => e).toSet();
  List<Set<T>> result = [];

  while (!includedSoFar.containsAll(universe)) {
    double minCost = double.infinity;
    Set<T>? minimumSet;
    for (Set<T> set in sets) {
      double cost = 1.0 / set.difference(includedSoFar).length;
      if (cost < minCost) {
        minCost = cost;
        minimumSet = set;
      }
    }
    result.add(minimumSet!);
    includedSoFar.addAll(minimumSet);
  }
  return result;
}
