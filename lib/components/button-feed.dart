import 'dart:ui';
import 'package:flame/sprite.dart';
import 'package:fish_tank/fish_tank_game.dart';

class FeedButton {
  final FishTankGame game;
  Rect rect;
  Sprite sprite;

  // Constructor creates rect for sprite
  FeedButton(this.game) {
    rect = Rect.fromLTWH(
        game.tileSize * 5, (game.screenSize.height * .65), 150, 75);
    sprite = (Sprite('button-feed.png'));
  }

  // render method renders sprite using canvas
  void render(Canvas c) {
    sprite.renderRect(c, rect);
  }

  void update(double t) {}

  void onTapDown() {
  }
}
