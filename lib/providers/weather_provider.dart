 import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:weather_app/models/current_weather_response.dart';
import 'package:weather_app/models/forecast_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/utils/constants.dart';

class WeatherProvider extends ChangeNotifier {
  CurrentWeatherResponse? currentWeatherResponse;
  ForecastResponseModel? forecastResponseModel;
  double latitude = 0.0, longitude = 0.0;
  String unit = metric;
  String unitSymbol = celsius;
  String errorMsg = '';

  void setNewLocation(double lat, double lng) {
    latitude = lat;
    longitude = lng;
  }

  void setUnit(bool status) {
    unit = status ? imperial : metric;
    unitSymbol = status ? fahrenheit : celsius;
    print(unitSymbol);
  }

  bool get hasDataLoaded => currentWeatherResponse != null &&
      forecastResponseModel != null;

  Future<void> _getCurrentWeatherData() async {
    final url = 'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=$unit&appid=433e5e850b531a402249c1cc7da631f6';
    try {
      final response = await http.get(Uri.parse(url));
      final map = jsonDecode(response.body);
      if(response.statusCode == 200) {
        currentWeatherResponse = CurrentWeatherResponse.fromJson(map);
        notifyListeners();
      } else {
        errorMsg = map['message'];
        notifyListeners();
      }
    } catch (error) {
      print(error.toString());
      errorMsg = error.toString();
      notifyListeners();
    }
  }

  Future<void> _getForecastWeatherData() async {
    final url = 'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&units=$unit&appid=433e5e850b531a402249c1cc7da631f6';
    try {
      final response = await http.get(Uri.parse(url));
      final map = jsonDecode(response.body);
      if(response.statusCode == 200) {
        forecastResponseModel = ForecastResponseModel.fromJson(map);
        notifyListeners();
      } else {
        errorMsg = map['message'];
        notifyListeners();
      }
    } catch (error) {
      print(error.toString());
      errorMsg = error.toString();
      notifyListeners();
    }
  }

  Future<void> getData() async {
    await _getCurrentWeatherData();
    await _getForecastWeatherData();
    print(unitSymbol);
  }
}