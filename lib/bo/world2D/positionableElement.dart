import 'package:flutter_ants/bo/world2D/position.dart';

class WorldElement{
  Position? position;
  int age = 0;

  WorldElement(this.position);

  step(){
    age++;
  }
}