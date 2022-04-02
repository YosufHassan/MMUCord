//@dart = 2.9
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/material.dart';
import 'package:mmucord/models/chat.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mmucord/models/local_message.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:chat/chat.dart';

abstract class IDatasource {
  Future<void> addChat(Chat chat);
  Future<void> addMessage(LocalMessage message);
  Future<Chat> findChat(String chatId);
  Future<List<Chat>> findAllChats();
  Future<void> updateMessage(LocalMessage message);
  Future<List<LocalMessage>> findMessages(String chatId);
  Future<void> deleteChat(String chatId);
  Future<void> updateMessageReceipt(String messageId, ReceiptStatus status);
  Future<int> numChats();
  Future<int> activeChat();
  Future<int> unreadCount();
}