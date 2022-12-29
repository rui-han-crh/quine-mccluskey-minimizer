/// Generates the [n]-bit Gray code.
Iterable<String> generateGreyCode(int n) {
  return Iterable.generate(1 << n, (i) => i ^ (i >> 1))
      .map((e) => e.toRadixString(2).padLeft(n, '0'));
}

/// Converts an integer to its Gray code.
int toGreyCode(int n) {
  return n ^ (n >> 1);
}

/// Converts a Gray code to its integer.
int fromGreyCode(int n) {
  int mask;
  for (mask = n >> 1; mask != 0; mask = mask >> 1) {
    n = n ^ mask;
  }
  return n;
}
