//@dart=2.9

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat/chat.dart';
import 'package:mmucord/cache/local_cache.dart';
import 'package:mmucord/data/services/image_upload.dart';
import 'package:mmucord/states_management/boarding/boarding_state.dart';

// ignore: camel_case_types
class boardingCubit extends Cubit<boardingState> {
  final IUserService _userService;
  final ImageUploader _imageUploader;
  final ILocalCache _localCache;
  boardingCubit(this._userService, this._imageUploader, this._localCache)
      : super(boardingInitial());

  Future<void> connect(String name, File profileImage) async {
    emit(Loading());
    final url = await _imageUploader.uploadImage(profileImage);
    final user = User(
      username: name,
      photoUrl: url,
      active: true,
      lastseen: DateTime.now(),
    );
    final createdUser = await _userService.connect(user);
    // save user to local cache
    final userJson = {
      'username': createdUser.username,
      'active': true,
      'photo_url': createdUser.photoUrl,
      'id': createdUser.id
    };
    await _localCache.save('USER', userJson);
    emit(boardingSuccess(createdUser));
  }
}
  

