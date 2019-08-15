import 'package:fish_tank/components/button-consume.dart';
import 'package:fish_tank/components/button-journey.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'dart:ui';
import 'package:fish_tank/components/fish.dart';
import 'dart:math';
import 'package:fish_tank/components/cheep-red.dart';
import 'package:fish_tank/components/cheep-green.dart';
import 'package:fish_tank/components/cheep-blue.dart';
import 'package:fish_tank/components/cheep-white.dart';
import 'package:fish_tank/components/button-summon.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:fish_tank/components/button-feed.dart';
import 'package:fish_tank/fish_tank_ui.dart';



class FishTankGame extends Game {
  final FishTankUIState ui; 
  Size screenSize;
  double tileSize;
  List<Fish> fishies;
  Random rnd;
  SummonButton summonButton;
  FeedButton feedButton;
  ConsumeButton consumeButton;
  JourneyButton journeyButton; 
  bool isHandled = false;
  double growRate = 1;  

  FishTankGame(this.ui) {
    initialize();
  }

  void initialize() async {
    fishies = List<Fish>();
    rnd = Random();
    resize(await Flame.util.initialDimensions());

    summonButton = SummonButton(this);
    feedButton = FeedButton(this);
    consumeButton = ConsumeButton(this); 
    journeyButton = JourneyButton(this); 
    summonFishy();
  }

  void summonFishy() {
    double x = rnd.nextDouble() * (screenSize.width - tileSize * 2.025);
    double y = rnd.nextDouble() * (screenSize.height - tileSize * 2.025);

    switch (rnd.nextInt(4)) {
      case 0:
        fishies.add(CheepRed(this, x, y));
        break;
      case 1:
        fishies.add(CheepGreen(this, x, y));
        break;
      case 2:
        fishies.add(CheepBlue(this, x, y));
        break;
      case 3:
        fishies.add(CheepWhite(this, x, y));
        break;
    }
  }

  // Attempts to update fish size by calling a if statement in the update method of the fishy
  void growFishy() {
    growRate = growRate * 1.1; 
    fishies.forEach((Fish fish) {
      fish.fishSizeMulti = fish.fishSizeMulti * growRate; 
    }); 
  }

  void render(Canvas canvas) {
    // Declare a rectangle as big as the screen
    Rect bgRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
    // Dclare a paint object and assign color to it
    Paint bgPaint = Paint();
    bgPaint.color = Color(0xFF3300FF);
    // Draw the rectangle to the screen
    canvas.drawRect(bgRect, bgPaint);
    // Spawn fishies
    fishies.forEach((Fish fish) => fish.render(canvas));

    feedButton.render(canvas);
    consumeButton.render(canvas);
    journeyButton.render(canvas); 
    summonButton.render(canvas);
  }

  void update(double t) {
    fishies.forEach((Fish fish) => fish.update(t));
  }

  void resize(Size size) {
    screenSize = size;
    super.resize(size);
    tileSize = screenSize.width / 9;
  }

  void onTapDown(TapDownDetails d) {
    // bool for preventing resource waste
    bool isHandled = false;

    Rect tempRect;

    if (!isHandled && summonButton.rect.contains(d.globalPosition)) {
      summonFishy();
      //summonButton.onTapDown();
      isHandled = true;
    }

    if (!isHandled && feedButton.rect.contains(d.globalPosition)) {
      growFishy(); 
      isHandled = true; 
    }

    if (!isHandled) {
      isHandled = true;
      fishies.forEach((Fish fish) {
        if (fish.fishRect.contains(d.globalPosition)) {
          fish.onTapDown();
          isHandled = true; 
        }
      });
    }
  }
}
