import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  final bool isDarkMode;
  final Function toggelDarkMode;

  const WeatherPage({
    required this.isDarkMode,
    required this.toggelDarkMode,
  });

  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('5b92d3116d9dabe51679f4b576dc73ba');
  
  Weather? _weather;

  final TextEditingController _controller = TextEditingController();

  _fetchWeather([String cityName = 'Jerusalem']) async {
    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    switch (mainCondition?.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assests/thunder.json';
      case 'clear':
      default:
        return 'assets/sunny.json';    
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: widget.toggelDarkMode as void Function(),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor
              ),
              child: Text(
                "Setting",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text("Dark Mode"),
              trailing: Switch(
                value: widget.isDarkMode,
                onChanged: (value) {
                  widget.toggelDarkMode();
                  Navigator.of(context).pop();
                } ,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                  SizedBox(height: 40),
TextField(
  controller: _controller,
  decoration: InputDecoration(
    hintText: "Enter city name",
    hintStyle: TextStyle(color: Colors.black), // Change hint text color
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    ),
    prefixIcon: Padding(
      padding: const EdgeInsets.all(12.0), // Adjust the padding as needed
      child: Icon(Icons.search, color: Colors.black),
    ),
    filled: true, // Adds a background color to the text field
    fillColor: Colors.grey[200], // Adjust the fill color as needed
  ),
  style: TextStyle(color: Colors.black), // Change input text color
  onSubmitted: (String cityName) {
    _fetchWeather(cityName);
  },
),


                SizedBox(height: 20),
                Text(
                  _weather?.cityName ?? "Loading..",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
                Text(
                  '${_weather?.temperature?.round() ?? ''}C',
                  style: TextStyle(
                    fontSize: 32,
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  _weather?.mainCondition ?? '',
                  style: TextStyle(
                    fontSize: 24,
                    color: widget.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
