/// TV Remote (symbols)
import 'dart:math';

import 'package:test/test.dart';

void main() {
  test('Example', () {
    expect(tv_remote('Too Easy?'), equals(71));
  });

  test('Lower', () {
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

  test('Symbols', () {
    expect(tv_remote('^does^'), equals(33));
    expect(tv_remote('\$your\$'), equals(53));
    expect(tv_remote('#solution#'), equals(49));
    expect(tv_remote('\u00bfwork\u00bf'), equals(34));
    expect(tv_remote('{for}'), equals(38));
    expect(tv_remote('\u00a3these\u00a3'), equals(57));
    expect(tv_remote('?symbols?'), equals(54));
  });
}

enum KeyboardType { alphaNumeric, alphaNumericUpperCase, symbolic }

const String shift = 'aA#';

// -1 represents the empty space
List<List<String>> alphaNumeric = <List<String>>[
  <String>['a', 'b', 'c', 'd', 'e', '1', '2', '3'],
  <String>['f', 'g', 'h', 'i', 'j', '4', '5', '6'],
  <String>['k', 'l', 'm', 'n', 'o', '7', '8', '9'],
  <String>['p', 'q', 'r', 's', 't', '.', '@', '0'],
  <String>['u', 'v', 'w', 'x', 'y', 'z', '_', '/'],
  <String>[shift, ' ', '-1', '-1', '-1', '-1', '-1', '-1'],
];

List<List<String>> upperAlphaNumeric = <List<String>>[
  <String>['A', 'B', 'C', 'D', 'E', '1', '2', '3'],
  <String>['F', 'G', 'H', 'I', 'J', '4', '5', '6'],
  <String>['K', 'L', 'M', 'N', 'O', '7', '8', '9'],
  <String>['P', 'Q', 'R', 'S', 'T', '.', '@', '0'],
  <String>['U', 'V', 'W', 'X', 'Y', 'Z', '_', '/'],
  <String>[shift, ' ', '-1', '-1', '-1', '-1', '-1', '-1'],
];

final List<List<String>> symbols = <List<String>>[
  <String>['^', '~', '?', '!', "'", '"', '(', ')'],
  <String>['-', ':', ';', '+', '&', '%', '*', '='],
  <String>['<', '>', '€', '£', '\$', '¥', '¤', '\\'],
  <String>['[', ']', '{', '}', ',', '.', '@', '§'],
  <String>['#', '¿', '¡', '-1', '-1', '-1', '_', '/'],
  <String>[shift, ' ', '-1', '-1', '-1', '-1', '-1', '-1'],
];

KeyboardType selectedKeyboard = KeyboardType.alphaNumeric;
String previousSymbol = alphaNumeric[0][0]; // Starts with 'a'
KeyboardType previousKeyboard = selectedKeyboard;

int tv_remote(String word) {
  // Refresh for every test.
  selectedKeyboard = KeyboardType.alphaNumeric;
  previousKeyboard = selectedKeyboard;
  previousSymbol = alphaNumeric[0][0];

  int totalSteps = 0;
  for (int index = 0; index < word.length; index++) {
    final String key = word[index];
    if (isCommonSymbols(key)) {
      totalSteps += calculateStepsAndPress(previousSymbol, key);
      previousSymbol = key;
    } else {
      totalSteps += isAlphaNumeric(key) ? handleAlphaNumeric(key) : handleSymbol(key);
    }
  }

  return totalSteps;
}

int handleAlphaNumeric(String letter) {
  int steps = 0;
  if (isUpperCase(letter)) {
    if (selectedKeyboard == KeyboardType.alphaNumeric) {
      steps += pressShift(symbol: previousSymbol);
    } else if (selectedKeyboard == KeyboardType.symbolic) {
      steps += pressShift(symbol: previousSymbol, plus: 1);
    }

    selectedKeyboard = KeyboardType.alphaNumericUpperCase;
  } else if (isLowerCase(letter)) {
    if (selectedKeyboard == KeyboardType.alphaNumericUpperCase) {
      steps += pressShift(symbol: previousSymbol, plus: 1);
    } else if (selectedKeyboard == KeyboardType.symbolic) {
      steps += pressShift(symbol: previousSymbol);
    }

    selectedKeyboard = KeyboardType.alphaNumeric;
  } else {
    if (selectedKeyboard == KeyboardType.symbolic) {
      steps += calculateStepsAndPress(previousSymbol, shift);
      previousSymbol = shift;
      selectedKeyboard = KeyboardType.alphaNumeric;
    }
  }

  steps += calculateStepsAndPress(previousSymbol, letter);
  previousSymbol = letter;
  return steps;
}

int handleSymbol(String symbol) {
  int steps = 0;
  if (selectedKeyboard == KeyboardType.alphaNumeric) {
    steps += calculateStepsAndPress(previousSymbol, shift) + 1;
    previousSymbol = shift;
  } else if (selectedKeyboard == KeyboardType.alphaNumericUpperCase) {
    steps += calculateStepsAndPress(previousSymbol, shift);
    previousSymbol = shift;
  }

  selectedKeyboard = KeyboardType.symbolic;
  steps += calculateStepsAndPress(previousSymbol, symbol);
  previousSymbol = symbol;
  return steps;
}

bool isAlphaNumeric(String symbol) {
  return alphaNumeric.any((List<String> element) => element.contains(symbol)) ||
      upperAlphaNumeric.any((List<String> element) => element.contains(symbol));
}

bool isUpperCase(String symbol) => symbol.startsWith(RegExp('[A-Z]'));

bool isLowerCase(String symbol) => symbol.startsWith(RegExp('[a-z]'));

bool isNumber(String symbol) => symbol.contains(RegExp('[0-9]'));

bool isSymbol(String symbol) => symbols.any((List<String> element) => element.contains(symbol));

int pressShift({String symbol = '', int plus = 0}) {
  final int steps = calculateStepsAndPress(previousSymbol, shift) + plus;
  previousSymbol = shift;
  return steps;
}

int calculateStepsAndPress(String startingSymbol, String endingSymbol) {
  final List<int> firstCoordinate = getCoordinates(startingSymbol);
  final List<int> secondCoordinate = getCoordinates(endingSymbol);

  final int rowDifference = (firstCoordinate[0] - secondCoordinate[0]).abs();
  final int columnDifference = (firstCoordinate[1] - secondCoordinate[1]).abs();
  final int rowSteps = min(rowDifference, 6 - rowDifference);
  final int columnSteps = min(columnDifference, 8 - columnDifference);
  return rowSteps + columnSteps + 1;
}

List<int> getCoordinates(String symbol) {
  final List<List<String>> keyboard = getKeyboardByType(selectedKeyboard);
  final int row = keyboard.indexWhere((List<String> row) => row.contains(symbol));
  final int column = keyboard[row].indexOf(symbol);
  return <int>[row, column];
}

List<List<String>> getKeyboardByType(KeyboardType type) {
  switch (type) {
    case KeyboardType.alphaNumeric:
      return alphaNumeric;
    case KeyboardType.alphaNumericUpperCase:
      return upperAlphaNumeric;
    case KeyboardType.symbolic:
      return symbols;
  }
}

bool isCommonSymbols(String symbol) {
  return symbol == '/' || symbol == '.' || symbol == '_' || symbol == ' ' || symbol == '@';
}
