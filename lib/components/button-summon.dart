import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:fish_tank/fish_tank_game.dart';

class SummonButton {
  final FishTankGame game;
  Rect rect;
  Sprite sprite;

  SummonButton(this.game) {
    rect = Rect.fromLTWH(
      game.tileSize * .75,
      (game.screenSize.height * .9),
      game.tileSize * 1,
      game.tileSize * 1,
    );
    sprite = Sprite('button-quick.png');
  }

  void render(Canvas c) {
    sprite.renderRect(c, rect);
  }

  void update(double t) {}

  void onTapDown() {

  }
}
