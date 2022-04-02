//@dart=2.9
// ignore: import_of_legacy_library_into_null_safe
import 'package:chat/src/models/user.dart';

abstract class IUserService {
  Future<User> connect(User user);
  Future<List<User>> online();
  Future<void> disconnect(User user);
  Future<User> fetch(String id);
}
