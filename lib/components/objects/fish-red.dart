import 'package:flame/sprite.dart';
import 'package:fish_tank/components/objects/fish.dart';
import 'package:fish_tank/fish_tank_game.dart';

class RedFish extends Fish {
  RedFish(FishTankGame game, double x, double y,
                       double width, double height, String name) : super(game, x, y, width, height) {
    String fishName = name; 
    fishSprite = List<Sprite>();
    fishSprite.add(Sprite('fish-sprite-2-L.png'));
    fishSprite.add(Sprite('fish-sprite-2-R.png')); 
  }
}