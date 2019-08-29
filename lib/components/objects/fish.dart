import 'dart:ui';
import 'package:fish_tank/components/objects/enemy_fish.dart';
import 'package:fish_tank/fish_tank_game.dart';
import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';
import 'package:flutter/widgets.dart';

enum FishLocation { home, battle, attackAnim, journey }

class Fish {
  final FishTankGame game; 
  Rect fishRect;
  List<Sprite> fishSprite;
  Sprite fishSpriteAlt;
  double fishId; 
  double fishSpriteIndex = 0; 
  Offset targetLocation;
  double fishSizeNumber = 1; 
  bool wasTapped = false; 
  FishLocation fishLocation = FishLocation.home; 
  

  // Personal stats
  String fishName;
  int fishHP = 100; 
  int fishMP = 20;
  int fishStr = 8;
  int fishDef = 5; 
  int fishInt = 3; 
  int fishiness = 7;
  int fishLuck = 8; 
  int fishExp = 0;  
  
  double get fishSpeed => game.tileSize * 1;  
  double get fishSizeMulti => 1; 

  set fishSizeMulti(double multiplier) {
    fishSizeNumber = fishSizeMulti * multiplier; 
  }

  Fish(this.game, double x, double y) {
    setTargetLocation();
    fishRect = Rect.fromLTWH(x, y, game.tileSize, game.tileSize);
  }

  void setTargetLocation() {
        double x = game.rnd.nextDouble() * (game.screenSize.width - (game.tileSize));
        double y = game.rnd.nextDouble() * (game.screenSize.height - (game.tileSize));
        targetLocation = Offset(x, y);
  }

  void render(Canvas c) {
    fishSprite[fishSpriteIndex.toInt()].renderRect(c, fishRect.inflate(fishSizeNumber)); 
  }

  void update(double t) {
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

    } else if (fishLocation == FishLocation.battle) {
      double stepDistance = fishSpeed * t;
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
    Flame.audio.play('sfx/bubblebobble11.wav');
    wasTapped = true; 
  }
}