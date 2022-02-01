import 'dart:math';

import 'package:test/test.dart';

void main() {
  print(isOverlapping(<int>[1, 5], <int>[1, 5]));

  test('Testing for [[384, 406], [-312, -310], [223, 247], [69, 157], [220, 323], [-11, 115], [309, 441], [-125, 444]]',
      () {
    expect(
        sumOfIntervals(<List<int>>[
          <int>[384, 406],
          <int>[-312, -310],
          <int>[223, 247],
          <int>[69, 157],
          <int>[220, 323],
          <int>[-11, 115],
          <int>[309, 441],
          <int>[-125, 444]
        ]),
        equals(571));
  });

  test('Testing for [[1, 5]]', () {
    expect(
        sumOfIntervals(<List<int>>[
          <int>[1, 5]
        ]),
        equals(4));
  });

  test('Testing for [[1, 5]]', () {
    expect(
        sumOfIntervals(<List<int>>[
          <int>[1, 5]
        ]),
        equals(4));
  });
  test('Testing for [[1, 5], [6, 10]]', () {
    expect(
        sumOfIntervals(<List<int>>[
          <int>[1, 5],
          <int>[6, 10]
        ]),
        equals(8));
  });
  test('Testing for [[1, 5], [10, 15], [-1, 3]]', () {
    expect(
        sumOfIntervals(<List<int>>[
          <int>[1, 5],
          <int>[10, 15],
          <int>[-1, 3]
        ]),
        equals(11));
  });
  test('Testing for [[1, 5], [1, 5]]', () {
    expect(
        sumOfIntervals(<List<int>>[
          <int>[1, 5],
          <int>[1, 5]
        ]),
        equals(4));
  });
  test('Testing for [[1, 4], [7, 10], [3, 5]]', () {
    expect(
        sumOfIntervals(<List<int>>[
          <int>[1, 4],
          <int>[7, 10],
          <int>[3, 5]
        ]),
        equals(7));
  });
}

int sumOfIntervals(List<List<int>> intervals) {
  List<List<int>> filtered = filterOverlapping(intervals);
  // Eliminate any complete overlapped intervals
  filtered = filterOverlapping(filtered);

  return filtered.fold(0, (int previousValue, List<int> element) {
    final int length = (element[0] - element[1]).abs();
    return previousValue + length;
  });
}

List<List<int>> filterOverlapping(List<List<int>> intervals) {
  final List<List<int>> filtered = <List<int>>[];
  for (final List<int> interval in intervals) {
    final int index = filtered.indexWhere((List<int> item) => isOverlapping(item, interval));
    if (index != -1) {
      filtered[index] = concatenateIntervals(filtered[index], interval);
    } else {
      filtered.add(interval);
    }
  }

  return filtered;
}

List<int> concatenateIntervals(List<int> first, List<int> second) {
  return <int>[min(first[0], second[0]), max(first[1], second[1])];
}

bool isOverlapping(List<int> first, List<int> second) {
  final bool firstOverlapSecond =
      first[0] >= second[0] && first[0] <= second[1] || first[1] <= second[1] && first[1] >= second[0];
  final bool secondOverlapFirst =
      second[0] >= first[0] && second[0] <= first[1] || second[1] <= first[1] && second[1] >= first[0];
  return firstOverlapSecond || secondOverlapFirst;
}
