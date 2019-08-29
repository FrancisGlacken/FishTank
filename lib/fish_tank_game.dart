import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'dart:ui';
import 'package:fish_tank/components/objects/fish.dart';
import 'dart:math';
import 'package:fish_tank/components/objects/cheep-red.dart';
import 'package:fish_tank/components/objects/cheep-green.dart';
import 'package:fish_tank/components/objects/cheep-blue.dart';
import 'package:fish_tank/components/objects/cheep-white.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:fish_tank/components/button-feed.dart';
import 'package:fish_tank/fish_tank_ui.dart';
import 'package:fish_tank/components/objects/enemy_fish.dart';



class FishTankGame extends Game {
  final FishTankUIState ui; 
  Size screenSize;
  double tileSize;
  Random rnd;
  bool isHandled = false;
  double growRate = 1;  
  List<Fish> fishies; 
  List<EnemyFish> evilFishies; 
  Fish fishy; 

  FishTankGame(this.ui) {
    initialize(); 
  }

  void initialize() async {
    rnd = Random();
    fishies = List<Fish>(); 
    evilFishies = List<EnemyFish>(); 
    resize(await Flame.util.initialDimensions());
    summonFishy(); 

  }

  void resize(Size size) {
    screenSize = size;
    super.resize(size);
    tileSize = screenSize.width / 9;
  }

  void summonFishy() {
   double x = rnd.nextDouble() * (screenSize.width - tileSize);
   double y = rnd.nextDouble() * (screenSize.height - tileSize);
   fishy = CheepWhite(this, x, y); 
   fishies.add(fishy); 
  }

  //Implement this
  void start() {

  }

  // Attempts to update fish size by calling a if statement in the update method of the fishy
  void growFishy() {
    growRate = growRate * 1.1; 
    fishy.fishSizeMulti = fishy.fishSizeMulti * growRate; 
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
    //fishy.render(canvas);
    fishies[0].render(canvas);
    if (evilFishies.length > 0) {
      evilFishies[0].render(canvas);
    }

  }

  void update(double t) {
    //fishy.update(t);
    fishies.forEach((Fish fish) => fish.update(t));
  }


  void onTapDown(TapDownDetails d) {
    // bool for preventing resource waste
    bool isHandled = false;

    if (!isHandled) {
      isHandled = true;
        if (fishy.fishRect.contains(d.globalPosition)) {
          fishy.onTapDown();
          isHandled = true; 
        }
      
    }
  }
}
