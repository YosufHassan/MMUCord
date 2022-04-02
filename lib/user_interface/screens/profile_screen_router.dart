//@dart =2.9

import 'package:chat/chat.dart';
import 'package:flutter/material.dart';

abstract class IProfileScreenRouter {
  void onPageInset(BuildContext context, User me);
}

class ProfileScreenRouter implements IProfileScreenRouter {
  final Widget Function(User me) onSessionConnected;

  ProfileScreenRouter({@required this.onSessionConnected});

  @override
  void onPageInset(BuildContext context, User me) {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => onSessionConnected(me)));
  }
}
