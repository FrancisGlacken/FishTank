import 'package:flame/sprite.dart';
import 'package:fish_tank/components/objects/fish.dart';
import 'package:fish_tank/fish_tank_game.dart';

class GreenFish extends Fish {
  GreenFish(FishTankGame game, double x, double y,
                       double width, double height) : super(game, x, y, width, height) {
    fishSprite = List<Sprite>();
    fishSprite.add(Sprite('fish-sprite-4-L.png'));
    fishSprite.add(Sprite('fish-sprite-4-R.png')); 
  }
}