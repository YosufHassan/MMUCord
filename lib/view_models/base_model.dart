//@dart = 2.9
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/foundation.dart';
import 'package:mmucord/data/dataSources/data_source_contract.dart';
import 'package:mmucord/models/chat.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mmucord/models/local_message.dart';

abstract class BaseViewModel {
  IDatasource _datasource;

  BaseViewModel(this._datasource);

  @protected
  Future<void> addMessage(LocalMessage message) async {
    if (!await _isExistingChat(message.chatId))
      await _createNewChat(message.chatId);
    await _datasource.addMessage(message);
  }

  Future<bool> _isExistingChat(String chatId) async {
    return await _datasource.findChat(chatId) != null;
  }

  Future<void> _createNewChat(String chatId) async {
    final chat = Chat(chatId);
    await _datasource.addChat(chat);
  }
}