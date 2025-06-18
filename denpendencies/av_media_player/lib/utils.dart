import 'package:flutter/widgets.dart';

/// This mixin is used by [AvMediaView] to avoid [setState] issues.
///
/// It is recommended to add this mixin in your [StatefulWidget]'s [State] class
/// while using [AvMediaPlayer] or [AvMediaView].
mixin SetStateAsync<T extends StatefulWidget> on State<T> {
  final _fns = <VoidCallback>[];
  void _runFns() {
    for (final fn in _fns) {
      fn();
    }
    _fns.clear();
  }

  /// Combine all [setState] calls within the same tick into single one.
  /// This also makes the [setState] opearation async.
  @override
  void setState(VoidCallback fn) {
    if (_fns.isEmpty) {
      Future.microtask(() {
        if (mounted) {
          super.setState(_runFns);
        }
      });
    }
    _fns.add(fn);
  }
}
