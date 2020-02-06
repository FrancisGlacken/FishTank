import 'dart:ui';
import 'package:fish_tank/fish_tank_game.dart';
import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';
import 'package:flutter/widgets.dart';

import 'random-name.dart';

enum FishLocation { home, feed, battle, attackAnim, journey }

class Fish {
  final FishTankGame game; 
  Rect fishRect;
  List<Sprite> fishSprite;
  int fishSpriteIndex; 
  Offset targetLocation;
  FishLocation fishLocation = FishLocation.home; 
  bool wasTapped = false; 
  double fishSizeNumber = 1; 
  double growRate = 1;
  RandomName randomName = new RandomName(); 

  

  // Personal stats
  int fishId; 
  String fishName = "my fishy"; 
  String type = "type"; 
  int fishHP = 100; 
  int fishMP = 20;
  int fishStr = 10;
  int fishDef = 5; 
  int fishInt = 3; 
  int fishiness = 7;
  int fishLuck = 8; 
  int fishExp = 0;  
  
  // Why is this a getter?
  double get fishSpeed => game.tileSize * 1;  
  double get fishSizeMulti => 1; 

  set fishSizeMulti(double multiplier) {
    fishSizeNumber = fishSizeMulti * multiplier; 
  }

  // Add width/height
  Fish(this.game, double x, double y) {
    setTargetLocation();
    fishRect = Rect.fromLTWH(x, y, 20, 20);
    fishName = randomName.randomizeName();
  }

  void setTargetLocation() {
    double yAxisRng = game.rng.nextDouble(); 
    if (yAxisRng < .03) { yAxisRng += .03; }
    double x = game.rng.nextDouble() * (game.screenSize.width - (game.tileSize));
    double y = yAxisRng * (game.screenSize.height - (game.tileSize));
    targetLocation = Offset(x, y);
  }

  void setFeedTargetLocation() {
    targetLocation = Offset(game.foods[game.foods.length - 1].x, game.tileSize * 8);
  }

  void render(Canvas c) {
    if (targetLocation.direction >= 1) {
    fishSprite[0].renderRect(c, fishRect.inflate(fishSizeNumber));       
    } else if (targetLocation.direction < 1) {
    fishSprite[1].renderRect(c, fishRect.inflate(fishSizeNumber)); 
    }
  }

  // This is bunk, make it better
  void update(double t) {
    // home animation
    if (fishLocation == FishLocation.home) {
      double stepDistance = fishSpeed * t;
      Offset toTarget = targetLocation - Offset(fishRect.left, fishRect.top);
      if (!wasTapped && stepDistance < toTarget.distance) {
        Offset stepToTarget = Offset.fromDirection(toTarget.direction, stepDistance);
        fishRect = fishRect.shift(stepToTarget);
      } else {
      if (!wasTapped) {
        fishRect = fishRect.shift(toTarget);        
      }
      setTargetLocation(); 
      }

    } else if (fishLocation == FishLocation.feed) {
      if (game.foods.length > 0) {
       double stepDistance = fishSpeed * t; 
       setFeedTargetLocation();
       Offset toTarget = targetLocation - Offset(fishRect.left, fishRect.top); 
       if (stepDistance < toTarget.distance) {
          Offset stepToTarget = Offset.fromDirection(toTarget.direction, stepDistance); 
          fishRect = fishRect.shift(stepToTarget); 
          setFeedTargetLocation(); 
        }
      }
      // Future.delayed(const Duration(milliseconds: 1000), () {
      //   // Arrange animations better
      // });

       
    } else if (fishLocation == FishLocation.battle) {
      double stepDistance = fishSpeed * t * 15;
      targetLocation = Offset(80, 300);
      Offset toTarget = targetLocation - Offset(fishRect.left, fishRect.top);
      if (!wasTapped && stepDistance < toTarget.distance) {
        Offset stepToTarget = Offset.fromDirection(toTarget.direction, stepDistance);
        fishRect = fishRect.shift(stepToTarget);
      } else {
      if (!wasTapped) {fishRect = fishRect.shift(toTarget); }
      }

    } else if (fishLocation == FishLocation.attackAnim) {
      double stepDistance = fishSpeed * 4 * t; 
      targetLocation = Offset(.8 * (game.screenSize.width - game.tileSize), 
                              .4 * (game.screenSize.height - game.tileSize)); 
      Offset toTarget = targetLocation - Offset(fishRect.left, fishRect.top); 
      if (stepDistance < toTarget.distance) {
        Offset stepToTarget = Offset.fromDirection(toTarget.direction, stepDistance);
        fishRect = fishRect.shift(stepToTarget); 
      } else {
        Offset stepToTarget = Offset.fromDirection(toTarget.direction, stepDistance);
        fishRect = fishRect.shift(stepToTarget);
        fishLocation = FishLocation.battle;  
      }
    }
    wasTapped = false; 
  }

  void onTapDown() {
    Flame.audio.play('sfx/bubble-pop-2.wav');
    wasTapped = true; 
  }

  void increaseSize() {
    growRate = growRate + (growRate * .1);
    fishExp = (growRate * 10).toInt(); 
    fishSizeMulti = fishSizeMulti * growRate;
  }
}