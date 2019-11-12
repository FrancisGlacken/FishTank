import 'package:fish_tank/fish_tank_game.dart';

class JellyFishSpawner {
  final FishTankGame game; 
  final int maxSpawnInterval = 20000;
  final int minSpawnInterval = 18000;
  final int intervalChange = 3;
  int currentInterval; 
  int nextSpawn; 

  JellyFishSpawner(this.game) {
    start();
  }

  void start() {
    currentInterval = maxSpawnInterval;
    nextSpawn = DateTime.now().millisecondsSinceEpoch + currentInterval; 
  }

  void update(double t) {
    int nowTimeStamp = DateTime.now().millisecondsSinceEpoch + currentInterval; 

    if (nowTimeStamp >= nextSpawn) {
      game.summonJellyFish(); 
      if (currentInterval > minSpawnInterval) {
        currentInterval -= intervalChange; 
        currentInterval -= (currentInterval * .15).toInt(); 
      }
      nextSpawn = nowTimeStamp + currentInterval; 
      
    }
  }

  
}