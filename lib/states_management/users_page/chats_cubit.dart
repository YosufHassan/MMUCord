// @dart =2.9

// ignore: unused_import
import 'dart:ffi';

import 'package:bloc/bloc.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:mmucord/models/chat.dart';
// ignore: import_of_legacy_library_into_null_safe
// ignore: unused_import
import 'package:mmucord/view_models/chat_view_model.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mmucord/view_models/chats_view_model.dart';

class ChatsCubit extends Cubit<List<Chat>> {
  final ChatsViewModel viewModel;
  ChatsCubit(this.viewModel) : super([]);

  Future<void> chats() async {
    final chats = await viewModel.getChats();
    emit(chats);
  }
}

