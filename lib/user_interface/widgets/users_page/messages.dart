//@dart =2.9
import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mmucord/constants.dart';
import 'package:mmucord/models/chat.dart';
import 'package:mmucord/states_management/message/message_bloc.dart';
import 'package:mmucord/states_management/typing/typing_notification_bloc.dart';
import 'package:mmucord/states_management/users_page/chats_cubit.dart';
import 'package:mmucord/theme.dart';
import 'package:mmucord/user_interface/screens/users_page_router.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mmucord/user_interface/widgets/users_page/profile_image.dart';

class Messages extends StatefulWidget {
  final User user;
  final IHomeRouter router;
  const Messages(this.user, this.router);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  var chats = [];
  final typingEvents = [];
  @override
  void initState() {
    super.initState();
    _updateChatsOnMessageReceived();
    context.read<ChatsCubit>().chats();
  }

  @override
    @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatsCubit, List<Chat>>(builder: (__, chats) {
      this.chats = chats;
      if (this.chats.isEmpty) return Container();
      context.read<TypingNotificationBloc>().add(
          TypingNotificationEvent.onSubscribed(widget.user,
              usersWithChat: chats.map((e) => e.from.id).toList()));
      return _buildListView();
    });
  }

  _buildListView() {
    return ListView.separated(
        padding: EdgeInsets.only(top: 30.0, right: 16.0),
        itemBuilder: (_, indx) => GestureDetector(
              child: _chatItem(chats[indx]),
              onTap: () async {
                await this.widget.router.onShowMessageThread(
                    context, chats[indx].from, widget.user,
                    chatId: chats[indx].id);

                await context.read<ChatsCubit>().chats();
              },
            ),
        separatorBuilder: (_, __) => Divider(),
        itemCount: chats.length);
  }

  _chatItem(Chat chat) => ListTile(
        contentPadding: EdgeInsets.only(left: 16.0),
        leading: ProfileImageW(
          url: chat.from.photoUrl,
          online: chat.from.active,
        ),
        title: Text(
          chat.from.username,
          style: Theme.of(context).textTheme.subtitle2.copyWith(
                fontWeight: FontWeight.bold,
                color: isLightTheme(context) ? Colors.black : Colors.white,
              ),
        ),
        subtitle: BlocBuilder<TypingNotificationBloc, TypingNotificationState>(
            builder: (__, state) {
          if (state is TypingNotificationReceivedSuccess &&
              state.event.event == Typing.start &&
              state.event.from == chat.from.id)
            this.typingEvents.add(state.event.from);

          if (state is TypingNotificationReceivedSuccess &&
              state.event.event == Typing.stop &&
              state.event.from == chat.from.id)
            this.typingEvents.remove(state.event.from);

          if (this.typingEvents.contains(chat.from.id))
            return Text('typing...',
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(fontStyle: FontStyle.italic));

          return Text(
            chat.mostRecent.message.contents,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: Theme.of(context).textTheme.overline.copyWith(
                color: isLightTheme(context) ? Colors.black54 : Colors.white70,
                fontWeight:
                    chat.unread > 0 ? FontWeight.bold : FontWeight.normal),
          );
        }),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              DateFormat('h:mm a').format(chat.mostRecent.message.timestamp),
              style: Theme.of(context).textTheme.overline.copyWith(
                    color:
                        isLightTheme(context) ? Colors.black54 : Colors.white70,
                  ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50.0),
                child: chat.unread > 0
                    ? Container(
                        height: 15.0,
                        width: 15.0,
                        color: kPrimary,
                        alignment: Alignment.center,
                        child: Text(
                          chat.unread.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .overline
                              .copyWith(color: Colors.white),
                        ),
                      )
                    : SizedBox.shrink(),
              ),
            )
          ],
        ),
      );

  _updateChatsOnMessageReceived() {
    final chatsCubit = context.read<ChatsCubit>();
    context.read<MessageBloc>().stream.listen((state) async {
      if (state is MessageReceivedSuccess) {
        await chatsCubit.viewModel.receivedMessage(state.message);
        chatsCubit.chats();
      }
    });
  }
}