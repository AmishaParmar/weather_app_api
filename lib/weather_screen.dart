import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/hourly_forcast_item.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      String cityname = 'London';
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$cityname&APPID=$openWeatherAPIKey'),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'An Unexpected Error Occured.';
      }
      return data;
      // data['list'][0]['main']['temp'];
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    weather = getCurrentWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10.0,
        backgroundColor: const Color.fromARGB(245, 74, 187, 200),
        title: const Center(
          child: Text(
            'Weather App',
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.w800, color: Colors.black),
          ),
        ),
        //actions:[IconButton(onPressed: () {setState(() {weather = getCurrentWeather();});},icon: const Icon(Icons.refresh),),],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(245, 74, 187, 200),
        splashColor: const Color.fromARGB(255, 8, 250, 250),
        elevation: 50.0,
        onPressed: () {
          setState(() {
            weather = getCurrentWeather();
          });
        },
        child: const Icon(
          Icons.refresh_sharp,
          color: Colors.black,
        ),
      ),
      backgroundColor: const Color.fromARGB(209, 71, 14, 158),
      body: FutureBuilder(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          final data = snapshot.data!;

          final currentWeatherData = data['list'][0];

          final currentTemp = currentWeatherData['main']['temp'];
          final currentSky = currentWeatherData['weather'][0]['main'];

          final currentHumidity = currentWeatherData['main']['humidity'];
          final currentWindSpeed = currentWeatherData['wind']['speed'];
          final currentPressure = currentWeatherData['main']['pressure'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    color: const Color.fromARGB(245, 16, 192, 189),
                    shadowColor: const Color.fromARGB(249, 176, 193, 84),
                    elevation: 10.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp K',
                                style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              // Icon(
                              //   currentSky == 'Rain' || currentSky == 'clouds'
                              //       ? Icons.cloud
                              //       : Icons.sunny,
                              //   size: 64,
                              // ),

                              Icon(
                                 currentSky == 'Clouds'
                                    ? Icons.cloud : currentSky == 'Rain' ? Icons.thunderstorm_rounded
                                    : Icons.sunny,
                                size: 64,
                              ),
                              const SizedBox(
                                height: 16.0,
                              ),
                              Text(
                                currentSky,
                                style: const TextStyle(
                                    fontSize: 22, color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Hourly Forecast',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        final hourlyForcast = data['list'][index + 1];
                        final hourlySky =
                            data['list'][index + 1]['weather'][0]['main'];
                        final time = DateTime.parse(hourlyForcast['dt_txt']);
                        return HourlyForecastItem(
                            time: DateFormat.jm().format(time),
                            icon: hourlySky == 'Rain'? Icons.thunderstorm_rounded : hourlySky== 'Clouds'?Icons.cloud_circle_rounded: Icons.sunny,
                            temp: '${hourlyForcast['main']['temp']}');
                      }),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Additional Information',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItem(
                      icon: Icons.water_drop_rounded,
                      lable: 'Humidity',
                      value: currentHumidity.toString(),
                    ),
                    AdditionalInfoItem(
                      icon: Icons.air_rounded,
                      lable: 'Wind Speed',
                      value: currentWindSpeed.toString(),
                    ),
                    AdditionalInfoItem(
                      icon: Icons.beach_access_rounded,
                      lable: 'Pressure',
                      value: currentPressure.toString(),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
