import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/models/current_weather_response.dart';
import 'package:weather_app/pages/settings_page.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/utils/constants.dart';
import 'package:weather_app/utils/helper_functions.dart';
import 'package:weather_app/utils/location_service.dart';
import 'package:weather_app/utils/preference_service.dart';
import 'package:weather_app/utils/styles.dart';

import '../models/forecast_response_model.dart';

class WeatherHome extends StatefulWidget {
  const WeatherHome({super.key});

  @override
  State<WeatherHome> createState() => _WeatherHomeState();
}

class _WeatherHomeState extends State<WeatherHome> {


  @override
  void didChangeDependencies() {
    _getWeatherData();
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: Consumer<WeatherProvider>(
        builder: (context, provider, child) =>
        provider.hasDataLoaded ? Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _currentSection(provider.currentWeatherResponse!, provider.unitSymbol),
            _forecastSection(provider.forecastResponseModel!.list! , provider.unitSymbol),
          ],
        ) : const Center(child: Text('Please wait'),),
      ),
    );
  }

  Widget _currentSection(CurrentWeatherResponse response, String unitSymbol) {
    return Expanded(
      child: Center(
        child: ListView(

          children: [
            Text(getFormattedDateTime(response.dt!), style: const TextStyle(fontSize: 18.0),),
            Text("${response.name}, ${response.sys!.country}", style: const TextStyle(fontSize: 22.0),),
            Text("${response.main!.temp!.round()}$degree$unitSymbol", textAlign: TextAlign.center, style: const TextStyle(fontSize: 80.0),),
            Text("Feels like ${response.main!.feelsLike!.round()}$degree$unitSymbol", style: const TextStyle(fontSize: 22.0,),textAlign: TextAlign.center,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(getIconDownloadUrl(response.weather!.first.icon!)),
                Text(response.weather!.first.description!, style: const TextStyle(fontSize: 18.0),),
              ],
            ),

            Column(
              children: [
                Text("Humidity : ${response.main!.humidity} %", style: const TextStyle(fontSize: 18.0),),
                const SizedBox(height: 5,),
                Text("Pressure : ${response.main!.pressure} hPa", style: const TextStyle(fontSize: 18.0),),
                const SizedBox(height: 5,),
                Text("Visibility : ${response.visibility} m", style: const TextStyle(fontSize: 18.0),),
                const SizedBox(height: 5,),
                Text("Wind : ${response.wind!.speed} km/h", style: const TextStyle(fontSize: 18.0),),

              ],

            ),
            const SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sunrise: ${getFormattedDateTime(response.sys!.sunrise!, pattern: 'hh:mm a')}', style: timeTextStyle,),
                const SizedBox(width: 10,),
                Text('Sunset: ${getFormattedDateTime(response.sys!.sunset!, pattern: 'hh:mm a')}', style: timeTextStyle,),
              ],

            ),
          ],
        ),
      ),
    );
  }

  Widget _forecastSection(List<ForecastItem> items, String unitSymbol) {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return Card(
            color: Colors.grey.withOpacity(0.2),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(getFormattedDateTime(item.dt!, pattern: 'EEE, hh:mm a')),
                  Image.network(getIconDownloadUrl(item.weather!.first.icon!), width: 35, height: 35,),
                  Text(item.weather!.first.description!,),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _getWeatherData() async {
    final position = await determinePosition();
    final status = await getStatus();
    context.read<WeatherProvider>().setNewLocation(position.latitude, position.longitude);
    context.read<WeatherProvider>().setUnit(status);
    context.read<WeatherProvider>().getData();
  }
}
