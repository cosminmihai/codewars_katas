/// TV Remote

// Background
// My TV remote control has arrow buttons and an OK button.
//
// I can use these to move a "cursor" on a logical screen keyboard to type "words"...
//
// The screen "keyboard" layout looks like this
//
// a	b	c	d	e	1	2	3
// f	g	h	i	j	4	5	6
// k	l	m	n	o	7	8	9
// p	q	r	s	t	.	@	0
// u	v	w	x	y	z	_	/
// Kata task
// How many button presses on my remote are required to type a given word?
//
// Notes
// The cursor always starts on the letter a (top left)
// Remember to also press OK to "accept" each character.
// Take a direct route from one character to the next
// The cursor does not wrap (e.g. you cannot leave one edge and reappear on the opposite edge)
// A "word" (for the purpose of this Kata) is any sequence of characters available on my virtual "keyboard"
// Example
// word = codewars
//
// c => a-b-c-OK = 3
// o => c-d-e-j-o-OK = 5
// d => o-j-e-d-OK = 4
// e => d-e-OK = 2
// w => e-j-o-t-y-x-w-OK = 7
// a => w-r-m-h-c-b-a-OK = 7
// r => a-f-k-p-q-r-OK = 6
// s => r-s-OK = 2
// Answer = 3 + 5 + 4 + 2 + 7 + 7 + 6 + 2 = 36

import 'package:test/test.dart';

void main() {
  test('Example', () {
    expect(tvRemote('codewars'), equals(36));
  });

  test('Misc', () {
    expect(tvRemote('does'), equals(16));
    expect(tvRemote('your'), equals(23));
    expect(tvRemote('solution'), equals(33));
    expect(tvRemote('work'), equals(20));
    expect(tvRemote('for'), equals(12));
    expect(tvRemote('these'), equals(27));
    expect(tvRemote('words'), equals(25));
  });
}

const int _okPressed = 1;
final List<List<String>> _keyboard = <List<String>>[
  <String>['a', 'b', 'c', 'd', 'e', '1', '2', '3'],
  <String>['f', 'g', 'h', 'i', 'j', '4', '5', '6'],
  <String>['k', 'l', 'm', 'n', 'o', '7', '8', '9'],
  <String>['p', 'q', 'r', 's', 't', '.', '@', '0'],
  <String>['u', 'v', 'w', 'x', 'y', 'z', '_', '/']
];

int tvRemote(String word) {
  int totalPresses = 0;
  String previousLetter = _keyboard[0][0];
  for (int index = 0; index < word.length; index++) {
    final String currentLetter = word[index];
    if (previousLetter == currentLetter) {
      totalPresses += _okPressed;
      continue;
    }

    final int presses = stepsBetweenTwoSymbols(previousLetter, currentLetter);
    totalPresses += presses + _okPressed;
    previousLetter = currentLetter;
  }

  return totalPresses;
}

int stepsBetweenTwoSymbols(String first, String second) {
  final List<int> firstCoordinate = getCoordinates(first);
  final List<int> secondCoordinate = getCoordinates(second);
  return (firstCoordinate[0] - secondCoordinate[0]).abs() + (firstCoordinate[1] - secondCoordinate[1]).abs();
}

List<int> getCoordinates(String symbol) {
  for (int row = 0; row < _keyboard.length; row++) {
    for (int column = 0; column < _keyboard[0].length; column++) {
      if (_keyboard[row][column] == symbol) {
        return <int>[row, column];
      }
    }
  }

  return <int>[-1, -1];
}
