//@dart=2.9
import 'package:flutter/material.dart';

import 'package:mmucord/constants.dart';
import 'package:mmucord/theme.dart';

class OnlineIndicatorW extends StatelessWidget {
  const OnlineIndicatorW();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15, width: 15, decoration: BoxDecoration(color: kIndicatorBubble,borderRadius: BorderRadius.circular(20.0),border: Border.all(width: 3.0,color: isLightTheme(context)?Colors.white:Colors.black)),
    );
  }
}