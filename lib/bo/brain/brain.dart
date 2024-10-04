import 'dart:math';

import '../../settings.dart';
import '../../utils.dart';
import '../ant.dart';
import '../dna/allele.dart';
import '../world2D/world.dart';
import 'inputs.dart';
import 'outputs.dart';
import 'synapse.dart';

class Brain {
  List<Synapse> synapses = [];
  List<double> internalNeurones = [];
  Inputs inputs;
  Outputs outputs;
  int nbOfNeurones = 0;
  Ant ant;

  Brain(this.nbOfNeurones, this.ant, World world)
      : inputs = Inputs(world, ant),
        outputs = Outputs(world, ant) {
    resetNeurons();
  }

  void resetNeurons() {
    internalNeurones = [];
    for (int i = 0; i < nbOfNeurones; i++) {
      internalNeurones.add(0.0);
    }
  }

  /// Reads an allele instruction and create a synaptic connexion out of it
  addConnexion(Allele a) {
    Synapse n = Synapse(a.value, source: a.source, target: a.target);
    n.setTippingPoints(
        Settings.totalInputs, nbOfNeurones, Settings.totalOutputs);
    synapses.add(n);
  }

  /// Follows each connexion with its value and apply
  think() {
    Map<int, double> shortTermMemory = {};
    // 1 read all, multiply & memorize
    for (Synapse synapse in synapses) {
      double value = 0.0;
      if (synapse.getSource() < Settings.totalInputs) {
        value = inputs.readInput(synapse.getSource());
      } else {
        value = internalNeurones[synapse.getSource() - Settings.totalInputs];
      }
      //add or create
      if (null != shortTermMemory[synapse.getTarget()]) {
        shortTermMemory[synapse.getTarget()] =
            value * synapse.getRatio() + shortTermMemory[synapse.getTarget()]!;
      } else {
        shortTermMemory[synapse.getTarget()] = value * synapse.getRatio();
      }
    }
    // 2 reset all internal & outputs
    resetNeurons();
    // 3 add all
    shortTermMemory.forEach((target, newRatio) {
      newRatio = sigmoid(newRatio);
      if (newRatio != 0) {
        if (target < Settings.totalInputs + nbOfNeurones) {
          internalNeurones[target - Settings.totalInputs] += newRatio;
        } else {
          outputs.apply(target - Settings.totalInputs - nbOfNeurones, newRatio);
        }
      }
    });
  }
}
