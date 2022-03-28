import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:newblog/blog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final url = dotenv.env['SERVER_URL']! + '/login';
  final formKey = GlobalKey<FormState>();
  // final String login_url = 'http://10.0.2.2:7000/login';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Sign in'),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                  validator: (value) {
                    // rule
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the username';
                    }
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  validator: (value) {
                    // rule
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter the password';
                    }
                  },
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
      ),
    );
  }

  Future<void> login() async {
    // validate data
    if (!formKey.currentState!.validate()) {
      return;
    }
    // show waiting dialog
    Get.defaultDialog(
      title: 'Connecting...',
      content: const CircularProgressIndicator(),
      barrierDismissible: false,
    );

    final username = usernameController.text;
    final password = passwordController.text;
    // if (kDebugMode) {
    //   print(username + password);
    // }
    Response response = await GetConnect(timeout: const Duration(seconds: 5))
        .post(url, {'username': username, 'password': password});
    if (response.isOk) {
      // close spinner
      Get.back();
      var result = response.body;
      // login OK
      String token = result['token'];
      // save token to local storage
      const storage = FlutterSecureStorage();
      storage.write(key: 'token', value: token);

      // jump to blog
      Get.off(() => Blog(username));
      //Get.offNamed('/blog');
    } else {
      // close spinner
      Get.back();
      // login failed
      Get.defaultDialog(
        title: 'Error',
        middleText: response.statusCode == null
            ? 'Connection timeout, try again!'
            : response.body.toString(),
      );
    }

    usernameController.clear();
    passwordController.clear();
  }
}
