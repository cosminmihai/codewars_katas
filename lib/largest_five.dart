/// Largest 5 digit number in a series*

// In the following 6 digit number:
//
// 283910
// 91 is the greatest sequence of 2 consecutive digits.
//
// In the following 10 digit number:
//
// 1234567890
// 67890 is the greatest sequence of 5 consecutive digits.
//
// Complete the solution so that it returns the greatest sequence of
// five consecutive digits found within the number given.
// The number will be passed in as a string of only digits. It should return a five digit integer.
// The number passed may be as large as 1000 digits.

import 'package:test/test.dart';

void main() {
  test('Returns non-zero', () {
    expect(solution('543432345323542323577678'), isNonZero);
  });

  test('Returns correct in overlapping tests', () {
    expect(solution('731674765'), equals(74765));
  });
}

int solution(String digits) {
  final List<int> sequences = <int>[];
  for (int index = 0; index <= digits.length - 5; index++) {
    final String substring = digits.substring(index, index + 5);
    final int number = int.parse(substring);
    sequences.add(number);
  }

  sequences.sort();
  return sequences.last;
}
