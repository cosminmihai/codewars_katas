/// Tribonacci Sequence

// Well met with Fibonacci bigger brother, AKA Tribonacci.
//
// As the name may already reveal, it works basically like a Fibonacci,
// but summing the last 3 (instead of 2) numbers of the sequence to generate the next.
//
// So, if we are to start our Tribonacci sequence with [1, 1, 1] as
// a starting input (AKA signature), we have this sequence:
//
// [1, 1 ,1, 3, 5, 9, 17, 31, ...]
// But what if we started with [0, 0, 1] as a signature? As starting with [0, 1] instead
// of [1, 1] basically shifts the common Fibonacci sequence by once place,
// you may be tempted to think that we would get the same sequence shifted by 2 places,
// but that is not the case and we would get:
//
// [0, 0, 1, 1, 2, 4, 7, 13, 24, ...]
// Well, you may have guessed it by now, but to be clear: you need to create a fibonacci
// function that given a signature array/list, returns the
// first n elements - signature included of the so seeded sequence.
//
// Signature will always contain 3 numbers; n will always be a non-negative number;
// if n == 0, then return an empty array (except in C return NULL)
// and be ready for anything else which is not clearly specified ;)

import 'package:test/test.dart';

void tester(List<num> sig, int n, List<num> exp) =>
    test('tribonacci($sig, $n)', () => expect(tribonacci(sig, n), equals(exp)));

void main() {
  group('Basic tests', () {
    tester(<int>[1, 1, 1], 10, <int>[1, 1, 1, 3, 5, 9, 17, 31, 57, 105]);
    tester(<int>[0, 0, 1], 10, <int>[0, 0, 1, 1, 2, 4, 7, 13, 24, 44]);
    tester(<int>[0, 1, 1], 10, <int>[0, 1, 1, 2, 4, 7, 13, 24, 44, 81]);
    tester(<int>[1, 0, 0], 10, <int>[1, 0, 0, 1, 1, 2, 4, 7, 13, 24]);
    tester(<int>[0, 0, 0], 10, <int>[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
    tester(<int>[1, 2, 3], 10, <int>[1, 2, 3, 6, 11, 20, 37, 68, 125, 230]);
    tester(<int>[3, 2, 1], 10, <int>[3, 2, 1, 6, 9, 16, 31, 56, 103, 190]);
    tester(<int>[1, 1, 1], 1, <int>[1, 1, 1]);
    tester(<int>[300, 200, 100], 0, <int>[]);
    tester(
        <double>[0.5, 0.5, 0.5],
        30,
        <double>[
          0.5,
          0.5,
          0.5,
          1.5,
          2.5,
          4.5,
          8.5,
          15.5,
          28.5,
          52.5,
          96.5,
          177.5,
          326.5,
          600.5,
          1104.5,
          2031.5,
          3736.5,
          6872.5,
          12640.5,
          23249.5,
          42762.5,
          78652.5,
          144664.5,
          266079.5,
          489396.5,
          900140.5,
          1655616.5,
          3045153.5,
          5600910.5,
          10301680.5
        ]);
  });
}

List<num> tribonacci(List<num> signature, int n) {
  if (n < 3) {
    return signature.sublist(0, n);
  }

  final List<num> sequence = <num>[...signature];
  int index = sequence.length - 1;
  while (index < n - 1) {
    final num left = sequence[index - 2];
    final num center = sequence[index - 1];
    final num right = sequence[index];
    sequence.add(right + left + center);
    index += 1;
  }

  return sequence;
}
