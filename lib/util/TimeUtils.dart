import 'package:intl/intl.dart';

class TimeUtils {
  // 获取当前时间
  static DateTime getCurrentTime() {
    return DateTime.now();
  }

  // 获取当前时间的字符串表示，格式为 "yyyy-MM-dd HH:mm:ss"
  static String getCurrentTimeString() {
    final now = getCurrentTime();
    final formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(now);
  }

  // 获取当前日期的字符串表示，格式为 "yyyy-MM-dd"
  static String getCurrentDateString() {
    final now = getCurrentTime();
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(now);
  }

  // 获取当前时间的时间戳
  static int getCurrentTimestamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  // 将字符串转换为 DateTime
  static DateTime? parseDateTime(String dateTimeString, {String format = 'yyyy-MM-dd HH:mm:ss'}) {
    try {
      final formatter = DateFormat(format);
      return formatter.parse(dateTimeString);
    } catch (e) {
      print('Error parsing date time: $e');
      return null;
    }
  }

  // 计算两个时间之间的差值
  static Duration calculateDifference(DateTime start, DateTime end) {
    return end.difference(start);
  }

  // 格式化时间差为字符串
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitHours = twoDigits(duration.inHours.remainder(24));
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigitHours}h ${twoDigitMinutes}m ${twoDigitSeconds}s';
  }
}