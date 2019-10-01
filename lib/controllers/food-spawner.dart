import 'package:fish_tank/fish_tank_game.dart';
import 'package:fish_tank/components/objects/food.dart';

class FoodSpawner {
  final FishTankGame game;
  int nextSpawn;
  int currentInterval;
  int maxSpawnInterval, minSpawnInterval, intervalChange;  

  FoodSpawner(this.game) {
    start(); 
  }
  // Three specs of food at a time from three random locations at the top
  // It will fall slow enough that the fishy has time to eat that stuff
  // Once the fishy is done eating anyone of the thingies, it gets bigger.
  // There should be sound effects for ti
  // The fishy should 
  void start() {
    currentInterval = maxSpawnInterval;
    nextSpawn = DateTime.now().millisecondsSinceEpoch + currentInterval; 
  }

  void update(double t) {
    int currentTimestamp = DateTime.now().millisecondsSinceEpoch; 

    if (currentTimestamp >= nextSpawn) {
      game.summonBubble();
      if (currentInterval > minSpawnInterval) {
        currentInterval -= intervalChange;
        currentInterval -= (currentInterval * .02).toInt();
      }
      nextSpawn = currentTimestamp + currentInterval; 
    }
  }


  
}