import 'bo/world2D/area.dart';

class Settings {
  static int speed = 100000;
  static int worldSize = 100;
  static int antsAtInit = 1000;
  static int stepsByGeneration = 100;
  static int genBySimulation = 500;
  static int alleles = 5;
  static int innerNeurons = 0;
  static int totalInputs = 21;
  static int totalOutputs = 11;
  static int pheromoneDecayTime = 20;
  static int maxFarDistance = 20;
  static int mutationChance = 0;
  static Area defaultKillArea = Area(Settings.worldSize * 10 ~/ 100, 0,
      Settings.worldSize * 90 ~/ 100, Settings.worldSize);
}
