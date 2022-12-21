import 'package:flutter_test/flutter_test.dart';
import 'package:proof_map/exceptions/invalid_argument_exception.dart';

void main() {
  test(
      "Given a message, when creating an InvalidArgumentException with that message, then produces an InvalidArgumentException with the correct message",
      () {
    // ARRANGE
    String message = "Invalid key";

    // ACT
    InvalidArgumentException invalidArgumentException =
        InvalidArgumentException(message);

    // ASSERT
    expect(invalidArgumentException.errorMessage, message);
  });
}
