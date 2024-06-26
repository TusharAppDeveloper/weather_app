import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/providers/weather_provider.dart';
import 'package:weather_app/utils/preference_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isOn = false;
  @override
  void initState() {
    getStatus().then((value) => setState(() {
      isOn = value;
    }));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Show temperature in Fahrenheit'),
            subtitle: const Text('Default is Celsius'),
            value: isOn,
            onChanged: (value) async {
              setState(() {
                isOn = value;
              });
              await setStatus(value);
              context.read<WeatherProvider>().setUnit(value);
              context.read<WeatherProvider>().getData();
            },
          ),
        ],
      ),
    );
  }
}
