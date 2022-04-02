//@dart =2.9

import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: unused_import
import 'package:mmucord/states_management/users_page/users_page_cubit.dart';
import 'package:mmucord/states_management/users_page/users_page_state.dart';
// ignore: unused_import
import 'package:mmucord/theme.dart';
import 'package:mmucord/user_interface/screens/users_page_router.dart';
import 'package:mmucord/user_interface/widgets/users_page/profile_image.dart';

class ActiveUsersW extends StatefulWidget {
  final User me;
  final IHomeRouter router;
  ActiveUsersW(this.router, this.me);

  @override
  _ActiveUsersWState createState() => _ActiveUsersWState();
}

class _ActiveUsersWState extends State<ActiveUsersW> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersPageCubit, HomeState>(builder: (_, state) {
      if (state is HomeLoading)
        return Center(child: CircularProgressIndicator());
      if (state is HomeSuccess) return _buildList(state.onlineUsers);
      return Container();
    });
  }

  _listItem(User user) => ListTile(
        leading: ProfileImageW(
          url: user.photoUrl,
          online: true,
        ),
        title: Text(
          user.username,
          style: Theme.of(context).textTheme.caption.copyWith(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
        ),
      );

  _buildList(List<User> users) => ListView.separated(
      padding: EdgeInsets.only(top: 30, right: 16),
      itemBuilder: (BuildContext context, indx) => GestureDetector(
            child: _listItem(users[indx]),
            onTap: () => this.widget.router.onShowMessageThread(
                context, users[indx], widget.me,
                chatId: users[indx].id),
          ),
      separatorBuilder: (_, __) => Divider(),
      itemCount: users.length);
}
