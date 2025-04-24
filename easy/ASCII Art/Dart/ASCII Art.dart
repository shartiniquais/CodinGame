import 'dart:io';

String readLineSync() {
  String? s = stdin.readLineSync();
  return s == null ? '' : s;
}

/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
void main() {
    int l = int.parse(readLineSync());
    int h = int.parse(readLineSync());
    String t = readLineSync().toUpperCase();
    List asciiArtRows = [];
    for (int i = 0; i < h; i++) {
        String row = readLineSync();
        asciiArtRows.add(row);
    }

    List<StringBuffer> result = List.generate(h, (_) => StringBuffer());

    for (int i = 0; i < t.length; i++) {
        String char = t[i];
        int index = ('A'.codeUnitAt(0) <= char.codeUnitAt(0) && char.codeUnitAt(0) <= 'Z'.codeUnitAt(0))
            ? char.codeUnitAt(0) - 'A'.codeUnitAt(0)
            : 26; // For non-alphabet characters, use '?'

        for (int j = 0; j < h; j++) {
            String row = asciiArtRows[j];
            String charRow = row.substring(index * l, (index + 1) * l);
            result[j].write(charRow);
        }
    }

    result.forEach(print);
}