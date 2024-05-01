import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService{
  static const url = "http://api.openweathermap.org/data/2.5/weather";
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather (String city) async{
    final response = await http.get(Uri.parse("$url?q=$city&appid=$apiKey&units=metric"));
    if(response.statusCode == 200){
      return Weather.fromJson(json.decode(response.body));
    }
    else{
      throw Exception("Failed to Load weather");
    }
  }
  Future<String> getCurrentCity() async{
    //Get permission from user
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }
    //fetch the current loc
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );
    // convert to loc into a list of placement
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    // extract the city name from first placemark
    String? city = placemarks[0].locality;

    return city ?? "";// if it is null return empty string
  }
}