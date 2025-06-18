import 'package:flutter/material.dart';
import 'package:snap_vison_client/splash_screen.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen(),
    );
  }
}
