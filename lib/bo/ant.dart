import 'dart:math';
import 'dart:ui';

import 'package:flutter_ants/bo/world2D/positionableElement.dart';
import 'package:flutter_ants/bo/world2D/world.dart';

import '../settings.dart';
import 'brain/brain.dart';
import 'brain/intent.dart';
import 'dna/allele.dart';
import 'dna/dna.dart';

class Ant extends WorldElement {
  Dna? dna;
  Brain? brain;
  int farDistance = Random().nextInt(Settings.maxFarDistance);
  double oscillationPeriod = Random().nextDouble();
  double caffeine = Random().nextDouble();
  NextStepIntent? wantToDoNextStep;
  World world;

  int lastX = 0;
  int lastY = 0;

  Ant(super.position, this.world, {this.dna}) {
    dna ??= Dna(Settings.alleles);
    brain = Brain(Settings.innerNeurons, this, world); //set brain connexions
    for (Allele a in dna!.alleles) {
      brain!.addConnexion(a);
    }
  }

  getColor() {
    Color c = Color(dna?.getHash());
    return c.withAlpha(255);
  }

  @override
  String toString() {
    return "$position | $dna";
  }

  @override
  step() {
    wantToDoNextStep = NextStepIntent(position!);
    brain!.think();
    age++;
  }

  getAngle() {
    return atan2(lastY.toDouble(), lastX.toDouble()) * (180 / pi);
  }

  Ant reproduce(int mutationChance) {
    Dna copyDna = dna!.reproduce(mutationChance);
    Ant copyCat = Ant(position!, world, dna: copyDna); //softclone

    return copyCat;
  }
}
