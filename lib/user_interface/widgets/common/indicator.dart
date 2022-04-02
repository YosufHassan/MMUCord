//@dart=2.9
import 'package:flutter/material.dart';

import 'package:mmucord/theme.dart';

class Indicator extends StatelessWidget {
  final Color color;
  const Indicator(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20, width: 20, decoration: BoxDecoration(color: this.color,borderRadius: BorderRadius.circular(20.0),border: Border.all(width: 3.0,color: isLightTheme(context)?Colors.white:Colors.black)),
    );
  }
}