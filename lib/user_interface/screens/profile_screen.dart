//@dart = 2.9
import 'package:chat/chat.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mmucord/states_management/profile_screen/analytics_cubit.dart';
import 'package:mmucord/states_management/profile_screen/analytics_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmucord/user_interface/widgets/common/indicator.dart';
import 'package:mmucord/user_interface/widgets/common/online_indicator.dart';
import 'package:mmucord/user_interface/widgets/profile_screen/chart.dart';
import 'package:mmucord/user_interface/widgets/users_page/profile_image.dart';

class ProfileScreen extends StatefulWidget {
  //final IProfileScreenRouter router;
  final User me;
  const ProfileScreen(this.me);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  User _user;
  void initState() {
    super.initState();
    _user = widget.me;
    _initialSetup();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
              child: Container(
                width: double.infinity,
                height: 350.0,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      
                      ProfileImageW(url: _user.photoUrl, online: true),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        _user.username,
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.black,
                        ),
                      ),SizedBox(height: 10.0),
                      Row(
                        children: [
                          
                          BlocBuilder<analyticsCubit,analyticsState>(builder: (_,state)=>state is analyticsSent?Text(state.busy,style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold
                                      ),):Text("error")),

                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        clipBehavior: Clip.antiAlias,
                        color: Colors.white,
                        elevation: 5.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 22.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Sent",
                                      style: TextStyle(
                                        color: Color(0xFF185ADB),
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    BlocBuilder<analyticsCubit,analyticsState>(builder: (_,state)=>state is analyticsSent?Text(state.sentcount,style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.black,
                                      ),):Text("error")),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Recieved",
                                      style: TextStyle(
                                        color: Color(0xFF185ADB),
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    BlocBuilder<analyticsCubit,analyticsState>(builder: (_,state)=>state is analyticsSent?Text(state.recvcount,style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.black,
                                      ),):Text("error")),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "Unread",
                                      style: TextStyle(
                                        color: Color(0xFF185ADB),
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    BlocBuilder<analyticsCubit,analyticsState>(builder: (_,state)=>state is analyticsSent?Text(state.unreadCount+"/${state.recvcount}",style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.black,
                                      ),):Text("error")),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),

                      Card(
                        margin: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 5.0),
                        clipBehavior: Clip.antiAlias,
                        color: Colors.white,
                        elevation: 5.0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 22.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "un-seen",
                                      style: TextStyle(
                                        color: Color(0xFF185ADB),
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    BlocBuilder<analyticsCubit,analyticsState>(builder: (_,state)=>state is analyticsSent?Text('${state.activechats.toString()}/${state.chatnum}',style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.black,
                                      ),):Text("error")),
                                  ],
                                ),
                              ),
                              
                              Expanded(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      "seen",
                                      style: TextStyle(
                                        color: Color(0xFF185ADB),
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    BlocBuilder<analyticsCubit,analyticsState>(builder: (_,state)=>state is analyticsSent?Text((state.chatnum-state.activechats).toString()+"/${state.chatnum}",style: TextStyle(
                                        fontSize: 20.0,
                                        color: Colors.black,
                                      ),):Text("error")),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )),
              BlocBuilder<analyticsCubit,analyticsState>(builder: (_,state)=>state is analyticsSent?buildCardMessages(context,int.parse(state.sentcount)+int.parse(state.recvcount),_user.username,state.sentcount,state.recvcount,state.unreadCount) 
                                      :Text("error loading chart")),
              BlocBuilder<analyticsCubit,analyticsState>(builder: (_,state)=>state is analyticsSent?buildCardChats(context,state.activechats.toString(),state.chatnum.toString()) 
                                      :Text("error loading chart"))
              ],
      ),
    );
  }

  _initialSetup() async{
    context.read<analyticsCubit>().analyticsSent1('http://192.168.1.5:8000', _user.id);
  }
}
