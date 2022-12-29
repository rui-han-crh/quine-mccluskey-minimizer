import 'package:flutter_test/flutter_test.dart';
import 'package:proof_map/utils/greedy_set_cover.dart';

void main() {
  test(
      '''Given 
  S1 = {4, 1, 3},
  S2 = {2, 5},
  S3 = {1, 4, 3, 2},
  when computed with greedy set cover approximation, 
  then produces the set cover {S1, S2}
  ''',
      () async {
    // ARRANGE
    Set<int> s1 = {4, 1, 3};
    Set<int> s2 = {2, 5};
    Set<int> s3 = {1, 4, 3, 2};

    // ACT
    Iterable<Iterable<int>> result = setCoverApproximation([s1, s2, s3]);

    // ASSERT
    expect(result.toSet(), {s2, s3});
  });

  test(
      '''Given 
    S1 = {1, 2}
    S2 = {2, 3, 4, 5}
    S3 = {6, 7, 8, 9, 10, 11, 12, 13}
    S4 = {1, 3, 5, 7, 9, 11, 13}
    S5 = {2, 4, 6, 8, 10, 12, 13}
  when computed with greedy set cover approximation, 
  then produces the set cover {S1, S2, S3}
  ''',
      () async {
    // ARRANGE
    Set<int> s1 = {1, 2};
    Set<int> s2 = {2, 3, 4, 5};
    Set<int> s3 = {6, 7, 8, 9, 10, 11, 12, 13};
    Set<int> s4 = {1, 3, 5, 7, 9, 11, 13};
    Set<int> s5 = {2, 4, 6, 8, 10, 12, 13};

    // ACT
    Iterable<Iterable<int>> result =
        setCoverApproximation([s1, s2, s3, s4, s5]);

    // ASSERT
    expect(result.toSet(), {s1, s2, s3});
    // this is not the optimal solution, the optimal solution is {s4, s5}
  });
}
