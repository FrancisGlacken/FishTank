import 'package:flame/sprite.dart';
import 'package:fish_tank/components/objects/fish.dart';
import 'package:fish_tank/fish_tank_game.dart';

class CheepRed extends Fish {
  CheepRed(FishTankGame game, double x, double y, double w, double h) : super(game, x, y, w, h) {
    fishSprite = List<Sprite>();
    fishSprite.add(Sprite('cheep-red.png'));
    fishSprite.add(Sprite('cheep-red-right.png'));

  }
}