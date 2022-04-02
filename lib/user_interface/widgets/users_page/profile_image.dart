//@dart = 2.9

import 'package:flutter/material.dart';
import 'package:mmucord/user_interface/widgets/common/online_indicator.dart';

class ProfileImageW extends StatelessWidget {
  final String url;
  final bool online;
  const ProfileImageW({this.url, this.online = false}); // set default online to false

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(backgroundColor: Colors.transparent,child: Stack(fit: StackFit.expand,children: [ClipRRect(borderRadius: BorderRadius.circular(126.0),child: Image.network(url,width: 126,height: 126,fit: BoxFit.fill,),),Align(alignment: Alignment.topRight,child: online?OnlineIndicatorW():Container(),)]),);
  }
}
