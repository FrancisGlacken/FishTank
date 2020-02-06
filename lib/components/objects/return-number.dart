import 'dart:math';

class ReturnNumber { 

  Random rand = new Random(); 
  int xyz;

  ReturnNumber() {
    rand = new Random();
    xyz = 100 * rand.nextInt(50);
  }

  
}