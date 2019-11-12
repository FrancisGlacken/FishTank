import 'package:flutter/widgets.dart';

class EnemyHPView extends StatelessWidget {
  const EnemyHPView({
    Key key,
    @required this.enemyFishHP,
  }) : super(key: key);

  final int enemyFishHP;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        right: 5,
        top: 45,
        child: Text(
          "HP: " + enemyFishHP.toString(),
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20,
              color: Color(0xffffffff),
            )));
  }
}