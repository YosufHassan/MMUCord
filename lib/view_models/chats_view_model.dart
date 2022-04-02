//@dart =2.9
// ignore: import_of_legacy_library_into_null_safe
import 'package:chat/chat.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mmucord/data/dataSources/data_source_contract.dart';
import 'package:mmucord/models/chat.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mmucord/models/local_message.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mmucord/view_models/base_model.dart';
// ignore: import_of_legacy_library_into_null_safe


class ChatsViewModel extends BaseViewModel {
  IDatasource _datasource;
  IUserService _userService;

  ChatsViewModel(this._datasource, this._userService) : super(_datasource);

  Future<List<Chat>> getChats() async {
    final chats = await _datasource.findAllChats();
    await Future.forEach(chats, (chat) async {
      final user = await _userService.fetch(chat.id);
      chat.from = user;
    });

    return chats;
  }

  Future<void> receivedMessage(Message message) async {
    LocalMessage localMessage =
        LocalMessage(message.from, message, ReceiptStatus.deliverred);
    await addMessage(localMessage);
  }
}