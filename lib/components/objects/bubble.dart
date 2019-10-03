import 'dart:ui';
import 'package:fish_tank/fish_tank_game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';
import 'package:flame/flame.dart'; 

class Bubble {
  final FishTankGame game;
  Rect bubbleRect; 
  List<Sprite> bubbleSprite;
  bool isOffScreen = false; 
  Random rand; 
  
  bool wasTapped = false; 

  Bubble(this.game, double x, double y) {
    rand = new Random(); 
    bubbleRect = Rect.fromLTWH(x, y, game.tileSize, game.tileSize); 
  }

  void render(Canvas c) {
    if (!wasTapped) {
      bubbleSprite[0].renderRect(c, bubbleRect.inflate(1));
    }
  }

  void update(double t) {
    bubbleRect = bubbleRect.translate(0, -(game.tileSize * .0150)); 
    if (bubbleRect.top > game.screenSize.height) {
      isOffScreen = true; 
    }
  }

  void onTapDown() {
    // Pop the bubble!
    wasTapped = true; 
    isOffScreen = true;
    Flame.audio.play('sfx/bubble-pop-1.wav');
  }
}