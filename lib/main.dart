import 'package:battery_level/battery_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Battery',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      home: BatteryPage(),
    );
  }
}
