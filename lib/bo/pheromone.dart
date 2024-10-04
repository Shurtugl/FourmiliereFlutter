import 'package:flutter/material.dart';
import 'package:flutter_ants/bo/world2D/positionableElement.dart';
import 'package:flutter_ants/settings.dart';

class Pheromone extends WorldElement {
  Pheromone(super.position);

  getColor() {
    Color c = Colors.blue;
    int alpha = 255 * super.age ~/ Settings.pheromoneDecayTime;
    return c.withAlpha(alpha);
  }
}
