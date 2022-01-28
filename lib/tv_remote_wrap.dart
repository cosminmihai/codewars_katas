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

import 'package:test/test.dart';

void main() {
  test('Example', () {
    expect(tvRemote('Code Wars'), equals(49));
  });

/*  test('Lower', () {
    expect(tv_remote('does'), equals(16));
    expect(tv_remote('your'), equals(21));
    expect(tv_remote('solution'), equals(33));
    expect(tv_remote('work'), equals(18));
    expect(tv_remote('for'), equals(12));
    expect(tv_remote('these'), equals(27));
    expect(tv_remote('words'), equals(23));
  });

  test('Upper', () {
    expect(tv_remote('DOES'), equals(19));
    expect(tv_remote('YOUR'), equals(22));
    expect(tv_remote('SOLUTION'), equals(34));
    expect(tv_remote('WORK'), equals(19));
    expect(tv_remote('FOR'), equals(15));
    expect(tv_remote('THESE'), equals(28));
    expect(tv_remote('WORDS'), equals(24));
  });

  test('Mixed', () {
    expect(tv_remote('Does'), equals(28));
    expect(tv_remote('Your'), equals(33));
    expect(tv_remote('Solution'), equals(45));
    expect(tv_remote('Work'), equals(26));
    expect(tv_remote('For'), equals(20));
    expect(tv_remote('These'), equals(35));
    expect(tv_remote('Words'), equals(31));
  });*/
}

const int _okPressed = 1;

int tvRemote(String word) {
  int totalSteps = 0;
  bool capitalActive = false;
  String previousSymbol = keyboard[0][0];

  for (int index = 0; index < word.length; index++) {
    final String symbol = word[index];
    if (previousSymbol == symbol) {
      totalSteps += _okPressed;
      continue;
    }

    int steps;
    if (isCapitalAndLetter(symbol)) {
      steps = calculateSteps(symbol, 'aA') + (capitalActive ? 0 : 1);
      capitalActive = true;
    } else if (symbol == ' ') {
      steps = calculateSteps(symbol, 'SP');
    } else {
      capitalActive =
      steps = calculateSteps(previousSymbol, symbol);
    }

    totalSteps += steps + _okPressed;
    previousSymbol = symbol;
  }

  return totalSteps;
}

// q -> 0 ==> q(4, 2), 0(4, 8) -> 2 steps with wrap
//                             -> 6 steps without wrap
// v -> @ ==> v(5, 2), @(4,7) -> 6 without wrap
//                            -> 4 with wrap

// Applies when both x or y are 2 steps from wall
// v(5, 2) - 7(3, 6) => (5 - 3) + (2 - 6) <=> 2 + 4 = 6 => Correct
// u(5, 1) - 3(8, 1) => ([|6 - 5|] + [|8 - 8|]) + ([|0 - 1|] + [|0 - 1|]) <=> 1 + 0 + 1 + 1 = 3 => Correct
// v(5, 2) - @(4, 7) => (5 - 4) + ([|0 - 2|] + [|8 - 7|]) <=> 1 + 2 + 1 = 4 => Correct
// r(4, 3) - 7(3, 6) => (4 - 3) + (|3 - 6|) <=> 1 + 3 = 4 => Correct

// v(5, 2) - 5(2, 7) => ([|6 - 5|] + [|0 - 2|]) + ([|0 - 2|] + [|8 - 7|]) <=> 1 + 2 + 2 + 1 = 6 => Correct
// v(4, 1) - 5(1, 6) => ([|5 - 4|] + [|0 - 1|]) + ([|0 - 1|] + [|7 - 6|]) <=> 1 + 1 + 1 + 1 => 4 =>
// 'v', '5'
int calculateSteps(String first, String second) {
  final List<int> firstCoordinate = getCoordinates(first);
  final List<int> secondCoordinate = getCoordinates(second);

  final int x1 = firstCoordinate[0];
  final int y1 = firstCoordinate[1];
  final int x2 = secondCoordinate[0];
  final int y2 = secondCoordinate[1];

  // ([|6 - 5|] + [|8 - 8|])
  int xResult;
  int yResult;
  if (isCloseToTopOrBottom(x1) && isCloseToTopOrBottom(x2)) {
    xResult = (x1 > 4 ? (6 - x1).abs() : x1) + (x2 > 4 ? (6 - x2).abs() : x2);
  } else {
    xResult = (x1 - x2).abs();
  }

  if (isCloseToRightOrLeft(y1) && isCloseToRightOrLeft(y2)) {
    yResult = (y1 > 6 ? (8 - y1).abs() : y1) + (y2 > 6 ? (8 - y2).abs() : y2);
  } else {
    yResult = (y1 - y2).abs();
  }

  return xResult + yResult;
}

bool isCapitalAndLetter(String letter) {
  const String letters = 'abcdeghijklmnopqrstuvwxyz';
  return letters.contains(letter) && letter.toUpperCase() == letter;
}

bool isCloseToTopOrBottom(int index) {
  return index < 3 || index > 4;
}

bool isCloseToRightOrLeft(int index) {
  return index < 3 || index > 6;
}

List<int> getCoordinates(String symbol) {
  final int index = keyboard.indexOf(symbol);
  return <int>[(index ~/ 8) + 1, (index % 8) + 1]; // [x, y]
}

final List<String> keyboard = <String>[
  'a',
  'b',
  'c',
  'd',
  'e',
  '1',
  '2',
  '3',
  'f',
  'g',
  'h',
  'i',
  'j',
  '4',
  '5',
  '6',
  'k',
  'l',
  'm',
  'n',
  'o',
  '7',
  '8',
  '9',
  'p',
  'q',
  'r',
  's',
  't',
  '.',
  '@',
  '0',
  'u',
  'v',
  'w',
  'x',
  'y',
  'z',
  '_',
  '/',
  'aA', // Shift
  ' ',
  // Empty cells:
  '-1',
  '-1',
  '-1',
  '-1',
  '-1',
];
