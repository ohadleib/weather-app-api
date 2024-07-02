import 'package:flutter/material.dart';
import 'pages/weather_page.dart';

void main() {
  runApp(Myapp());
}

class Myapp extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Myapp> {
  bool _isdarkMode = false;

  void _toggleDarkMode() {
    setState(() {
      _isdarkMode = !_isdarkMode;
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isdarkMode ? ThemeData.dark() : ThemeData.light(),
      home: WeatherPage(
        isDarkMode: _isdarkMode,
        toggelDarkMode: _toggleDarkMode,
      ),
    );
    
  }
}