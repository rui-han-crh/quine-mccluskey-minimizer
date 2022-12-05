enum BinaryValue { binaryOne, binaryZero, redundant }

extension BinaryResultRepresentation on BinaryValue {
  String get representation {
    switch (this) {
      case BinaryValue.binaryOne:
        return "1";
      case BinaryValue.binaryZero:
        return "0";
      case BinaryValue.redundant:
        return "-";
      default:
        return "?";
    }
  }
}
