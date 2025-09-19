import 'dart:io';

void main() {
  // Take input
  stdout.write("Enter a positive number: ");
  int n = int.parse(stdin.readLineSync()!);

  int sum = 0;

  // Loop from 1 to n
  for (int i = 1; i <= n; i++) {
    if (i % 2 == 0) {
      sum += i;
    }
  }

  // Output result
  print("The sum of even numbers from 1 to $n is: $sum");
}