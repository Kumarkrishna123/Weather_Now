
import 'package:geolocator/geolocator.dart';

class LocationService{

  static Future<Position> getCurrentLocation() async{

    bool serviceEnables;
    LocationPermission permission ;

    serviceEnables = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnables){
      throw Exception("Location services are disabled");
    }

    permission  = await Geolocator.checkPermission();
    if(permission== LocationPermission.denied){
      permission =  await Geolocator.requestPermission() ;
      if(permission == LocationPermission.denied){
        throw Exception("Location permissions are denied");
      }
    }


    if(permission == LocationPermission.deniedForever){
      throw Exception("Location permissions are permanently denied");
    }


    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);



  }





}
