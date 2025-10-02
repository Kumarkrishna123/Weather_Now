import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:weather_now/model/DailyWeather.dart';
import 'package:weather_now/model/HourlyWeather.dart';

class WeatherService {
  final String apiKey ="OPENWEATHER_API_KEY";

  Future<Map<String, dynamic>> fetchWeatherByLocation(double lat, double lon) async {
    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$apiKey&units=metric");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch weather: ${response.body}");
    }
  }

  Future<List<HourlyWeather>> fetchHourlyWeather(double lat, double lon) async {
        final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List list = data["list"];

      return list.take(24).map((e) => HourlyWeather.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load weather: ${response.body}");
    }
  }

  Future<List<DailyWeather>> fetchWeeklyWeather(double lat, double lon) async {
    // Using forecast API (free tier) - gives 5 day forecast
    final url = Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&appid=$apiKey&units=metric");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List list = data["list"];

      // Group by day and take daily averages
      Map<String, List<dynamic>> dailyData = {};
      for (var item in list) {
        String date = DateTime.fromMillisecondsSinceEpoch(item["dt"] * 1000)
            .toString()
            .substring(0, 10);
        dailyData.putIfAbsent(date, () => []).add(item);
      }

      return dailyData.entries.map((entry) {
        var dayData = entry.value;
        var temps = dayData.map((e) => (e["main"]["temp"] as num).toDouble()).toList();
        return DailyWeather(
          date: DateTime.parse(entry.key),
          minTemp: temps.reduce((a, b) => a < b ? a : b),
          maxTemp: temps.reduce((a, b) => a > b ? a : b),
          condition: dayData[0]["weather"][0]["main"],
        );
      }).toList();
    } else {
      throw Exception("Failed to load weekly weather: ${response.body}");
    }
  }
}