import 'package:flutter/widgets.dart';

class HPView extends StatelessWidget {
  const HPView({
    Key key,
    @required this.fishyHP,
  }) : super(key: key);

  final int fishyHP;

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 5,
        top: 45,
        child: Text(
            "HP: " + fishyHP.toString(),
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20,
              color: Color(0xffffffff),
            )));
  }
}