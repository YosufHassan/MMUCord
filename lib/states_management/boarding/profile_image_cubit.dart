//@dart = 2.9
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageCubit extends Cubit<File> {
  final _picker = ImagePicker();
  ProfileImageCubit() : super(null);

  Future<void> getImage() async {
    PickedFile image =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    if (image == null) return; // check for null exception, because when the user does not choose an image it will crash the application
    emit(File(image.path));
  }
}