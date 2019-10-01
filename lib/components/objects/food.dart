import 'dart:ui';
import 'package:fish_tank/fish_tank_game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/widgets.dart';

class Food {
  final FishTankGame game; 
  Rect foodRect; 
  List<Sprite> foodSprite; 
  double foodSpeed;  
  bool isOffScreen = false; 
  bool wasTapped = false; 
  double x, y; 
  Offset foodOffset; 

  Food(this.game, double x, double y) {
    this.x = x;
    this.y = y; 
    foodRect = Rect.fromLTWH(x, y, 4, 4);
  }

  void render(Canvas canvas) {
    foodSprite[0].renderRect(canvas, foodRect);
  }

  void update(double t) {
    y = (game.tileSize * 1.5 * t); 
    foodOffset = Offset(0, y);
    foodRect = foodRect.shift(foodOffset);
  }

  void onTapDown() {
    wasTapped = true; 
  }
}