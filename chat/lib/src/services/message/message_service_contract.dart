//@dart=2.9
// ignore: import_of_legacy_library_into_null_safe
import 'package:chat/src/models/message.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:chat/src/models/user.dart';
import 'package:flutter/foundation.dart';

abstract class IMessageService {
  Future<Message> send(Message message);
  Stream<Message> messages({@required User activeUser});
  dispose();
}
