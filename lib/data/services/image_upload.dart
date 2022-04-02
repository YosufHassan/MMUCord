//@dart = 2.9
// ignore: import_of_legacy_library_into_null_safe
import 'dart:io';
import 'package:dio/dio.dart';

class ImageUploader {
  final String serverUrl;

  ImageUploader(this.serverUrl);

  Future<String> uploadImage(File profileImage) async {
    var dio = Dio();

    dio.options.baseUrl = serverUrl;
  
    String imageFileName =
        profileImage.path.split('/').last; // extract image filename

    var formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(profileImage.path,
          filename: imageFileName)
    });
    final response = await dio.post('/upload', options: Options(followRedirects: false),data: formData);
    if (response.statusCode != 200) {
      return null;
    }
    return response.data['path'];
  }
}
