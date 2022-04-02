//@dart=2.9

import 'package:chat/chat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:mmucord/states_management/message/message_bloc.dart';
import 'package:mmucord/states_management/users_page/chats_cubit.dart';
import 'package:mmucord/states_management/users_page/users_page_cubit.dart';
import 'package:mmucord/states_management/users_page/users_page_state.dart';
import 'package:mmucord/user_interface/screens/profile_screen_router.dart';
import 'package:mmucord/user_interface/screens/users_page_router.dart';
import 'package:mmucord/user_interface/widgets/users_page/active_users.dart';
import 'package:mmucord/user_interface/widgets/users_page/messages.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mmucord/user_interface/widgets/users_page/profile_image.dart';
// ignore: import_of_legacy_library_into_null_safe

// ignore: camel_case_types
class usersPage extends StatefulWidget {
  final User me;
  final IHomeRouter router;
  final IProfileScreenRouter screenRouter;
  usersPage(this.me, this.router,this.screenRouter);

  // ignore: empty_constructor_bodies
  @override
  _usersPageState createState() => _usersPageState();
}

// ignore: camel_case_types
class _usersPageState extends State<usersPage>
    with AutomaticKeepAliveClientMixin {
  // to avoid refresshing tabs and loosing state use keep alive mix in
  User _user;
  @override
  // init state to get active users list from the cubit
  void initState() {
    super.initState();
    _user = widget.me;
    _initialSetup();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Container(
              width: double.maxFinite,
              child: Row(
                children: [
                  new GestureDetector(
                    onTap: (){
                      this.widget.screenRouter.onPageInset(context, widget.me);
                    },
                    child: ProfileImageW(
                      url: _user.photoUrl,
                      online: _user.active,
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          _user.username,
                          style: Theme.of(context).textTheme.caption.copyWith(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text("Online",
                            style: Theme.of(context).textTheme.caption),
                      ),
                    ],
                  )
                ],
              ),
            ),
            bottom: TabBar(
              indicatorPadding: EdgeInsets.only(top: 10.0, bottom: 10.0),
              tabs: [
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Messages"),
                    ),
                  ),
                ),
                Tab(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      // create a bloc builder to access teh state and get online users
                      child: BlocBuilder<UsersPageCubit, HomeState>(
                          builder: (_, state) => state is HomeSuccess
                              ? Text('Users (${state.onlineUsers.length})')
                              : Text('Users (0)')),
                    ),
                  ),
                )
              ],
            ),
          ),
          body: TabBarView(
            // set the widgets used for the tabs
            children: [
              Messages(_user, widget.router),
              ActiveUsersW(widget.router, _user)
            ],
          ),
        ));
  }

  _initialSetup() async {
    final user = (!_user.active)
        ? await context.read<UsersPageCubit>().connect()
        : _user;

    context.read<ChatsCubit>().chats();
    context.read<UsersPageCubit>().activeUsers(user);
    context.read<MessageBloc>().add(MessageEvent.onSubscribed(user));
  }

  @override
  bool get wantKeepAlive => true;
}
