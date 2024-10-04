import 'dart:math';

import 'bo/world2D/position.dart';
import 'bo/world2D/world.dart';

bool rollDiceOf(int mutationChance) {
  return mutationChance > Random().nextInt(100);
}

int scale(int input, int min, int max) {
  return ((max + 1 - min) * input + min).toInt();
}

Position getValidPosition(World world, int x, int y) {
  return Position(
      min(max(x, 0), world.sizeX - 1), min(max(y, 0), world.sizeY - 1));
}

double sigmoid(double x) {
  return (1 / (1 + exp(-1 * x)));
}

double average(List<int> list) {
  if (list.isEmpty) {
    return 0;
  }
  int sum = list.reduce((a, b) => a + b);
  return sum / list.length;
}

String percentage(double a, double b) {
  return (a * 100 ~/ b).toString();
}
