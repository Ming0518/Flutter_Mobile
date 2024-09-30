import 'dart:convert';

import 'package:flutter/material.dart';
import 'user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'myconfig.dart';
import 'package:http/http.dart' as http;

class LocationPage extends StatefulWidget {
  final User user;
  const LocationPage({Key? key, required this.user}) : super(key: key);

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String _currentLocation = 'Unknown';
  String _lastGetLocationTime = '';
  String _currentState = '';
  String _currentLocality = '';
  late Position _currentPosition;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'TIME:',
              style: TextStyle(fontSize: 20.0),
            ),
            Text(
              _lastGetLocationTime,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'CURRENT LOCATION:',
              style: TextStyle(fontSize: 20.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              _currentLocation,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              _currentState,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 10.0),
            Text(
              _currentLocality,
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _getLocation,
              child: const Text('CHECK-IN'),
            ),
          ],
        ),
      ),
    );
  }

  void _getLocation() async {
    setState(() {
      _lastGetLocationTime = DateTime.now().toString();
    });

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    setState(() {
      _currentLocation =
          'Latitude: ${position.latitude}\nLongitude: ${position.longitude}';
      _currentState = placemarks.first.administrativeArea ?? 'Unknown';
      _currentLocality = placemarks.first.locality ?? 'Unknown';
    });
    String userId = widget.user.user_id.toString();
    var latitude = position.latitude;
    var longitude = position.longitude;
    http.post(Uri.parse("${MyConfig().SERVER}/gps1/location.php"), body: {
      "userid": "nurin21",
      "latitude": position.latitude.toString(),
      "longitude": position.longitude.toString(),
      "state": _currentState,
      "locality": _currentLocality,
    }).then((response) {
      if (response.statusCode == 200) {
        print(response.body);
        var jsondata = jsonDecode(response.body);

        print(jsondata);

        // Rest of your code handling the response...
      } else {
        print("HTTP request failed with status: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Check-In Failed")),
        );
      }
    }).catchError((error) {
      print("Error during HTTP request: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Check-In Failed")),
      );
    });
  }

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    _currentPosition = await Geolocator.getCurrentPosition();

    _getAddress(_currentPosition);
    //return await Geolocator.getCurrentPosition();
  }

  _getAddress(Position pos) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks.isEmpty) {
      _currentState = "Changlun";
      _currentLocality = "Kedah";
      _currentLocation = "6.443455345";
      //_prlongitudeEditingController.text = "100.05488449";
    } else {
      _currentLocality = placemarks[0].locality.toString();
      _currentState = placemarks[0].administrativeArea.toString();

      //_prlatitudeEditingController.text = _currentPosition.latitude.toString();
      _currentLocation = _currentPosition.longitude.toString();

      //prlat = _currentPosition.latitude.toString();
      //prlong = _currentPosition.longitude.toString();
    }
    setState(() {});
  }
}
