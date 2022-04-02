//@dart =2.9
import 'package:bloc/bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:chat/chat.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mmucord/cache/local_cache.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mmucord/states_management/users_page/users_page_state.dart';
// ignore: unused_import
// ignore: import_of_legacy_library_into_null_safe
// ignore: unused_import
import 'package:mmucord/view_models/chats_view_model.dart';


class UsersPageCubit extends Cubit<HomeState> {
  IUserService _userService;
  ILocalCache _localCache;
  UsersPageCubit(this._userService, this._localCache) : super(HomeInitial());

  Future<void> activeUsers(User user) async {
    emit(HomeLoading());
    final users = await _userService.online();
    users.removeWhere((element) => element.id == user.id); // remove the logged in user from the active user lists
    emit(HomeSuccess(users));
  }

  Future<User> connect() async {
    final userJson = _localCache.fetch('USER');
    userJson['last_seen'] = DateTime.now();
    userJson['active'] = true;

    final user = User.fromJson(userJson);
    await _userService.connect(user);
    return user;
  }

}