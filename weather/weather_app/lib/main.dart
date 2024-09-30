import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Weather APP'),
        ),
        body: const HomePage(
          title: "Weather",
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String location = "Ipoh";
  List<String> locList = ["Changlun", "Jitra", "Alor Setar", "Ipoh"];
  String desc = "No Data";
  double temp = 0.0;
  int hum = 0;
  String weather = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text("Simple Weather",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          DropdownButton(
            itemHeight: 60,
            value: location,
            onChanged: (newValue) {
              setState(() {
                location = newValue.toString();
              });
            },
            items: locList.map((location) {
              return DropdownMenuItem(
                value: location,
                child: Text(location),
              );
            }).toList(),
          ),
          ElevatedButton(
              onPressed: _getWeather, child: const Text("Load Weather")),
          Text(desc,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      )),
    );
  }

  Future<void> _getWeather() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text("Please Wait"),
            content: Text("Loading....."),
          );
        });

    var apiid = "e40fcec81a744d299579b755dea41c6a";
    Uri url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$apiid&units=metric');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      setState(() {
        temp = parsedJson['main']['temp'];
        hum = parsedJson['main']['humidity'];
        weather = parsedJson['weather'][0]['main'];
        desc =
            "The current weather in $location is $weather. The current temperature is $temp Celcius and humidity is $hum percent. ";
      });
    } else {
      setState(() {
        desc = "No record";
      });
      Navigator.pop(context);
    }
  }
}
