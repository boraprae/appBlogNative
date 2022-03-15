import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final String login_url = 'http://10.0.2.2:7000/login';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Sign in'),
              SizedBox(
                height: 16,
              ),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
              ),
              SizedBox(
                height: 16,
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              SizedBox(
                height: 16,
              ),
              OutlineButton(
                onPressed: login,
                child: Text('Sign in'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login() async {
    final username = usernameController.text;
    final password = passwordController.text;
    // if (kDebugMode) {
    //   print(username + password);
    // }
    http.Response response = await http.post(
      Uri.parse(login_url),
      body: {'username': username, 'password': password},
    );
    
    if (response.statusCode == 200) {
      //?==== Login Pass ====?
      var result = jsonDecode(response.body);
      String token = result['token'];
      //ptint the result
      //print(result);
      //save token to local storage
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      //jumppppppp
      Get.offNamed('/blog');
    } else {
      //!==== Login Failed ====!
      Get.defaultDialog(
        title: 'Error',
        middleText: response.body.toString(),
      );
    }

    usernameController.clear();
    passwordController.clear();
  }
}
