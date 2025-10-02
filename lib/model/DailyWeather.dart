
class DailyWeather{
  final DateTime date ;
  final double  minTemp ;
  final double maxTemp ;
  final String  condition ;


  DailyWeather({
    required this.date ,
    required this.minTemp,
    required this.maxTemp,
    required this.condition,
 }) ;


  factory DailyWeather.fromJson(Map<String , dynamic> json){
     return DailyWeather(
         date: DateTime.fromMillisecondsSinceEpoch(json["dt"]*100),
         minTemp: (json["temp"]["min"] as num).toDouble(),
         maxTemp: (json["temp"]["max"] as num).toDouble(),
         condition: json["weather"][0]["main"]
     ) ;
  }


}