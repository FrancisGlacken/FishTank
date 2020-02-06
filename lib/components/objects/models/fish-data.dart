import 'package:hive/hive.dart';

part 'fish-data.g.dart';

@HiveType(typeId: 0)
class FishData {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  int hp;
  @HiveField(3)
  int exp; 
  @HiveField(4)
  String type; 

  FishData({this.id, this.name, this.hp, this.exp, this.type});

  Map<String,dynamic> get dataMap {
    return {
      "id": id,
      "name": name,
      "hp": name,
      "exp": hp,
      "type": type
    };
  }
}