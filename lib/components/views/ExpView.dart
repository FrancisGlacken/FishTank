import 'package:flutter/widgets.dart';

class ExpView extends StatelessWidget {
  const ExpView({
    Key key,
    @required this.fishyExp,
  }) : super(key: key);

  final int fishyExp;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 5,
      top: 65,
      child: Text(
            "EXP: " + fishyExp.toString(),
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 20,
              color: Color(0xffffffff),
            ),),
    );
  }
}