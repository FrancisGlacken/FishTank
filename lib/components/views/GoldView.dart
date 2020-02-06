import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

class GoldView extends StatelessWidget {
  GoldView({
    Key key,
  }) : super(key: key);

  final box = Hive.box<int>("gold_box");

  @override
  Widget build(BuildContext context) {
    return Center(
          child: Text(box.get("gold").toString(),
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 20,
                color: Color(0xffffffff),
              ))
    );
  }
}