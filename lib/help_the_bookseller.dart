/// Help the bookseller

// A bookseller has lots of books classified in 26 categories labeled A, B, ... Z.
// Each book has a code c of 3, 4, 5 or more characters.
// The 1st character of a code is a capital letter which defines the book category.
//
// In the bookseller's stockList each code c is followed by a space
// and by a positive integer n (int n >= 0) which indicates the quantity of books of this code in stock.
//
// For example an extract of a stockList could be:
//
// L = {"ABART 20", "CDXEF 50", "BKWRK 25", "BTSQZ 89", "DRTYM 60"}.
// or
// L = ["ABART 20", "CDXEF 50", "BKWRK 25", "BTSQZ 89", "DRTYM 60"] or ....
// You will be given a stocklist (e.g. : L) and a list of categories in capital letters e.g :
//
// M = {"A", "B", "C", "W"}
// or
// M = ["A", "B", "C", "W"] or ...
// and your task is to find all the books of L with codes belonging to each category
// of M and to sum their quantity according to each category.
//
// For the lists L and M of example you have to return the string (in Haskell/Clojure/Racket a list of pairs):
//
// (A : 20) - (B : 114) - (C : 50) - (W : 0)
// where A, B, C, W are the categories, 20 is the sum of the unique book of category A,
// 114 the sum corresponding to "BKWRK" and "BTSQZ", 50 corresponding to "CDXEF"
// and 0 to category 'W' since there are no code beginning with W.
//
// If L or M are empty return string is "" (Clojure and Racket should return an empty array/list instead).
//
// Note:
// In the result codes and their values are in the same order as in M.

import 'package:test/test.dart';

void main() {
  group('Tests', () {
    List<String> b = <String>['BBAR 150', 'CDXE 515', 'BKWR 250', 'BTSQ 890', 'DRTY 600'];
    List<String> c = <String>['A', 'B', 'C', 'D'];
    doTest(b, c, '(A : 0) - (B : 1290) - (C : 515) - (D : 600)');

    b = <String>['ABAR 200', 'CDXE 500', 'BKWR 250', 'BTSQ 890', 'DRTY 600'];
    c = <String>['A', 'B'];
    doTest(b, c, '(A : 200) - (B : 1140)');
  });
}

void doTest(List<String> lstOfArt, List<String> listOfFirstLetter, String exp) {
  test('Testing for: \n$lstOfArt\n$listOfFirstLetter', () {
    expect(stockSummary(lstOfArt, listOfFirstLetter), equals(exp));
  });
}

String stockSummary(List<String> stock, List<String> categories) {
  if (stock.isEmpty || categories.isEmpty) {
    return '';
  }

  final StringBuffer inventory = StringBuffer();
  for (final String category in categories) {
    final Iterable<int> quantities = stock.where((String item) {
      return item.startsWith(category);
    }).map((String stock) => int.parse(stock.split(' ')[1]));

    final int total = quantities.isEmpty ? 0 : quantities.reduce((int value, int element) => value + element);
    inventory.write('${inventory.isEmpty ? '' : ' - '}($category : $total)');
  }

  return inventory.toString();
}
