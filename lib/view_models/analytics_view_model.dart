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

class AnalyticsViewModel extends BaseViewModel{
  IDatasource _datasource;
  
  AnalyticsViewModel(this._datasource) : super(_datasource);

  Future<int> numchats() async{
    final chats = await _datasource.numChats();
    return chats;
  }

  Future<int> activechats() async{
    final chats = await _datasource.activeChat();
    return chats;
  }

  Future<int> unread() async{
    final chats = await _datasource.unreadCount();
    return chats;
  }

}