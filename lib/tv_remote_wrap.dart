/// TV Remote (wrap)

// Background
// My TV remote control has arrow buttons and an OK button.
//
// I can use these to move a "cursor" on a logical screen keyboard to type words...
//
// Keyboard
// The screen "keyboard" layout looks like this
//
// a	b	c	d	e	1	2	3
// f	g	h	i	j	4	5	6
// k	l	m	n	o	7	8	9
// p	q	r	s	t	.	@	0
// u	v	w	x	y	z	_	/
// aA	SP
// aA is the SHIFT key. Pressing this key toggles alpha characters between UPPERCASE and lowercase
// SP is the space character
// The other blank keys in the bottom row have no function
// Kata task
// How many button presses on my remote are required to type the given words?
//
// Hint
// This Kata is an extension of the earlier ones in this series. You should complete those first.
//
// Notes
// The cursor always starts on the letter a (top left)
// The alpha characters are initially lowercase (as shown above)
// Remember to also press OK to "accept" each letter
// Take the shortest route from one letter to the next
// The cursor wraps, so as it moves off one edge it will reappear on the opposite edge
// Although the blank keys have no function, you may navigate through them if you want to
// Spaces may occur anywhere in the words string
// Do not press the SHIFT key until you need to. For example, with the word e.Z,
// the SHIFT change happens after the . is pressed (not before)
// Example
// words = Code Wars
//
// C => a-aA-OK-A-B-C-OK = 6
// o => C-B-A-aA-OK-u-v-w-x-y-t-o-OK = 12
// d => o-j-e-d-OK = 4
// e => d-e-OK = 2
// space => e-d-c-b-SP-OK = 5
// W => SP-aA-OK-SP-V-W-OK = 6
// a => W-V-U-aA-OK-a-OK = 6
// r => a-f-k-p-q-r-OK = 6
// s => r-s-OK = 2
// Answer = 6 + 12 + 4 + 2 + 5 + 6 + 6 + 6 + 2 = 49

import 'dart:math';

import 'package:test/test.dart';

void main() {
  test('Example', () {
    expect(tvRemote('Code Wars'), equals(49));
  });

  test('Lower', () {
    expect(tvRemote('does'), equals(16));
    expect(tvRemote('your'), equals(21));
    expect(tvRemote('solution'), equals(33));
    expect(tvRemote('work'), equals(18));
    expect(tvRemote('for'), equals(12));
    expect(tvRemote('these'), equals(27));
    expect(tvRemote('words'), equals(23));
  });

  test('Upper', () {
    expect(tvRemote('DOES'), equals(19));
    expect(tvRemote('YOUR'), equals(22));
    expect(tvRemote('SOLUTION'), equals(34));
    expect(tvRemote('WORK'), equals(19));
    expect(tvRemote('FOR'), equals(15));
    expect(tvRemote('THESE'), equals(28));
    expect(tvRemote('WORDS'), equals(24));
  });
  test('Mixed', () {
    expect(tvRemote('Does'), equals(28));
    expect(tvRemote('Your'), equals(33));
    expect(tvRemote('Solution'), equals(45));
    expect(tvRemote('Work'), equals(26));
    expect(tvRemote('For'), equals(20));
    expect(tvRemote('These'), equals(35));
    expect(tvRemote('Words'), equals(31));
  });
}

List<List<String>> keyboard = <List<String>>[
  <String>['a', 'b', 'c', 'd', 'e', '1', '2', '3'],
  <String>['f', 'g', 'h', 'i', 'j', '4', '5', '6'],
  <String>['k', 'l', 'm', 'n', 'o', '7', '8', '9'],
  <String>['p', 'q', 'r', 's', 't', '.', '@', '0'],
  <String>['u', 'v', 'w', 'x', 'y', 'z', '_', '/'],
  <String>['aA', ' ', '-1', '-1', '-1', '-1', '-1', '-1'],
];

int tvRemote(String word) {
  int totalSteps = 0;
  bool isUpperCaseActive = false;
  String previousSymbol = keyboard[0][0];

  for (final String symbol in word.split('')) {
    if (!isUpperCaseActive && isCapitalLetter(symbol) || isUpperCaseActive && isLowerLetter(symbol)) {
      const String shift = 'aA';
      isUpperCaseActive = !isUpperCaseActive;
      totalSteps += calculateSteps(previousSymbol, shift);
      previousSymbol = shift;
    }

    totalSteps += calculateSteps(previousSymbol, symbol);
    previousSymbol = symbol;
  }

  return totalSteps;
}

bool isCapitalLetter(String symbol) {
  return symbol.startsWith(RegExp('[A-Z]'));
}

bool isLowerLetter(String symbol) {
  return symbol.startsWith(RegExp('[a-z]'));
}

int calculateSteps(String startingSymbol, String endingSymbol) {
  final String firstLowerCase = startingSymbol == 'aA' ? startingSymbol : startingSymbol.toLowerCase();
  final String secondLowerCase = endingSymbol == 'aA' ? endingSymbol : endingSymbol.toLowerCase();
  final List<int> firstCoordinate = getCoordinates(firstLowerCase);
  final List<int> secondCoordinate = getCoordinates(secondLowerCase);

  final int rowDifference = (firstCoordinate[0] - secondCoordinate[0]).abs();
  final int columnDifference = (firstCoordinate[1] - secondCoordinate[1]).abs();
  final int rowSteps = min(rowDifference, 6 - rowDifference);
  final int columnSteps = min(columnDifference, 8 - columnDifference);

  return rowSteps + columnSteps + 1;
}

List<int> getCoordinates(String symbol) {
  final int row = keyboard.indexWhere((List<String> row) => row.contains(symbol));
  final int column = keyboard[row].indexOf(symbol);
  return <int>[row, column];
}
