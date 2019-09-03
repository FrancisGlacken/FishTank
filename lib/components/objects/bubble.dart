import 'dart:ui';
import 'package:fish_tank/fish_tank_game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/widgets.dart';

class Bubble {
  final FishTankGame game;
  Rect bubbleRect; 
  List<Sprite> bubbleSprite;
  bool isOffScreen = false; 
  
  bool wasTapped = false; 

  Bubble(this.game, double x, double y) {
    bubbleRect = Rect.fromLTWH(x, y, game.tileSize, game.tileSize); 
  }

  void render(Canvas c) {
    bubbleSprite[0].renderRect(c, bubbleRect.inflate(1));
  }

  void update(double t) {
    bubbleRect = bubbleRect.translate(0, -(game.tileSize * 3 * t)); 
    if (bubbleRect.top > game.screenSize.height) {
      isOffScreen = true; 
    }
  }

  void onTapDown() {
    //wasTapped = true; 
  }
}