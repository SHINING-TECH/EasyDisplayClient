class Logger {
  // 单例模式
  static final Logger _instance = Logger._internal();

  factory Logger() {
    return _instance;
  }

  Logger._internal();

  // 简单封装print函数
  void log(String message) {
    // 在开发模式下输出日志
    print(message);
  }
}
