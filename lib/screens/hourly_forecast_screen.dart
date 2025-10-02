import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_now/model/HourlyWeather.dart';
import 'package:weather_now/services/weather_services.dart';

class HourlyForecastScreen extends StatefulWidget {
  const HourlyForecastScreen({super.key});

  @override
  State<HourlyForecastScreen> createState() => _HourlyForecastScreenState();
}

class _HourlyForecastScreenState extends State<HourlyForecastScreen> {
  late Future<List<HourlyWeather>> futureHourly;

  @override
  void initState() {
    super.initState();
    futureHourly = WeatherService().fetchHourlyWeather(40.7128, -74.0060);
  }
  IconData getWeatherIcon(String weather){
    switch(weather){
      case "Clouds":
         return Icons.cloud;
      case "Clear":
        return Icons.wb_sunny ;
      case "Rain":
        return Icons.umbrella ;

      default:
        return Icons.help_outline ;
    }
  }


  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hourly Forecast"), backgroundColor: Colors.white ,centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () => Navigator.pop(context),
       ),
      ),
      body: FutureBuilder<List<HourlyWeather>>(
        future: futureHourly,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No data available"));
          }

          final data = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Text(
                  "24-Hour Forecast",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 24,
                  itemBuilder: (context, index) {
                    final hour = data[index];
                    final time = DateFormat.Hm().format(hour.time);

                    return Container(
                      width: 80,
                      margin: const EdgeInsets.only(left: 16, right: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(index == 0 ? "Now" : time,
                              style:
                              const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Icon(getWeatherIcon(hour.condition),
                              size: 28, color: Colors.blue),
                          const SizedBox(height: 10),
                          Text("${hour.temp.toStringAsFixed(0)}°",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}



class HourlyCard extends StatelessWidget{

  final String time;
  final String temp ;
  final IconData icon ;



  const HourlyCard({
    super.key,
    required this.time,
    required this.temp,
    required this.icon,
}) ;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 80,
      margin: const  EdgeInsets.only(right:12),
      padding:const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12)
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(time ,style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          
          Icon(icon ,size: 28, color: Colors.blue)
          ,
          const SizedBox(height: 10),

          Text(temp ,style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),

    );
  }
}