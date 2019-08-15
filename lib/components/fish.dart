import 'dart:ui';
import 'package:fish_tank/fish_tank_game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/widgets.dart';

class Fish {
  final FishTankGame game; 
  Rect fishRect;
  List<Sprite> fishSprite;
  Sprite fishSpriteAlt;
  double fishId; 
  double fishSpriteIndex = 0; 
  Offset targetLocation;
  double fishSizeNumber = 1; 
  bool wasTapped = false; 

  // Personal stats
  String fishName;
  int fishHP; 
  int fishExp; 
  int fishPower;
  int fishDefense; 
  int fishCharisma; 
  
  double get fishSpeed => game.tileSize * 1; 
  double get fishSizeGrowing => game.tileSize * 1; 
  double get fishSizeMulti => 1; 

  set fishSizeMulti(double multiplier) {
    fishSizeNumber = fishSizeMulti * multiplier; 
  }

  Fish(this.game, double x, double y) {
    setTargetLocation();
    fishRect = Rect.fromLTWH(x, y, game.tileSize, game.tileSize);
  }

  void setTargetLocation() {
        double x = game.rnd.nextDouble() * (game.screenSize.width - (game.tileSize));
        double y = game.rnd.nextDouble() * (game.screenSize.height - (game.tileSize));
        targetLocation = Offset(x, y);
  }

  void render(Canvas c) {
    // As for flyingSpriteIndex.toInt(), List and array items are accessed 
    // by an integer index. Our flyingSpriteIndex is a double though, so we
    // need to convert it into an int first. This variable is a double because 
    //we will increment it using values from the time delta (which is a double) 
    // in the update method as you will see later. The last part, .inflate(2), 
    // just creates a copy of the rectangle it was called on but inflated to a 
    // multiplier (in this case two) from the center. We use two as our value 
    // because if you look at the fly sizing image above, you’ll see that the 
    // blue box (sprite box) is double the size of the red box (hit box).
    fishSprite[fishSpriteIndex.toInt()].renderRect(c, fishRect.inflate(fishSizeNumber)); 
  }

  void update(double t) {
    double stepDistance = fishSpeed * t;
    Offset toTarget = targetLocation - Offset(fishRect.left, fishRect.top);
    if (!wasTapped && stepDistance < toTarget.distance) {
      Offset stepToTarget = Offset.fromDirection(toTarget.direction, stepDistance);
      fishRect = fishRect.shift(stepToTarget);
    } else {
      if (!wasTapped) {
        fishRect = fishRect.shift(toTarget);        
      }
      setTargetLocation(); 
    }
    wasTapped = false; 
  }

  void onTapDown() {
    wasTapped = true; 
  }
}