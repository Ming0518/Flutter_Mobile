import 'package:flutter/material.dart';
import 'user.dart';
import 'main.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AdminPage extends StatefulWidget {
  final User user;

  const AdminPage({super.key, required this.user});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "MyGPS",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        actions: [
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
        child: Container(
          width: 200.0,
          height: 200.0,
          child: Image.asset(
              'assets/images/qr_code.png'), // Replace with your QR code image asset
        ),
      ),
    );
  }

  void _goToLogin() {
    Navigator.push(
        context, MaterialPageRoute(builder: (content) => const MainApp()));
  }
}
