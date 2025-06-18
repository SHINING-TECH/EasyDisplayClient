import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:animated_analog_clock/animated_analog_clock.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TemplateScreen(),
    );
  }
}

class TemplateScreen extends StatelessWidget {
  final String jsonData = '''
  {
    "templates": [
      {
        "id": 1,
        "width": 1920,
        "height": 1080,
        "temItems": [
          {
            "id": "1559641477578",
            "name": "image1",
            "type": "image",
            "width": 767,
            "height": 720,
            "x": 0,
            "y": 0,
            "zIndex": "10",
            "backGround": "https://img2.baidu.com/it/u=647265987,1253183144&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500"
          },
          {
            "id": "1559641489959",
            "name": "txt11",
            "type": "txt",
            "width": 960,
            "height": 540,
            "x": 0,
            "y": 0,
            "zIndex": "11"
          },
          {
            "id": "1559641474562",
            "name": "BG",
            "type": "BG",
            "width": 1920,
            "height": 1080,
            "x": 0,
            "y": 0,
            "zIndex": "1",
            "backGround": "https://img2.baidu.com/it/u=647265987,1253183144&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500"
          }
        ]
      }
    ]
  }
  ''';

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> parsedJson = jsonDecode(jsonData);
    final List<dynamic> templates = parsedJson['templates'];
    final Map<String, dynamic> template = templates[0];

    double designWidth = template['width'].toDouble(); // 设计稿宽度
    double designHeight = template['height'].toDouble(); // 设计稿高度

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    print("screenWidth: $screenWidth");
    print("screenHeight: $screenHeight");

    double scaleX = screenWidth / designWidth; // 宽度缩放比例
    double scaleY = screenHeight / designHeight; // 高度缩放比例

    return Scaffold(
      body: Center(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: Stack(
            children: _buildWidgets(template['temItems'], scaleX, scaleY),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildWidgets(List<dynamic> temItems, double scaleX, double scaleY) {
    temItems.sort((a, b) => int.parse(a['zIndex']).compareTo(int.parse(b['zIndex'])));

    return temItems.map((item) {
      double x = item['x'].toDouble() * scaleX;
      double y = item['y'].toDouble() * scaleY;
      double width = item['width'].toDouble() * scaleX;
      double height = item['height'].toDouble() * scaleY;

      return Positioned(
        left: x,
        top: y,
        width: width,
        height: height,
        child: _buildWidgetByType(item),
      );
    }).toList();
  }

  Widget _buildWidgetByType(Map<String, dynamic> item) {
    String type = item['type'];

    switch (type) {
      case "BG":
      case "image":
        return Image.network(
          item['backGround'] ?? "https://img1.baidu.com/it/u=2817729394,4070745909&fm=253&fmt=auto&app=120&f=JPEG?w=500&h=1084",
          fit: BoxFit.cover,
        );
      case "txt":
        return Container(
          color: Colors.blue.withOpacity(0.5),
          child: Center(
            child: Text(
              item['name'],
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        );
      default:
        return Container(
          color: Colors.grey,
          child: Center(child: Text("未知组件")),
        );
    }
  }
}
