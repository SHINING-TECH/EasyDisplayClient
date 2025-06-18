import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';

class FileUtil {
  static Future<void> copyWebAssets({
    required String assetsWebFileZipName,
    required String localWebFileFolder,
    VoidCallback? onComplete,
    Function(String)? onError,
  }) async {
    try {
      // 获取目标路径
      final dir = await getApplicationDocumentsDirectory();
      final zipPath = '${dir.path}/$assetsWebFileZipName';
      final extractPath = '${dir.path}/$localWebFileFolder';

      // 判断是否已经解压
      final extractDir = Directory(extractPath);
      if (extractDir.existsSync()) {
        print("Web 资源已解压，跳过复制和解压步骤");
        onComplete?.call();
        return;
      }

      // 如果 ZIP 文件存在但未解压，则解压
      if (await File(zipPath).exists()) {
        print("ZIP 文件已存在，开始解压...");
        await _extractZip(zipPath, extractPath);
        print("ZIP 文件解压完成");
        onComplete?.call();
        return;
      }

      // 如果 ZIP 文件不存在，则复制资源
      print("复制 web 文件...");
      final data = await rootBundle.load('assets/$assetsWebFileZipName');

      // 写入 ZIP 文件
      await File(zipPath).writeAsBytes(data.buffer.asUint8List());
      print('ZIP 文件已保存至: $zipPath');

      // 解压 ZIP 文件
      await _extractZip(zipPath, extractPath);
      print("ZIP 文件解压完成");

      // 触发完成回调
      onComplete?.call();
    } catch (e) {
      print('文件拷贝失败: $e');
      onError?.call(e.toString());
    }
  }


  /// 解压 ZIP 文件
  static Future<void> _extractZip(String zipPath, String extractPath) async {
    try {
      final bytes = await File(zipPath).readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      for (final file in archive) {
        final filePath = '$extractPath/${file.name}';
        if (file.isFile) {
          await File(filePath)
            ..createSync(recursive: true)
            ..writeAsBytesSync(file.content as List<int>);
        } else {
          Directory(filePath).createSync(recursive: true);
        }
      }
      print('ZIP 文件解压完成: $extractPath');
    } catch (e) {
      print('ZIP 解压失败: $e');
      throw Exception('ZIP 解压失败: $e');
    }
  }
}
