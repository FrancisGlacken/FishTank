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
  bool wasConsumed = false; 
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
    // THERE IS NO ID here "50"
    if (foodRect.overlaps(game.fishies[50].fishRect)) {
      game.increaseSize();
      wasConsumed = true; 
      game.foods.removeWhere((Food food) => food.wasConsumed == true);
    }

  }

  void onTapDown() {
    wasTapped = true; 
  }
}

//var rect1 = {x: 5, y: 5, width: 50, height: 50}
// var rect2 = {x: 20, y: 10, width: 10, height: 10}

// if (rect1.x < rect2.x + rect2.width &&
//    rect1.x + rect1.width > rect2.x &&
//    rect1.y < rect2.y + rect2.height &&
//    rect1.y + rect1.height > rect2.y) {
//     // collision detected!
// }