import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:r_get_ip/r_get_ip.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('External IP Address'),
              FutureBuilder(
                builder: _buildIpWidget,
                future: RGetIp.externalIP,
              ),
              SizedBox(
                height: 16,
              ),
              Text('internal IP Address'),
              FutureBuilder(
                builder: _buildIpWidget,
                future: RGetIp.internalIP,
              ),
              SizedBox(
                height: 16,
              ),
              Text('Network Type'),
              FutureBuilder(
                builder: _buildIpWidget,
                future: RGetIp.networkType,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {});
          },
          child: Icon(Icons.refresh),
        ),
      ),
    );
  }

  Widget _buildIpWidget(BuildContext context, AsyncSnapshot<String?> snapshot) {
    return Text(
      '${snapshot.hasData ? snapshot.data : "0.0.0.0"}',
      style: TextStyle(
        color: Theme.of(context).primaryColor,
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
