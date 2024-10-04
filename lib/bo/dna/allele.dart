import 'dart:math';

import '../../settings.dart';
import '../../utils.dart';

class Allele {
  int source = 0;
  int target = 0;
  double value = 0.0;

  Allele() {
    generateSource();
    generateTarget();
    generateValue();
  }

  Allele reproduce(int mutationChance) {
    Allele copyCat = Allele();
    copyCat.source = source;
    copyCat.target = target;
    copyCat.value = value;

    if (rollDiceOf(mutationChance)) {
      switch (Random().nextInt(2)) {
        case 0:
          generateSource();
          break;
        case 1:
          generateTarget();
          break;
        case 2:
          generateValue();
          break;
        default:
          break;
      }
    }
    return copyCat;
  }

  generateSource() {
    source = Random().nextInt(Settings.totalInputs + Settings.innerNeurons);
  }

  generateTarget() {
    target = Random().nextInt(Settings.innerNeurons + Settings.totalOutputs) +
        Settings.totalInputs;
  }

  generateValue() {
    value = 5 - Random().nextDouble() * 10;
  }

  @override
  String toString() {
    return "($source->$target:${value.toStringAsFixed(2)})";
  }
}
