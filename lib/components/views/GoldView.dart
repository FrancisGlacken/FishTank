import 'package:flutter/widgets.dart';
import 'package:fish_tank/fish_tank_game.dart';

class GoldView extends StatelessWidget {
  const GoldView({
    Key key,
    @required this.game,
  }) : super(key: key);

  final FishTankGame game;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(game.gold.toString(),
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20,
              color: Color(0xffffffff),
            )));
  }
}