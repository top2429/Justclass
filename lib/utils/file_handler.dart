import 'package:dio/dio.dart';
import 'package:justclass/utils/api_call.dart';
import 'package:justclass/utils/http_exception.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io' as io;

class FileHandler {
  static Future<void> openFileURL(String fileId, String name, Function onReceive, CancelToken token) async {
    try {
      // create a temporary file path
      final dir = await getTemporaryDirectory();
      final extension = name.split('.')[1];
      final filePath = '${dir.path}/$fileId.$extension';
      print(filePath);

      // if the file does not exist, download it from api
      final fileExists = await io.File(filePath).exists();
      if (!fileExists) await ApiCall.downloadFile(fileId, filePath, onReceive, token);

      // open the file
      final result = await OpenFile.open(filePath);
      if (result.type != ResultType.done) {
        if (result.type == ResultType.noAppToOpen)
          throw HttpException(message: 'No app found to open $extension file!');
        throw HttpException(message: result.message);
      }
    } catch (error) {
      throw error;
    }
  }
}
