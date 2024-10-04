import 'package:flutter_ants/bo/world2D/position.dart';
import 'package:flutter_ants/bo/world2D/positionableElement.dart';

import '../ant.dart';
import '../pheromone.dart';

class World {
  int sizeX;
  int sizeY;
  Map<Position, Object> map = {};

  World(this.sizeX, this.sizeY);

  void addElement(Object element) {
    if (element is Ant) {
      placeOnMap(element);
    } else if (element is Pheromone) {
      placeOnMap(element);
    }
  }

  void placeOnMap(Object element) {
    Position? pos = (element as WorldElement).position;
    if (pos != null) {
      map[pos] = element;
    }
  }

  @override
  toString() {
    return "size:${map.length},$map";
  }
}
