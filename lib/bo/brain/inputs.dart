import 'dart:math';

import '../ant.dart';
import '../world2D/world.dart';

class Inputs {
  World? world;
  Ant? ant;

  Inputs(this.world, this.ant);

  double readInput(int id) {
    switch (id) {
      // Position
      case 0:
        {
          double? xPos = ant?.position?.x.toDouble();
          return null != xPos ? xPos / world!.sizeX.toDouble() : -1.0; // 0-w
        }
      case 1:
        {
          double? yPos = ant?.position?.y.toDouble();
          return null != yPos ? yPos / world!.sizeY.toDouble() : -1.0; // 0-w
        }
      //Borders
      case 2:
        {
          double? border = min(readInput(3), readInput(4));
          return border / (world!.sizeY / 2.0 + world!.sizeX / 2.0);
        }
      case 3:
        {
          double xPos = readInput(0);
          return min(xPos, (world!.sizeX.toDouble() - xPos));
        }
      case 4:
        {
          double yPos = readInput(1);
          return min(yPos, (world!.sizeY.toDouble() - yPos));
        }
      // Last movements
      case 5:
        {
          return ant!.lastX.toDouble();
        }
      case 6:
        {
          return ant!.lastY.toDouble();
        }
      // Miscellaneous
      case 18:
        {
          return ant!.age.toDouble();
        }
      default:
        return 0.0;
    }
/*
    // Blockage
    7 double blockFront = 0; // 0, 1
    8 double blockSides = 0; // 0,1,2
    9 double blockFar = 0; // 0-n
    // Population
    10 double popFront = 0; // -1.0 ~ 0 ~ 1.0
    11 double popSides = 0; // -1.0 ~ 0 ~ 1.0
    12 double popFar = 0; // 0 - n
    13 double popDensity = 0; // 0 ~ 100%
    // Pheromone
    14 double smellSides = 0; // 0 ~ 2.0
    15 double smellFront = 0; //  0 ~ 1.0
    16 double smellTotal = 0; //  0 ~ 8.0
    // Miscellaneous
    17 double genetic = 0; // 0 - 100%
    18 double age = 0; // 0 - stepMax
    19 double random = 0; // -1.0 ~ 1.0
    20 double oscillate = 0; // -1.0 ~ 1.0*/
  }
}
