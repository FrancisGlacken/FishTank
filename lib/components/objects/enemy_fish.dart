import 'dart:ui';
import 'package:fish_tank/fish_tank_game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/widgets.dart';

class EnemyFish {
  final FishTankGame game;
  Rect fishRect;
  List<Sprite> fishSprite;
  double fishId;
  double fishSpriteIndex = 0; 
  double fishSizeNumber = 1; 
  bool wasTapped = false; 

  // Personal stats
  String fishName;
  int fishHP = 20;
  int fishMP = 5;
  int fishStr = 5;
  int fishDef = 5;
  int fishInt = 5;
  int fishiness = 5;
  int fishLuck = 0; 
  int fishExp = 0; 

  EnemyFish(this.game, double x, double y) {
    fishRect = Rect.fromLTWH(x, y, game.tileSize, game.tileSize); 
  }

  void render(Canvas c) {
    fishSprite[fishSpriteIndex.toInt()].renderRect(c, fishRect.inflate(fishSizeNumber));

  }

  void update(double t) {
    wasTapped = false; 
  }

  void onTapDown() {
    wasTapped = true; 
  }
}