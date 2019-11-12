import 'package:flame/sprite.dart';
import 'package:fish_tank/fish_tank_game.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui';
import 'dart:math';


class JellyFish {
  final FishTankGame game; 
  Rect jellyRect; 
  List<Sprite> jellySprite; 
  double jellySpriteIndex = 0; 
  Random rnd = new Random(); 
  int charge = -1; 
  
  JellyFish(this.game, double x, double y){
    init();
    jellyRect = Rect.fromLTWH(x, y, game.tileSize/2, game.tileSize/2);
  }

  void init() {
    jellySprite = List<Sprite>();
    jellySprite.add(Sprite('sprite-fish-jelly-1.png'));
    jellySprite.add(Sprite('sprite-fish-jelly-2.png'));
    jellySprite.add(Sprite('sprite-fish-jelly-3.png'));
    jellySprite.add(Sprite('sprite-fish-jelly-4.png'));
  }

  render(Canvas c) {
    jellySprite[jellySpriteIndex.toInt()].renderRect(c, jellyRect.inflate(1)); 
  }


  update(double t) {
    jellyRect = jellyRect.translate(rnd.nextDouble() * .2, -(game.tileSize * .009));
    //charge = charge * -1; 

    jellySpriteIndex += 3 * t;
    if (jellySpriteIndex >= 4) {
      jellySpriteIndex = 0; 
    } 

  }
}

//TODO: Make a full jellyfish class`