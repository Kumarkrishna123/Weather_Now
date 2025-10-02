import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/splash_screen.dart';


void main()  async{
  runApp(const WeatherNowApp());
}

class WeatherNowApp extends StatelessWidget {
  const WeatherNowApp({super.key}) ;

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "WeatherNow",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Roboto",
      ),
      home: const SplashScreen(),
    );

  }


}

