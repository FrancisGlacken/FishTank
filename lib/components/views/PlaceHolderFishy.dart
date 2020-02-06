import 'package:flutter/material.dart';
import 'package:fish_tank/fish_tank_game.dart';

class PlaceHolderFishy extends StatelessWidget {
  const PlaceHolderFishy({
    Key key,
    @required this.game,
  }) : super(key: key);

  final FishTankGame game;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        //blah
      },
      padding: EdgeInsets.all(0.0),
      child: Image.asset(
        'assets/images/cheep-white-right.png',
        width: game.tileSize * 3,
        height: 70,
      ),
    );
  }
}