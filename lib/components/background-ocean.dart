import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:fish_tank/fish_tank_game.dart';

class Ocean {
  final FishTankGame game;
  Sprite bgSprite;
  Rect bgRect; 

  Ocean(this.game) {
    bgSprite = Sprite('background-fish-tank.png');
    bgRect = Rect.fromLTWH(
      0, 
      game.screenSize.height - (game.tileSize * 23),
      game.tileSize * 9,
      game.tileSize * 23
    );
  }

  void render(Canvas c) {
    bgSprite.renderRect(c, bgRect); 
  }

  void update(double t) {}
}
