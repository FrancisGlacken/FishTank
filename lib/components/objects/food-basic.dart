import 'package:fish_tank/components/objects/food.dart';
import 'package:fish_tank/fish_tank_game.dart';
import 'package:flame/sprite.dart';

class BasicFood extends Food {
  BasicFood(FishTankGame game, double x, double y) : super(game, x, y) {
    foodSprite = List<Sprite>(); 
    foodSprite.add(Sprite('fish-food-1.png'));
  }
}