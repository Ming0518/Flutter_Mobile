import 'dart:convert';

import 'package:flutter/material.dart';
import 'LocationPage.dart';
import 'myconfig.dart';
import 'package:http/http.dart' as http;

import 'user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login and Location',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    http.post(Uri.parse("${MyConfig().SERVER}/gps1/login.php"), body: {
      "username": username,
      "password": password,
    }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        print(response.body);
        print(jsondata);
        print("hereee");

        if (jsondata['status'] == 'success') {
          User user = User.fromJson(jsondata['data']);
          print("sucessssssssssss");

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (content) => LocationPage(
                        user: user,
                      )));

          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Check-In Successful")));
        } else {
          print("failllllllllllllll");

          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Login Failed")));
        }
      } else {
        print(response.statusCode);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Login Failed")));
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DEERHERD (⁠•⁠ө⁠•⁠)⁠♡'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'USERNAME'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'PASSWORD'),
              obscureText: true,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _login,
              child: const Text('SIGN IN'),
            ),
          ],
        ),
      ),
    );
  }
}
