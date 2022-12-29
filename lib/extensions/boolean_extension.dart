extension BooleanExtension on bool {
  int toInt() => this ? 1 : 0;

  bool invert() => !this;
}
