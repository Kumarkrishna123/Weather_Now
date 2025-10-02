
import 'package:flutter/material.dart';
import 'package:weather_now/screens/home_screen.dart';

class SplashScreen extends StatelessWidget{
  const SplashScreen({super.key}) ;


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF87CEEB),Colors.white],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud  , size: 100, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
            "WeatherNow",
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold ,color: Colors.black),
            ),
            const SizedBox(height: 10,),
            const Text(
              "your personal weather companion" ,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ) ,
            const SizedBox(height: 50),
            ElevatedButton(onPressed: (){
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context)=> const HomeScreen()),
                  );
            },
             style: ElevatedButton.styleFrom(
                 padding: const EdgeInsets.symmetric(horizontal: 40 ,vertical: 15),
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(12)
               ),
             ),
              child: const Text("Get Started ", style: TextStyle(fontSize: 18),),
            ),
          ],
        ),
      ),
    );
  }


}