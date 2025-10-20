import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  final TextEditingController _controller = TextEditingController();
  String city = '';
  String temperature = '';
  bool isLoading = false;
  String errorMessage = '';

  // 🧭 Step 1: Get coordinates for city
  Future<Map<String, double>?> getCoordinates(String cityName) async {
    final url =
        'https://geocoding-api.open-meteo.com/v1/search?name=$cityName&count=1';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        final lat = data['results'][0]['latitude'];
        final lon = data['results'][0]['longitude'];
        return {'lat': lat, 'lon': lon};
      }
    }
    return null;
  }

  // 🌦 Step 2: Get weather using lat & lon
  Future<void> fetchWeather(String cityName) async {
    if (cityName.isEmpty) return;

    setState(() {
      isLoading = true;
      errorMessage = '';
      temperature = '';
      city = '';
    });

    try {
      final coords = await getCoordinates(cityName);
      if (coords == null) {
        setState(() {
          errorMessage = 'City not found 😕';
          isLoading = false;
        });
        return;
      }

      final url =
          'https://api.open-meteo.com/v1/forecast?latitude=${coords['lat']}&longitude=${coords['lon']}&current=temperature_2m';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final temp = data['current']['temperature_2m'].toString();

        setState(() {
          city = cityName;
          temperature = temp;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to fetch weather data.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('🌍 Application of Weather API')),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Enter city name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => fetchWeather(_controller.text),
                child: const Text('Search'),
              ),
              const SizedBox(height: 30),
              if (isLoading) const CircularProgressIndicator(),
              if (errorMessage.isNotEmpty)
                Text(errorMessage,
                    style: const TextStyle(color: Colors.red, fontSize: 16)),
              if (!isLoading && errorMessage.isEmpty && city.isNotEmpty)
                Column(
                  children: [
                    Text(city,
                        style: const TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text('🌡️ Temperature: $temperature°C',
                        style: const TextStyle(fontSize: 20)),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}