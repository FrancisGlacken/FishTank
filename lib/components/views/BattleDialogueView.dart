import 'package:flutter/widgets.dart';
import 'package:fish_tank/fish_tank_game.dart';

class BattleDialogueView extends StatelessWidget {
  const BattleDialogueView({
    Key key,
    @required this.game,
    @required this.battleDialogue,
  }) : super(key: key);

  final FishTankGame game;
  final String battleDialogue;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      width: game.screenSize.width,
      bottom: 120,
      child: Text(
        battleDialogue,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          color: Color(0xffffffff),
        ),
      ),
    );
  }
}