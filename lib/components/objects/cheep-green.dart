import 'package:flame/sprite.dart';
import 'package:fish_tank/components/objects/fish.dart';
import 'package:fish_tank/fish_tank_game.dart';

class CheepGreen extends Fish {
  CheepGreen(FishTankGame game, double x, double y, double w, double h, String name) : super(game, x, y, w, h, name) {
    fishSprite = List<Sprite>();
    fishSprite.add(Sprite('cheep-green.png'));
    fishSprite.add(Sprite('cheep-green-right.png'));

  }
}