import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:fish_tank/fish_tank_game.dart';

class JourneyButton{
  final FishTankGame game;
  Rect rect;
  Sprite sprite;

  // Constructor creates rect for sprite
  JourneyButton(this.game) {
    rect = Rect.fromLTWH(
        game.tileSize * 5, (game.screenSize.height * .85), 150, 75);
    sprite = (Sprite('button-journey.png'));
  }

  void render(Canvas c) {
    sprite.renderRect(c, rect);
  }

  void update(double t) {}

  void onTapDown() {
    game.summonFishy();
  }

}