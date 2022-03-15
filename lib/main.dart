import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:newblog/blog.dart';
import 'package:newblog/login.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool _bypass = false;
  var username;

  //*Get token from local storage and verify with server
  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  if (token != null) {
    final jwtDecodeUrl = Uri.parse('http://10.0.2.2:7000/jwtDecode');
    // http.post(url, headers: {'authorization': token});
    http.Response response = await http
        .post(jwtDecodeUrl, headers: {HttpHeaders.authorizationHeader: token});

    if (response.statusCode == 200) {
      //?token is valid
      var result = jsonDecode(response.body);
      username = result['user'];
     print(result['user']);
      _bypass = true;
    } else {
      print(response.body.toString());
    }
  } else {
    print('no token');
  }

  runApp(
    GetMaterialApp(
      initialRoute: _bypass ? '/blog' : '/login',
      routes: {
        '/blog': (context) => Blog(username),
        '/login': (context) => Login(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Sarabun'),
    ),
  );
}
