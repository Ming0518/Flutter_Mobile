// import 'dart:convert';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'main.dart';
// import 'user.dart';
// import 'myconfig.dart';
// import 'package:http/http.dart' as http;

// class GpsScan extends StatefulWidget {
//   final User user;

//   const GpsScan({Key? key, required this.user}) : super(key: key);

//   @override
//   State<GpsScan> createState() => _GpsScanState();
// }

// class _GpsScanState extends State<GpsScan> {
//   var pathAsset = "assets/images/camera.png";
//   late double screenHeight, screenWidth, cardwitdh;
//   final TextEditingController _prlatitudeEditingController =
//       TextEditingController();
//   final TextEditingController _prlongitudeEditingController =
//       TextEditingController();
//   final TextEditingController _prstateEditingController =
//       TextEditingController();
//   final TextEditingController _prlocalEditingController =
//       TextEditingController();
//   String selectedType = "Fish";
//   List<String> catchlist = [
//     "Fish",
//     "Crab",
//     "Squid",
//     "Oysters",
//     "Mussels",
//     "Octopus",
//     "Scallops",
//     "Lobsters",
//     "Other",
//   ];
//   late Position _currentPosition;
//   String curaddress = "";
//   String curstate = "";
//   String prlat = "";
//   String prlong = "";
//   QRViewController? controller;
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

//   @override
//   void initState() {
//     super.initState();
//     //_determinePosition();
//   }

//   @override
//   Widget build(BuildContext context) {
//     screenHeight = MediaQuery.of(context).size.height;
//     screenWidth = MediaQuery.of(context).size.width;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "MyGPS",
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.green,
//       ),
//       body: Stack(
//         children: [
//           buildQrView(),
//           Positioned(
//             bottom: 20.0,
//             left: screenWidth / 4,
//             child: ElevatedButton(
//               onPressed: () {
//                 if (controller != null) {
//                   controller!.toggleFlash();
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 primary: Colors.green,
//                 minimumSize: Size(screenWidth / 2, 50),
//               ),
//               child: const Text(
//                 "Toggle Flash",
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildQrView() {
//     return QRView(
//       key: qrKey,
//       onQRViewCreated: _onQRViewCreated,
//       overlay: QrScannerOverlayShape(
//         borderColor: Colors.green,
//         borderRadius: 10,
//         borderLength: 30,
//         borderWidth: 10,
//         cutOutSize: MediaQuery.of(context).size.width * 0.8,
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     setState(() {
//       this.controller = controller;
//     });
//     controller.scannedDataStream.listen((scanData) {
//       if (mounted) {
//         // Handle the result (e.g., navigate to a new screen or process the data)
//         // Example:
//         // Navigator.push(
//         //   context,
//         //   MaterialPageRoute(
//         //       builder: (context) => ResultScreen(result: scanData.code)),
//         // );
//       }
//     });
//   }
// }
