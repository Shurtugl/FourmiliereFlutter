import '../../utils.dart';
import '../ant.dart';
import '../world2D/world.dart';

class Outputs {
  World? world;
  Ant? ant;

  Outputs(this.world, this.ant);

  void apply(int target, double newRatio) {
    switch (target) {
      // Movement
      case 0:
        {
          double moveX = newRatio;
          if (testValue(moveX)) {
            ant!.wantToDoNextStep!.x += moveX > 0.5 ? 1 : -1;
          }
          break;
        }
      case 1:
        {
          double moveY = newRatio;
          if (testValue(moveY)) {
            ant!.wantToDoNextStep!.y += moveY > 0.5 ? 1 : -1;
          }
          break;
        }
      case 2:
        {
          double moveSide = newRatio;
          break;
        }
      case 3:
        {
          double moveBack = newRatio;
          break;
        }
      case 4:
        {
          double moveForward = newRatio;
          break;
        }
      case 5:
        {
          double moveRandom = newRatio;
          break;
        }
      case 6:
        {
          double setFarDistance = newRatio;
          if (testValue(setFarDistance)) {
            ant!.farDistance += setFarDistance > 0 ? 1 : -1;
          }
          break;
        }
      case 7:
        {
          double setOscillation = newRatio;
          if (testValue(setOscillation)) {
            ant!.oscillationPeriod += setOscillation;
          }
          break;
        }
      case 8:
        {
          double createScent = newRatio;
          break;
        }
      case 9:
        {
          double setCaffeine = newRatio;
          if (testValue(setCaffeine)) {
            ant!.caffeine = setCaffeine * 10;
          }
          break;
        }
      case 10:
        {
          double killFront = newRatio;
          if (testValue(killFront)) {
            ant!.wantToDoNextStep!.killFront = true;
          }
          break;
        }
    }
  }

  bool testValue(double value) {
    return value * ant!.caffeine * 10 > 1;
  }
}
