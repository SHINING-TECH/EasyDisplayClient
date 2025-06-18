import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class StateHelper {
  StateHelper._();

  static final _stateMap = Map<Type, int>();

  /// 判断是否存在某个页面的实例
  static bool has<T extends StatefulWidget>() {
    return _stateMap.containsKey(T);
  }
}

abstract class StateEx<T extends StatefulWidget> extends State<T> {

  @protected
  @mustCallSuper
  void initState() {
    StateHelper._stateMap[T] = DateTime.now().millisecondsSinceEpoch;
    super.initState();
  }

  @protected
  @mustCallSuper
  void dispose() {
    StateHelper._stateMap.remove(T);
    super.dispose();
  }

}
