import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'camerapage.dart';
import 'main.dart';
import 'user.dart';
import 'myconfig.dart';
import 'package:http/http.dart' as http;

class GpsPage extends StatefulWidget {
  final User user;

  const GpsPage({super.key, required this.user});

  @override
  State<GpsPage> createState() => _GpsPageState();
}

class _GpsPageState extends State<GpsPage> {
  var pathAsset = "assets/images/camera.png";
  late double screenHeight, screenWidth, cardwitdh;
  final TextEditingController _prlatitudeEditingController =
      TextEditingController();
  final TextEditingController _prlongitudeEditingController =
      TextEditingController();
  final TextEditingController _prstateEditingController =
      TextEditingController();
  final TextEditingController _prlocalEditingController =
      TextEditingController();
  late Position _currentPosition;

  String prlat = "";
  String prlong = "";

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MyGPS",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: () {
              _determinePosition();
            },
            icon: const Icon(Icons.refresh),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        child: const Text('No'),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                      ),
                      TextButton(
                        child: const Text(
                          'Yes',
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          _goToLogin();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: screenWidth / 4,
              height: screenHeight / 5,
              decoration: const BoxDecoration(
                  // Add decoration for the container, such as background color, image, etc.
                  ),
              child: Image.asset('assets/images/gps.png'),
            ),
            const SizedBox(
              height: 10,
            ),
            Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Column(
                  children: [
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (val) => val!.isEmpty || (val.length < 3)
                          ? "Current State"
                          : null,
                      enabled: false,
                      controller: _prstateEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Current State',
                        labelStyle: TextStyle(),
                        icon: Icon(Icons.flag),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      enabled: false,
                      validator: (val) => val!.isEmpty || (val.length < 3)
                          ? "Current Locality"
                          : null,
                      controller: _prlocalEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Current Locality',
                        labelStyle: TextStyle(),
                        icon: Icon(Icons.map),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      enabled: false,
                      validator: (val) => val!.isEmpty || (val.length < 3)
                          ? "Current Latitude"
                          : null,
                      controller: _prlatitudeEditingController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Current Latitude',
                        labelStyle: TextStyle(),
                        icon: Icon(Icons.location_on),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      enabled: false,
                      validator: (val) => val!.isEmpty || (val.length < 3)
                          ? "Current Longitude"
                          : null,
                      controller: _prlongitudeEditingController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Current Longitude',
                        labelStyle: TextStyle(),
                        icon: Icon(Icons.location_on),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        opencamera();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        minimumSize: Size(screenWidth / 2, 50),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.qr_code,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Check-In",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
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
      _prlocalEditingController.text = "Changlun";
      _prstateEditingController.text = "Kedah";
      _prlatitudeEditingController.text = "6.443455345";
      _prlongitudeEditingController.text = "100.05488449";
      prlat = "6.443455345";
      prlong = "100.05488449";
    } else {
      _prlocalEditingController.text = placemarks[0].locality.toString();
      _prstateEditingController.text =
          placemarks[0].administrativeArea.toString();

      _prlatitudeEditingController.text = _currentPosition.latitude.toString();
      _prlongitudeEditingController.text =
          _currentPosition.longitude.toString();

      prlat = _currentPosition.latitude.toString();
      prlong = _currentPosition.longitude.toString();
    }
    setState(() {});
  }

  void opencamera() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CameraPage()),
    );
    insertGPS();
  }

  void insertGPS() {
    String state = _prstateEditingController.text;
    String locality = _prlocalEditingController.text;

    http.post(Uri.parse("${MyConfig().SERVER}/gps/php/insert_gps.php"), body: {
      "userid": widget.user.id.toString(),
      "latitude": prlat,
      "longitude": prlong,
      "state": state,
      "locality": locality,
      "email": widget.user.email.toString(),
      "name": widget.user.name.toString(),
      "phone": widget.user.phone.toString(),
    }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          // ScaffoldMessenger.of(context)
          //     .showSnackBar(const SnackBar(content: Text("Insert Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        }
        //Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        Navigator.pop(context);
      }
    });
  }

  void _goToLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const MainApp()));
  }
}
