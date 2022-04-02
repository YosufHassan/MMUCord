//@dart =2.9
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mmucord/theme.dart';

class Logo extends StatelessWidget {
  const Logo();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isLightTheme(context)?Image.asset('assets/logo_light.png',fit: BoxFit.fill) : Image.asset('assets/logo_dark.png',fit: BoxFit.fill) ,
    );
  }
}
