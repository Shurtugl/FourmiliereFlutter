import 'package:flutter_ants/bo/world2D/position.dart';

class Area {
  int x1 = 0;
  int y1 = 0;
  int x2 = 0;
  int y2 = 0;

  Area(this.x1, this.y1, this.x2, this.y2);

  bool checkInside(Position p) {
    bool horizontal = p.x >= x1 && p.x <= x2;
    bool vertical = p.y >= y1 && p.y <= y2;
    return horizontal && vertical;
  }
}
