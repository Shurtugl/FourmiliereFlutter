import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_ants/bo/brain/intent.dart';
import 'package:flutter_ants/bo/world2D/world.dart';
import 'package:flutter_ants/settings.dart';
import 'package:flutter_ants/utils.dart';

import 'bo/ant.dart';
import 'bo/pheromone.dart';
import 'bo/world2D/area.dart';
import 'bo/world2D/position.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Ants AI demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool initialized = false;
  bool autoStepping = false;
  bool autoGenerating = false;
  int currentStep = 0;
  int currentGeneration = 0;
  int zoom = Settings.worldSize;
  int graphZoom = 30;
  World worldMap = World(Settings.worldSize, Settings.worldSize);
  World pheromoneMap = World(Settings.worldSize, Settings.worldSize);
  List<Area> killAreas = [Settings.defaultKillArea];
  List<int> survivorsPerWave = [];

  void _reset() {
    setState(() {
      initialized = false;
      autoStepping = false;
      currentStep = 0;
      currentGeneration = 0;
      worldMap = World(Settings.worldSize, Settings.worldSize);
      pheromoneMap = World(Settings.worldSize, Settings.worldSize);
      survivorsPerWave = [];
    });
  }

  void _init() {
    if (!initialized) {
      for (int i = 0; i < Settings.antsAtInit; i++) {
        addAnt();
      }
      setState(() {
        initialized = true;
      });
    }
  }

  void addAnt({Ant? ant}) {
    Position pos = Position(Random().nextInt(Settings.worldSize),
        Random().nextInt(Settings.worldSize));

    if (null == ant) {
      ant = Ant(pos, worldMap);
    } else {
      ant.position = pos;
    }

    // Appel à setState pour déclencher le rafraîchissement de l'UI
    setState(() {
      worldMap.addElement(ant!);
    });
  }

  void _autoStepSwitch() {
    // Toggle autoplay
    setState(() {
      autoStepping = !autoStepping;
    });

    // Keep running while autoplaying
    if (initialized & autoStepping) {
      _autoStepRun(); // Start the autoplay process
    }
  }

  void _autoGenSwitch() {
    // Toggle autoplay
    setState(() {
      autoGenerating = !autoGenerating;
    });

    // Keep running while autoplaying
    if (initialized & autoGenerating) {
      autoStepping = true;
      _autoStepRun(); // Start the autoplay process
    }
  }

  void _autoStepRun() {
    if (currentStep >= Settings.stepsByGeneration) {
      _killAndReproduce();
      // place new generation

      setState(() {
        currentGeneration++;
        currentStep = 0;
        autoStepping = autoGenerating; // pause if not on autGen
      });
    }
    if (currentGeneration >= Settings.genBySimulation) {
      autoStepping = false;
    }
    if (autoStepping) {
      _step(); // Call the run method
      int delay = 1000000 ~/ Settings.speed;
      Future.delayed(Duration(microseconds: delay), () {
        _autoStepRun(); // Call the autoplay method again after the delay
      });
    }
  }

  void _killAndReproduce() {
    List<Ant> antsToKill = [];
    List<Ant> antsToKeep = [];
    List<Ant> nextGenAnts = [];

    // check ants positions
    worldMap.map.forEach((position, ant) {
      for (Area area in killAreas) {
        if (area.checkInside((ant as Ant).position!)) {
          antsToKill.add(ant);
        } else {
          antsToKeep.add(ant);
          nextGenAnts.add(ant);
        }
      }
    });
    setState(() {
      survivorsPerWave.add(antsToKeep.length);
    });
    // kill misplaced ants
    for (Ant ant in antsToKill) {
      _killAnt(ant);
    }
    // remove all other ants and reproduce them
    for (Ant ant in antsToKeep) {
      _killAnt(ant);
    }
    print("Il reste ${worldMap.map.length}");
    // create new generation
    while (nextGenAnts.length < Settings.antsAtInit) {
      Ant survivor = antsToKeep[Random().nextInt(antsToKeep.length)];
      Ant newBorn = survivor.reproduce(Settings.mutationChance);
      nextGenAnts.add(newBorn);
    }
    // place new generation on space
    for (Ant ant in nextGenAnts) {
      addAnt(ant: ant);
    }
  }

  void _step() {
    // prepare in-between movements
    List<Ant> antsToMove = [];
    // prepare step
    worldMap.map.forEach((position, ant) {
      (ant as Ant).step();
      antsToMove.add(ant);
    });
    //apply step
    for (Ant ant in antsToMove) {
      _moveAnt(ant);
    }
    // decay pheromones
    pheromoneMap.map.removeWhere((position, pheromone) {
      (pheromone as Pheromone).step();
      return pheromone.age > Settings.pheromoneDecayTime;
    });
    // apply to display
    setState(() {
      currentStep++;
    });
  }

  void _moveAnt(Ant ant) {
    NextStepIntent goToward = ant.wantToDoNextStep!;
    Position nextPos =
        getValidPosition(worldMap, goToward.getX(), goToward.getY());
    Position actualPos = ant.position!;
    // check position availability
    if (!worldMap.map.containsKey(nextPos)) {
      worldMap.map.remove(actualPos);
      ant.position = nextPos;
      worldMap.addElement(ant);
    }
  }

  void _killAnt(Ant ant) {
    worldMap.map.remove(ant.position);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(widget.title),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: initialized
                    ? FloatingActionButton(
                        onPressed: _reset,
                        tooltip: 'Reset',
                        mini: true,
                        backgroundColor:
                            initialized ? Colors.redAccent : Colors.grey,
                        child: const Icon(Icons.restart_alt),
                      )
                    : FloatingActionButton(
                        onPressed: _init,
                        tooltip: 'Init',
                        mini: true,
                        backgroundColor:
                            initialized ? Colors.grey : Colors.limeAccent,
                        child: const Icon(Icons.adb),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: FloatingActionButton(
                  onPressed: initialized ? _step : () => {},
                  tooltip: 'Step',
                  mini: true,
                  backgroundColor:
                      initialized ? Colors.lightGreen : Colors.grey,
                  child: const Icon(Icons.next_plan_outlined),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: FloatingActionButton(
                  onPressed: _autoStepSwitch,
                  tooltip: autoStepping ? 'Pause' : 'Play',
                  mini: true,
                  backgroundColor: initialized ? Colors.lightBlue : Colors.grey,
                  child: Icon(autoStepping
                      ? Icons.pause_circle_outline
                      : Icons.play_arrow),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: FloatingActionButton(
                  onPressed: _autoGenSwitch,
                  tooltip: autoGenerating ? 'Pause' : 'Play',
                  mini: true,
                  backgroundColor: initialized ? Colors.lightBlue : Colors.grey,
                  child: Icon(autoStepping
                      ? Icons.pause_circle_outline
                      : Icons.fast_forward_outlined),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * .5,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              double size = min(constraints.maxWidth, constraints.maxHeight);
              //. double graphScaleFactor = size / graphZoom;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: initialized
                        ? Text("Gen ${currentGeneration.toString()}")
                        : const Text("No generation yet"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: initialized
                        ? Text("Step ${currentStep.toString()}")
                        : const Text("No step yet"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: survivorsPerWave.isNotEmpty
                        ? Text(
                            "Last ${percentage(survivorsPerWave.last as double, Settings.antsAtInit as double)}%")
                        : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: survivorsPerWave.isNotEmpty
                        ? Text(
                            "Avg ${percentage(average(survivorsPerWave), Settings.antsAtInit as double)}%")
                        : null,
                  ),
                  Center(
                    child: Container(
                      width: size,
                      height: size / 2,
                      color: Colors.grey[400],
                      child: Stack(
                        children: [
                          ...survivorsPerWave.asMap().entries.map((survivor) {
                            return Positioned(
                              left: survivor.key.toDouble(),
                              bottom: 0,
                              child: Container(
                                width: 1,
                                height: (size / 2) *
                                    (survivor.value / Settings.antsAtInit),
                                color: survivor.key % 10 == 00
                                    ? Colors.red.withOpacity(1.0)
                                    : Colors.green.withOpacity(1.0),
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                  ),
                  const Text('Population evolution'),
                ],
              );
            },
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double size = constraints.maxWidth < constraints.maxHeight
              ? constraints.maxWidth
              : constraints.maxHeight;
          double scaleFactor = size / zoom;
          return Center(
            child: Container(
              width: size,
              height: size,
              color: Colors.grey[200],
              child: Stack(children: [
                ...killAreas.map((area) {
                  return Positioned(
                    left: area.x1 * scaleFactor,
                    top: area.y1 * scaleFactor,
                    child: Container(
                      width: (area.x2 - area.x1) * scaleFactor,
                      height: (area.y2 - area.y1) * scaleFactor,
                      color: Colors.red.withOpacity(0.5),
                    ),
                  );
                }),
                ...worldMap.map.entries.map((entry) {
                  Position pos = entry.key;
                  Ant element = (entry.value as Ant);

                  return Positioned(
                    left: pos.x * scaleFactor,
                    top: pos.y * scaleFactor,
                    child: Container(
                      width: scaleFactor,
                      height: scaleFactor,
                      color: element.getColor(),
                    ),
                  );
                }),
              ]),
            ),
          );
        },
      ),
    );
  }
}
