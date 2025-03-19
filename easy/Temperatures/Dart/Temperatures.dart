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
    int n = int.parse(readLineSync()); // the number of temperatures to analyse
    if (n != 0) {
    // Read the temperatures into a list
    List<int> values = stdin.readLineSync()!
        .split(' ')
        .map(int.parse)
        .toList();

    int minValue = values[0];
    int minDistance = minValue.abs();

    for (int i = 1; i < n; i++) {
      int dist = values[i].abs();

      if (dist < minDistance || (dist == minDistance && values[i] > minValue)) {
        minValue = values[i];
        minDistance = dist;
      }
    }

    print(minValue);
  } else {
    print(0);
  }
}