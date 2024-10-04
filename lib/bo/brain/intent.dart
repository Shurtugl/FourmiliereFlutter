import 'dart:math';

import 'package:flutter_ants/bo/world2D/position.dart';

import '../../settings.dart';
import '../../utils.dart';

class NextStepIntent {
  Position previous;
  bool killFront = false;
  double x = 0;
  double y = 0;

  NextStepIntent(this.previous);

  getX() {
    int offset = unify(x);
    return previous.x + offset;
  }

  getY() {
    int offset = unify(y);
    return previous.y + offset;
  }

  unify(double i) {
    if (i < 0) return -1;
    if (i > 0) return 1;
    return 0;
  }

  @override
  String toString() {
    return "x:$x,y:$y${killFront ? ',k' : ''}";
  }
}
