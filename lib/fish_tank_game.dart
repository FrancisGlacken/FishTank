import 'package:fish_tank/components/objects/fish-jellyfish.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'dart:ui';
import 'package:fish_tank/components/objects/fish.dart';
import 'dart:math';
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
import 'package:fish_tank/controllers/jelly-fish-spawner.dart';
import 'package:fish_tank/components/objects/bubble-blue.dart';
import 'package:fish_tank/components/objects/food.dart';
import 'package:fish_tank/components/objects/food-basic.dart';
import 'package:fish_tank/components/objects/fish-mud.dart';
import 'package:fish_tank/components/objects/fish-bullet.dart';
import 'package:fish_tank/components/objects/random-name.dart';
import 'package:hive/hive.dart';
import 'package:fish_tank/components/objects/models/fish-data.dart';
import 'package:enum_to_string/enum_to_string.dart';

enum FishStyle { red, blue, green, purple }

class FishTankGame extends Game {
  Box goldBox, fishyBox;
  final FishTankUIState ui;
  Size screenSize;
  double tileSize;
  String selectedFishName;
  int selFishExp, gold;
  Random rng;
  bool isHandled = false;
  List<Fish> fishies;
  List<EnemyFish> evilFishies;
  List<Bubble> bubbles;
  List<Food> foods;
  List<JellyFish> jellies;
  Ocean background;
  BubbleSpawner bubbleSpawner;
  JellyFishSpawner jellyFishSpawner;
  RandomName randomName;

  FishTankGame(this.ui) {
    initialize();
  }

  void initialize() async {
    if (Hive.box<int>("gold_box").get("gold") == null) {
      Hive.box<int>("gold_box").put("gold", 15000);
    }
    goldBox = Hive.box<int>("gold_box");
    fishyBox = Hive.box('fishy_box');
    rng = Random();
    randomName = new RandomName();
    evilFishies = List<EnemyFish>();
    bubbles = List<Bubble>();
    jellies = List<JellyFish>();
    foods = List<Food>();
    resize(await Flame.util.initialDimensions());
    background = Ocean(this);
    bubbleSpawner = BubbleSpawner(this);
    jellyFishSpawner = JellyFishSpawner(this);
    fishies = _reloadFishies();
  }

  void resize(Size size) {
    screenSize = size;
    super.resize(size);
    tileSize = screenSize.width / 9;
  }

  void render(Canvas canvas) {
    if (canvas != null) {
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
      jellies.forEach((JellyFish jelly) => jelly.render(canvas));
    }
  }

  void update(double t) {
    bubbleSpawner.update(t);
    jellyFishSpawner.update(t);
    fishies.forEach((Fish fish) => fish.update(t));
    evilFishies.forEach((EnemyFish enemyFish) => enemyFish.update(t));
    bubbles.forEach((Bubble bubble) => bubble.update(t));
    bubbles.removeWhere((Bubble bubble) => bubble.isOffScreen);
    foods.forEach((Food food) => food.update(t));
    jellies.forEach((JellyFish jellies) => jellies.update(t));
  }

  void summonFishy(FishStyle style) {
    Fish fishy;
    double x = (screenSize.width - tileSize);
    double y = (screenSize.height - tileSize);
    switch (style) {
      case FishStyle.red:
        fishy = RedFish(this, x, y);
        break;
      case FishStyle.blue:
        fishy = BlueFish(this, x, y);
        break;
      case FishStyle.green:
        fishy = GreenFish(this, x, y);
        break;
      case FishStyle.purple:
        fishy = PurpleFish(this, x, y);
        break;
    }
    fishies.add(fishy);
    _addFishyToBox(fishy);
    ui.updateSelectedFishyName();
  }

  void summonEnemyFishy() {
    double x = .8 * (screenSize.width - tileSize);
    double y = .4 * (screenSize.height - tileSize);
    if (rng.nextDouble() < .5) {
      evilFishies.add(MudFish(this, x, y, tileSize, tileSize));
      evilFishies[0].fishName = "MudFish";
    } else {
      evilFishies.add(BulletFish(this, x, y, tileSize * 2, tileSize));
      evilFishies[0].fishName = "Bulletfish";
    }
  }

   // Update the number for gold
  void updateGold(int gil) {
    goldBox.put("gold", (goldBox.get("gold") + gil));
  }

  // This is Fixable Feb 5th
  _reloadFishies() {
    List<Fish> oldChums = List<Fish>();
    Fish fishy;
    double x = 20;
    double y = 20;

    for (int f = 0; f < fishyBox.length; f++) {
      FishData data = fishyBox.get(f);
      FishStyle style = EnumToString.fromString(FishStyle.values, "red");

      switch (style) {
        case FishStyle.red:
          fishy = RedFish(this, x, y);
          break;
        case FishStyle.blue:
          fishy = BlueFish(this, x, y);
          break;
        case FishStyle.green:
          fishy = GreenFish(this, x, y);
          break;
        case FishStyle.purple:
          fishy = PurpleFish(this, x, y);
          break;
      }
      fishy.fishId = data.id;
      fishy.fishName = data.name;
      fishy.fishHP = data.hp;
      fishy.fishExp = data.exp;
      oldChums.add(fishy);
    }
    return oldChums;
  }

  _addFishyToBox(Fish fishy) {
    FishData data = new FishData();
    data.id = fishy.fishId;
    data.name = fishy.fishName;
    data.hp = fishy.fishHP;
    data.exp = fishy.fishExp;
    data.type = fishy.type;
    fishyBox.add(data);
  }

  void summonBubble() {
    double x = rng.nextDouble() * (screenSize.width * 1.5);
    double y = (screenSize.height);
    bubbles.add(BubbleBlue(this, x, y));
  }

  void summonJellyFish() {
    double x = rng.nextDouble() * (screenSize.width - tileSize);
    double y = screenSize.height;
    jellies.add(JellyFish(this, x, y));
  }

  // Food pellets need a lot of work
  void summonFood() {
    double x = screenSize.width / 2;
    Food food;
    food = (BasicFood(this, x, 0));
    foods.add(food);
    food = (BasicFood(this, rng.nextInt(80) + (screenSize.width / 2),
        -rng.nextInt(20) + 1.0));
    foods.add(food);
    food = (BasicFood(this, rng.nextInt(80) + (screenSize.width / 2),
        -rng.nextInt(40) + 1.0));
    foods.add(food);
    food = (BasicFood(this, rng.nextInt(80) + (screenSize.width / 2),
        -rng.nextInt(20) + 1.0));
    foods.add(food);
    food = (BasicFood(this, rng.nextInt(80) + (screenSize.width / 2),
        -rng.nextInt(20) + 1.0));
    foods.add(food);
    food = (BasicFood(this, rng.nextInt(80) + (screenSize.width / 2),
        -rng.nextInt(30) + 1.0));
    foods.add(food);
    food = (BasicFood(this, rng.nextInt(80) + (screenSize.width / 2),
        -rng.nextInt(35) + 1.0));
    foods.add(food);
  }

  void increaseSize() {
    fishies.forEach((Fish fishy) {
      // if (fishy.fishId == ) {
      //   fishy.increaseSize();
      // }
    });
  }

  void onTapDown(TapDownDetails d) {
    // bool for preventing resource waste
    bool isHandled = false;

    if (!isHandled && ui.currentScreen == UIScreen.home) {
      fishies.forEach((Fish fishy) {
        if (fishy.fishRect.inflate(10).contains(d.globalPosition)) {
          fishy.onTapDown();
          selectedFishName = fishy.fishName;
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

 
}
