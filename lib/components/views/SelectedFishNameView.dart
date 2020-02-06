import 'package:flutter/widgets.dart';

class SelectedFishNameView extends StatelessWidget {
  const SelectedFishNameView({
    Key key,
    @required this.fishName,
  }) : super(key: key);

  final String fishName;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 5,
      top: 25,
      child: Text(
          fishName != null ? fishName:'My Fishy',
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 20,
            color: Color(0xffffffff),
          )),
    );
  }
}