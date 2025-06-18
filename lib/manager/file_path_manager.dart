import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FilePathManager {
  // 获取应用程序的文档目录
  static Future<String> getDocumentDirectory() async {
    if (Platform.isAndroid || Platform.isIOS) {
      // 对于 Android 和 iOS，使用 path_provider 获取文档目录
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    } else if (Platform.isWindows) {
      // 对于 Windows，构建特定的路径
      final userHome = Platform.environment['USERPROFILE'] ?? '';
      final appDataPath = '$userHome\\AppData\\Roaming\\com.example\\snap_vison_client';
      return appDataPath; // 返回应用程序的路径
    } else if (Platform.isLinux) {
      // 对于 Linux，使用用户的主目录
      return Directory.current.path; // 或者使用其他适合的路径
    } else {
      throw UnsupportedError('当前平台不受支持');
    }
  }

  // 获取上传目录
  static Future<String> getUploadResourceDirectory(String type) async {
    final documentDir = await getDocumentDirectory();
    var uploadDir; // 使用反斜杠构建路径
    switch(type){
      case "image":
        uploadDir = Directory('$documentDir\\resource\\image');
        break;
      case "video":
        uploadDir = Directory('$documentDir\\resource\\video');
        break;
      case "image":
        uploadDir =  Directory('$documentDir\\resource\\audio');
        break;
    }

    // 如果上传目录不存在，则创建它
    if (!await uploadDir.exists()) {
      await uploadDir.create(recursive: true);
    }

    return uploadDir.path;
  }

  // 获取 resource 目录下的所有文件列表
  // static Future<List<FileSystemEntity>> getResourceFiles() async {
  //   final uploadDir = await getUploadDirectory();
  //   final directory = Directory(uploadDir);
  //
  //   // 获取目录下的所有文件和子目录
  //   List<FileSystemEntity> files = directory.listSync();
  //
  //   return files; // 返回文件和目录的列表
  // }
}