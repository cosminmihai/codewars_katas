/// TV Remote (symbols)
import 'dart:math';

import 'package:test/test.dart';

void main() {
  test('Example', () {
    expect(tvRemote('Too Easy?'), equals(71));
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

  test('Symbols', () {
    expect(tvRemote('^does^'), equals(33));
    expect(tvRemote('\$your\$'), equals(53));
    expect(tvRemote('#solution#'), equals(49));
    expect(tvRemote('\u00bfwork\u00bf'), equals(34));
    expect(tvRemote('{for}'), equals(38));
    expect(tvRemote('\u00a3these\u00a3'), equals(57));
    expect(tvRemote('?symbols?'), equals(54));
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

int tvRemote(String word) {
  // Refresh for every test.
  selectedKeyboard = KeyboardType.alphaNumeric;
  previousSymbol = alphaNumeric[0][0];

  int totalSteps = 0;
  for (int index = 0; index < word.length; index++) {
    final String key = word[index];
    if (isCommonSymbol(key)) {
      totalSteps += calculateStepsAndPress(previousSymbol, key);
      previousSymbol = key;
    } else {
      totalSteps += isAlphaNumeric(key) ? handleAlphaNumeric(key) : handleSymbol(key);
    }
  }

  return totalSteps;
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

bool isCommonSymbol(String symbol) {
  return symbol == '/' || symbol == '.' || symbol == '_' || symbol == ' ' || symbol == '@';
}

bool isAlphaNumeric(String symbol) {
  return alphaNumeric.any((List<String> element) => element.contains(symbol)) ||
      upperAlphaNumeric.any((List<String> element) => element.contains(symbol));
}

int handleAlphaNumeric(String letter) {
  int steps = 0;
  if (isUpperCase(letter)) {
    if (selectedKeyboard == KeyboardType.alphaNumeric) {
      steps += pressShift();
    } else if (selectedKeyboard == KeyboardType.symbolic) {
      steps += pressShift(plus: 1);
    }

    selectedKeyboard = KeyboardType.alphaNumericUpperCase;
  } else if (isLowerCase(letter)) {
    if (selectedKeyboard == KeyboardType.alphaNumericUpperCase) {
      steps += pressShift(plus: 1);
    } else if (selectedKeyboard == KeyboardType.symbolic) {
      steps += pressShift();
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
    steps += pressShift(plus: 1);
  } else if (selectedKeyboard == KeyboardType.alphaNumericUpperCase) {
    steps += pressShift();
  }

  selectedKeyboard = KeyboardType.symbolic;
  steps += calculateStepsAndPress(previousSymbol, symbol);
  previousSymbol = symbol;
  return steps;
}

List<int> getCoordinates(String symbol) {
  final List<List<String>> keyboard = getKeyboardByType(selectedKeyboard);
  final int row = keyboard.indexWhere((List<String> row) => row.contains(symbol));
  final int column = keyboard[row].indexOf(symbol);
  return <int>[row, column];
}

int pressShift({int plus = 0}) {
  final int steps = calculateStepsAndPress(previousSymbol, shift) + plus;
  previousSymbol = shift;
  return steps;
}

bool isUpperCase(String symbol) => symbol.startsWith(RegExp('[A-Z]'));

bool isLowerCase(String symbol) => symbol.startsWith(RegExp('[a-z]'));

bool isNumber(String symbol) => symbol.contains(RegExp('[0-9]'));

bool isSymbol(String symbol) => symbols.any((List<String> element) => element.contains(symbol));

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
