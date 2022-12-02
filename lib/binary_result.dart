enum BinaryResult { binaryTrue, binaryFalse, binaryTrueOrFalse }

extension BinaryResultRepresentation on BinaryResult {
  String get representation {
    switch (this) {
      case BinaryResult.binaryTrue:
        return "1";
      case BinaryResult.binaryFalse:
        return "0";
      case BinaryResult.binaryTrueOrFalse:
        return "-";
      default:
        return "?";
    }
  }
}
