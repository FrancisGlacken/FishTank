import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:fish_tank/fish_tank_game.dart';

class ConsumeButton{
  final FishTankGame game;
  Rect rect;
  Sprite sprite;

  // Constructor creates rect for sprite
  ConsumeButton(this.game) {
    rect = Rect.fromLTWH(
        game.tileSize * 5, (game.screenSize.height * .75), 150, 75);
    sprite = (Sprite('button-consume.png'));
  }

  void render(Canvas c) {
    sprite.renderRect(c, rect);
  }

  void update(double t) {}

  void onTapDown() {

  }
}