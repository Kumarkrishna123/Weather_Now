import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_now/model/DailyWeather.dart';
import 'package:weather_now/services/weather_services.dart';

class WeeklyForecastScreen extends StatefulWidget {
  const WeeklyForecastScreen({super.key});

  @override
  State<WeeklyForecastScreen> createState() => _WeeklyForecastScreenState();
}

class _WeeklyForecastScreenState  extends State<WeeklyForecastScreen> {

  late Future<List<DailyWeather>> futureWeekly;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureWeekly = WeatherService().fetchWeeklyWeather(40.7128, -74.0060);
  }

  IconData getWeatherIcon(String weather) {
    switch (weather) {
      case "Clouds":
        return Icons.cloud;
      case "Clear":
        return Icons.wb_sunny;
      case "Rain":
        return Icons.umbrella;
      default:
        return Icons.help_outline;
    }
  }


  @override
  Widget build(BuildContext context) {

     return Scaffold(
       appBar: AppBar(title: const Text("7-day Forecast"), backgroundColor: Colors.white , centerTitle: true,),
       body: FutureBuilder<List<DailyWeather>>(
         future: futureWeekly,
         builder: (context, snapshot) {
           if (snapshot.connectionState == ConnectionState.waiting) {
             return const Center(child: CircularProgressIndicator());
           }
           else if (snapshot.hasError) {
             return Center(child: Text("Error: ${snapshot.error}"));
           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
             return const Center(child: Text("No data available"));
           }
         final data = snapshot.data!;

       return ListView.builder(
           itemCount: data.length.clamp(0, 7), // Show next 7 days
         itemBuilder: (context, index) {
           final day = data[index];
           final dayName = DateFormat.EEEE().format(day.date); // Monday, Tuesday...

           return Card(
             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
             child: ListTile(
               leading: Icon(getWeatherIcon(day.condition), color: Colors.blue, size: 32),
               title: Text(dayName, style: const TextStyle(fontWeight: FontWeight.bold)),
               subtitle: Text(day.condition),
               trailing: Text(
                 "${day.maxTemp.toStringAsFixed(0)}° / ${day.minTemp.toStringAsFixed(0)}°",
                 style: const TextStyle(fontSize: 16),
               ),
             ),
           );
         },
       );
     },
  ),
  );
}
}