//@dart = 2.9

import 'package:bloc/bloc.dart';
import 'package:mmucord/models/local_message.dart';
import 'package:mmucord/view_models/chat_view_model.dart';

class MessageThreadCubit extends Cubit<List<LocalMessage>> {
  final ChatViewModel viewModel;
  MessageThreadCubit(this.viewModel) : super([]);

  Future<void> messages(String chatId) async {
    final messages = await viewModel.getMessages(chatId);
    emit(messages);
  }
}