import 'package:flutter/widgets.dart';

class EnemyNameView extends StatelessWidget {
  const EnemyNameView({
    Key key,
    @required this.enemyFishName,
  }) : super(key: key);

  final String enemyFishName;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 5,
      top: 25,
      child: Text(
        enemyFishName,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 20,
          color: Color(0xffffffff),
        )
      )
    );
  }
}