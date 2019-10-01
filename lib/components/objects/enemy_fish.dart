import 'dart:ui';
import 'package:fish_tank/fish_tank_game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/widgets.dart';

enum EnemyFishStatus {
  normal, attacking, returning, power, dead
}

class EnemyFish {
  final FishTankGame game;
  Rect fishRect;
  List<Sprite> fishSprite;
  double fishId;
  double fishSpriteIndex = 0; 
  double fishSizeNumber = 1; 
  bool wasTapped = false;
  EnemyFishStatus fishStatus = EnemyFishStatus.normal;  
  Offset targetLocation;
  double x, y;

  double get fishSpeed => game.tileSize * .1;  

  // Personal stats
  String fishName;
  int fishHP = 20;
  int fishMP = 5;
  int fishStr = 12;
  int fishDef = 5;
  int fishInt = 5;
  int fishiness = 5;
  int fishLuck = 0; 
  int fishExp = 0; 

  EnemyFish(this.game, double x, double y) {
    setDefaultLocation();
    fishRect = Rect.fromLTWH(x, y, game.tileSize, game.tileSize); 
  }

  void render(Canvas c) {
    fishSprite[fishSpriteIndex.toInt()].renderRect(c, fishRect.inflate(fishSizeNumber));
  }

  void setDefaultLocation() {
    // This controls the Fish's movement. How to make him move in place?
    x = .8 * (game.screenSize.width - game.tileSize); 
    y = .4 * (game.screenSize.height - game.tileSize); 
    targetLocation = Offset(x, y); 
  }

  void setRandomLocation() {
    x = game.rnd.nextInt(10) + .8 * (game.screenSize.width - game.tileSize); 
    y = game.rnd.nextInt(10) + .4 * (game.screenSize.height - game.tileSize); 
    targetLocation = Offset(x, y); 
  }

  // set fishy up to move slightly then move back to his original position
  void update(double t) {
    if (fishStatus == EnemyFishStatus.normal) {
      double stepDistance = fishSpeed * t; 
      Offset toTarget = targetLocation - Offset(fishRect.left, fishRect.top); 

      if (stepDistance < toTarget.distance) {
        Offset stepToTarget = Offset.fromDirection(toTarget.direction, stepDistance);
        fishRect = fishRect.shift(stepToTarget);
      }
      if (stepDistance > toTarget.distance) {
        setRandomLocation(); 
      } else if (stepDistance > toTarget.distance) {
        setDefaultLocation(); 
      }
      
    } else if (fishStatus == EnemyFishStatus.attacking) {
      double stepDistance = fishSpeed * 80 * t; 
      targetLocation = Offset(80, 300);
      Offset toTarget = targetLocation - Offset(fishRect.left, fishRect.top); 
      if (stepDistance < toTarget.distance) {
        Offset stepToTarget = Offset.fromDirection(toTarget.direction, stepDistance); 
        fishRect = fishRect.shift(stepToTarget);
      } else {
        Offset stepToTarget = Offset.fromDirection(toTarget.direction, stepDistance);
        fishRect = fishRect.shift(stepToTarget);
        fishStatus = EnemyFishStatus.returning; 
      }

    } else if (fishStatus == EnemyFishStatus.returning) {
      double stepDistance = fishSpeed * t * 80; 
      Offset toTarget = targetLocation - Offset(fishRect.left, fishRect.top); 

      if (stepDistance < toTarget.distance) {
        Offset stepToTarget = Offset.fromDirection(toTarget.direction, stepDistance);
        fishRect = fishRect.shift(stepToTarget);
      }
      if (stepDistance > toTarget.distance) {
        setDefaultLocation();
      } else if (stepDistance > toTarget.distance) {
        fishStatus = EnemyFishStatus.normal;
      } 

    } else if (fishStatus == EnemyFishStatus.power) {
    } else if (fishStatus == EnemyFishStatus.dead) {
      fishRect = fishRect.translate(0, -(game.tileSize * t)); 
    }
    wasTapped = false; 
  }

  void onTapDown() {
    wasTapped = true; 
  }
}