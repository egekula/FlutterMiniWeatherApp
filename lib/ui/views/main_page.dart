import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:mini_weather/models/weather_model.dart';
import 'package:mini_weather/service/weather_service.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final weatherService = WeatherService("3d6d485196d44a466d7c6dc8c9cf37b3");
  Weather? _weather;
  Future<void> fetchWeather() async{
    String cityName = await weatherService.getCurrentCity();

    try{
      final weather = await weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    }
    catch(e){
      print(e);
    }
  }
  String getWeatherAnim(String? mainCondition){
    if(mainCondition == null){
      return 'assets/sunny.json';
    }
    switch(mainCondition){
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloud.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'clear':
        return 'assets/sunny.json';
      default :
        return 'assets/sunny.json';
    }
  }
  @override
  void initState() {
    fetchWeather();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Icon(Icons.location_on,color: Colors.white70,size: 40,),
                Text(_weather?.city ?? "loading city..",style: TextStyle(color: Colors.white70,fontWeight: FontWeight.bold,fontSize: 30),),
              ],
            ),
            Lottie.asset(getWeatherAnim(_weather?.mainCondition)),
            Text("${_weather?.temperature.round()}°C",style: TextStyle(color: Colors.white70,fontWeight: FontWeight.bold,fontSize: 30)),
          ],
        ),
      ),
    );
  }
}
