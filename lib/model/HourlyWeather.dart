class HourlyWeather {
  final DateTime time;
  final double temp;
  final String condition;

  HourlyWeather({
    required this.time,
    required this.temp,
    required this.condition,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    return HourlyWeather(
      time: DateTime.fromMillisecondsSinceEpoch(json["dt"] * 1000),
      temp: (json["main"]["temp"] ?? 0).toDouble(),
      condition: json["weather"][0]["main"] ?? "",
    );
  }
}
