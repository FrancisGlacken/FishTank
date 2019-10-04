import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'dart:ui';
import 'package:fish_tank/components/objects/fish.dart';
import 'dart:math';
import 'package:fish_tank/components/objects/fish-mud.dart';
import 'package:fish_tank/components/objects/fish-red.dart';
import 'package:fish_tank/components/objects/fish-blue.dart';
import 'package:fish_tank/components/objects/fish-green.dart';
import 'package:fish_tank/components/objects/fish-purple.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:fish_tank/fish_tank_ui.dart';
import 'package:fish_tank/components/objects/enemy_fish.dart';
import 'package:fish_tank/components/objects/background-ocean.dart';
import 'package:fish_tank/components/objects/bubble.dart';
import 'package:fish_tank/controllers/bubble-spawner.dart';
import 'package:fish_tank/components/objects/bubble-blue.dart';
import 'package:fish_tank/components/objects/food.dart';
import 'package:fish_tank/components/objects/food-basic.dart';

enum FishStyle { red, blue, green, purple }

class FishTankGame extends Game {
  final FishTankUIState ui;
  Size screenSize;
  double tileSize;
  Random rnd;
  bool isHandled = false;
  List<Fish> fishies;
  List<EnemyFish> evilFishies;
  List<Bubble> bubbles;
  List<Food> foods;
  Ocean background;
  BubbleSpawner bubbleSpawner;
  String selectedFishName;
  int selFishId, selFishExp; 
  int fishTally;

  FishTankGame(this.ui) {
    initialize();
  }

  void initialize() async {
    fishTally = 0;
    rnd = Random();
    fishies = List<Fish>();
    evilFishies = List<EnemyFish>();
    bubbles = List<Bubble>();
    foods = List<Food>();
    resize(await Flame.util.initialDimensions());
    background = Ocean(this);
    bubbleSpawner = BubbleSpawner(this);
  }

  void resize(Size size) {
    screenSize = size;
    super.resize(size);
    tileSize = screenSize.width / 9;
  }

  void render(Canvas canvas) {
    background.render(canvas);

    // Spawn fishies/bubbles
    if (fishies.length > 0) {
      fishies.forEach((Fish fishy) => fishy.render(canvas));
    }
    bubbles.forEach((Bubble bubble) => bubble.render(canvas));
    bubbles.removeWhere((Bubble bubble) => bubble.isOffScreen == true);
    if (evilFishies.length > 0) {
      evilFishies[0].render(canvas);
    }
    foods.forEach((Food food) => food.render(canvas));
  }

  void update(double t) {
    //fishy.update(t);
    bubbleSpawner.update(t);
    fishies.forEach((Fish fish) => fish.update(t));
    evilFishies.forEach((EnemyFish enemyFish) => enemyFish.update(t));
    bubbles.forEach((Bubble bubble) => bubble.update(t));
    bubbles.removeWhere((Bubble bubble) => bubble.isOffScreen);
    foods.forEach((Food food) => food.update(t));
  }

  void onTapDown(TapDownDetails d) {
    // bool for preventing resource waste
    bool isHandled = false;

    if (!isHandled && ui.currentScreen == UIScreen.home) {
      fishies.forEach((Fish fishy) {
        if (fishy.fishRect.contains(d.globalPosition)) {
          fishy.onTapDown();
          selectedFishName = fishy.fishName;
          selFishId = fishy.fishId;
          selFishExp = fishy.fishExp;
          ui.updateSelectedFishyName();
          isHandled = true;
        }
      });
    }

    if (!isHandled) {
      bubbles.forEach((Bubble bubble) {
        if (bubble.bubbleRect.contains(d.globalPosition)) {
          bubble.onTapDown();
        }
      });
      isHandled = true;
    }
  }

  void summonFishy(FishStyle style) {
    Fish fishy;
    double x = (screenSize.width - tileSize);
    double y = (screenSize.height - tileSize);
    switch (style) {
      case FishStyle.red:
        fishy = RedFish(this, x, y, 20, 20, "Red", fishTally);
        break;
      case FishStyle.blue:
        fishy = BlueFish(this, x, y, 20, 20, "Blue", fishTally);
        break;
      case FishStyle.green:
        fishy = GreenFish(this, x, y, 20, 20, "Green", fishTally);
        break;
      case FishStyle.purple:
        fishy = PurpleFish(this, x, y, 20, 20, "Purple", fishTally);
        break;
    }
    fishTally = fishTally + 1;
    fishies.add(fishy);
  }

  void summonBubble() {
    double x = rnd.nextDouble() * (screenSize.width - tileSize);
    double y = (screenSize.height);
    bubbles.add(BubbleBlue(this, x, y));
  }

  // Food pellets need a lot of work
  void summonFood() {
    double x = screenSize.width / 2;
    Food food;
    food = (BasicFood(this, x, 0));
    foods.add(food);
    food = (BasicFood(this, rnd.nextInt(80) + (screenSize.width / 2),
        -rnd.nextInt(20) + 1.0));
    foods.add(food);
    food = (BasicFood(this, rnd.nextInt(80) + (screenSize.width / 2),
        -rnd.nextInt(40) + 1.0));
    foods.add(food);
    food = (BasicFood(this, rnd.nextInt(80) + (screenSize.width / 2),
        -rnd.nextInt(20) + 1.0));
    foods.add(food);
    food = (BasicFood(this, rnd.nextInt(80) + (screenSize.width / 2),
        -rnd.nextInt(20) + 1.0));
    foods.add(food);
    food = (BasicFood(this, rnd.nextInt(80) + (screenSize.width / 2),
        -rnd.nextInt(30) + 1.0));
    foods.add(food);
    food = (BasicFood(this, rnd.nextInt(80) + (screenSize.width / 2),
        -rnd.nextInt(35) + 1.0));
    foods.add(food);
  }

  void increaseSize() {
    fishies.forEach((Fish fishy) {
      if (fishy.fishId == selFishId) {
        fishy.increaseSize();
      }
    });
  }
}

// Unused code
// //Implement this
//   void start() {}

//   // Attempts to update fish size by calling a if statement in the update method of the fishy
//   void growFishy() {
//     growRate = growRate * 1.1;
//     fishies.forEach((Fish fishy) {
//       fishy.fishSizeMulti = fishy.fishSizeMulti * growRate;
//     });
//   }
