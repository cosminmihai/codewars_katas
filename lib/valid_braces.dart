/// Valid Braces

// Write a function that takes a string of braces, and determines if the order of the braces is valid.
//It should return true if the string is valid, and false if it's invalid.
//
// This Kata is similar to the Valid Parentheses Kata, but introduces new characters: brackets [], and curly braces {}.
//
// All input strings will be nonempty, and will only consist of parentheses, brackets and curly braces: ()[]{}.
//
// What is considered Valid?
// A string of braces is considered valid if all braces are matched with the correct brace.
//
// Examples
// "(){}[]"   =>  True
// "([{}])"   =>  True
// "(}"       =>  False
// "[(])"     =>  False
// "[({})](]" =>  False

import 'package:test/test.dart';

void main() {
  test('Valid', () {
    expect(validBraces('()'), isTrue);
  });

  test('Valid #2', () {
    expect(validBraces('(){}[]'), isTrue);
  });

  test('Valid #3', () {
    expect(validBraces('([{}])'), isTrue);
  });

  test('Invalid', () {
    expect(validBraces('[(])'), isFalse);
  });

  test('Invalid #2', () {
    expect(validBraces('[({})](]'), isFalse);
  });
}

final List<String> _openBraces = <String>['(', '[', '{'];
final List<String> _closeBraces = <String>[')', ']', '}'];

bool validBraces(String braces) {
  bool isValid = true;
  final List<String> pendingBraces = <String>[];
  final List<String> bracesList = braces.split('');

  for (int index = 0; index < bracesList.length; index++) {
    final String brace = bracesList[index];

    if (isOpening(brace)) {
      // If the last brace is an opening one, the pattern is invalid.
      if (index == bracesList.length - 1) {
        isValid = false;
        return isValid;
      }

      final String nextBrace = bracesList[index + 1];
      if (isOpening(nextBrace)) {
        pendingBraces.add(brace);
      } else {
        isValid = isPair(brace, nextBrace);
      }
    } else {
      // If the first brace is a closing one, the pattern is invalid.
      if (index == 0) {
        isValid = false;
        return isValid;
      }

      final String previous = bracesList[index - 1];
      if (!isOpening(previous)) {
        final String pair = getPair(brace);
        pendingBraces.remove(pair);
      } else {
        isValid = isPair(previous, brace);
      }
    }
  }

  return isValid && pendingBraces.isEmpty;
}

bool isOpening(String brace) {
  return _openBraces.contains(brace);
}

bool isPair(String opening, String closing) {
  return _openBraces.indexOf(opening) == _closeBraces.indexOf(closing);
}

String getPair(String brace) {
  return isOpening(brace) ? _closeBraces[_openBraces.indexOf(brace)] : _openBraces[_closeBraces.indexOf(brace)];
}
