
import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final int currentIntIndex  ;
  final Function(int) onTabTapped ;

  const BottomNav({
    super.key,
    required  this.currentIntIndex,
    required this.onTabTapped ,
      });

  @override
  Widget build(BuildContext context) {
     return BottomNavigationBar(
       currentIndex: currentIntIndex,
       onTap: onTabTapped,
       selectedItemColor:Colors.blue ,
       unselectedItemColor:Colors.grey ,
       items: [
         BottomNavigationBarItem(icon: Icon(Icons.home), label:"Home"),
         BottomNavigationBarItem(icon: Icon(Icons.map),label:"Map"),
         BottomNavigationBarItem(icon: Icon(Icons.add_alert), label:"Alert"),
         BottomNavigationBarItem(icon: Icon(Icons.settings),label: "Settings"),
       ],
     );
  }
}