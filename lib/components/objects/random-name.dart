import 'dart:math';

class RandomName {
  String name; 
  Random rng = new Random(); 
  List<String> listOfNames; 
  

  RandomName() {
    listOfNames = [
      "Blinky",
      "Cleo",
      "Dory",
      "Darwin",
      "Gyopi",
      "Jabberjaw",
      "Kenny",
      "Misterjaw",
      "Nemo",
      "Mrs. Puff",
      "Winnie",
      "Mr. Fish",
      "Sherman",
      "Ecco",
      "Android 15"];
  }

  randomizeName() {
    name = listOfNames[rng.nextInt(15)]; 
    return name; 
  }
}