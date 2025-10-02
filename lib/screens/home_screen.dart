import 'package:flutter/material.dart';
import 'package:weather_now/screens/hourly_forecast_screen.dart';
import 'package:weather_now/screens/weakly_forecast_screen.dart';
import 'package:weather_now/services/weather_services.dart';
import 'package:weather_now/services/location_service.dart';
import 'package:permission_handler/permission_handler.dart';




class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? weatherData;
  bool isLoading = true;
  String errorMessage = "";
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  Future<void> loadWeather() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try {
      if (!await Permission.location.request().isGranted) {
        setState(() {
          errorMessage = "Location permission denied";
          isLoading = false;
        });
        return;
      }

      final position = await LocationService.getCurrentLocation();
      final data = await WeatherService()
          .fetchWeatherByLocation(position.latitude, position.longitude);

      setState(() {
        weatherData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Failed to fetch weather: $e";
        isLoading = false;
      });
    }
  }

  IconData getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case "clouds":
        return Icons.cloud;
      case "rain":
        return Icons.grain;
      case "clear":
        return Icons.wb_sunny;
      case "snow":
        return Icons.ac_unit;
      default:
        return Icons.cloud_queue;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // TODO: Navigate to Map, Alerts, Settings pages
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Scaffold(
        body: Center(child: Text(errorMessage)),
      );
    }

    final main = weatherData!["main"];
    final weather = weatherData!["weather"][0];
    final double temperatureVal = (main["temp"] ?? 0).toDouble();
    final double feelsLikeVal = (main["feels_like"] ?? 0).toDouble();
    final int pressure = (main["pressure"] ?? 0).toInt();
    final int humidity = (main["humidity"] ?? 0).toInt();
    final int visibility = ((weatherData!["visibility"] ?? 0) ~/ 1000);

    final String temperature = "${temperatureVal.round()}°";
    final String feelsLike = "${feelsLikeVal.round()}°";

    final String city = weatherData!["name"];
    final String condition = weather["main"];

    return Scaffold(
      appBar: AppBar(
        title: Text(city),
        centerTitle: true,
        backgroundColor: Colors.blue, // Set color so icons are visible
        foregroundColor: Colors.white, //Make text/icons white
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text("WeatherNow",
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),

            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text("24-Hour Forecast"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HourlyForecastScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text("7-Day Forecast"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const WeeklyForecastScreen()),
                );
              },
            ),
            const Divider(),

          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(getWeatherIcon(condition), size: 80, color: Colors.blue),
            const SizedBox(height: 10),
            Text(temperature,
                style:
                const TextStyle(fontSize: 70, fontWeight: FontWeight.bold)),
            Text(condition,
                style: const TextStyle(fontSize: 22, color: Colors.grey)),
            const SizedBox(height: 5),
            Text("Feels like $feelsLike",
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text("Pressure", style: TextStyle(color: Colors.grey)),
                    Text("$pressure hPa",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  children: [
                    const Text("Humidity", style: TextStyle(color: Colors.grey)),
                    Text("$humidity%",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                Column(
                  children: [
                    const Text("Visibility",
                        style: TextStyle(color: Colors.grey)),
                    Text("$visibility km",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: "Alerts"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}
