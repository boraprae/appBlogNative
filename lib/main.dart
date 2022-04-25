import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:newblog/ToDoAppProject/views/todo_screen.dart';
import 'package:newblog/blog.dart';
import 'package:newblog/login.dart';
import 'package:http/http.dart' as http;
//import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool bypass = false;
  String username = '';
  // load env
  await dotenv.load(fileName: '.env');
  //*----------- Get token from local storage and verify with server --------------*
  // final prefs = await SharedPreferences.getInstance();
  // String? token = prefs.getString('token');

   // get token from local storage and verify with server
  const storage = FlutterSecureStorage();
  String? token = await storage.read(key: 'token');

   if (token != null) {
    debugPrint('token found');
    // verify token with server
    String url = dotenv.env['SERVER_URL']! + '/jwtDecode';
    // const url = 'http://10.0.2.2:3000/jwtDecode';
    Response response = await GetConnect().post(url, {}, headers: {'authorization': token});
    if (response.isOk) {
      // token is valid
      var result = response.body;
      // print(result['user']);
      username = result['user_username'];
      bypass = true;
    } else {
      debugPrint(response.body.toString());
    }
  } else {
    debugPrint('no token');
  }

  // if (token != null) {
  //   final jwtDecodeUrl = Uri.parse('http://10.0.2.2:7000');
  //   // http.post(url, headers: {'authorization': token});
  //   http.Response response = await http
  //       .post(jwtDecodeUrl, headers: {HttpHeaders.authorizationHeader: token});

  //   if (response.statusCode == 200) {
  //     //?token is valid
  //     var result = jsonDecode(response.body);
  //     username = result['user'];
  //     print(result['user']);
  //     bypass = true;
  //   } else {
  //     print(response.body.toString());
  //   }
  // } else {
  //   print('no token');
  // }

  //! Todo App Project
  runApp(
    GetMaterialApp(
      initialRoute: '/todo',
      routes: {
        '/todo': (context) => TodoScreen(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Sarabun'),
    ),
  );
  // runApp(
  //   GetMaterialApp(
  //     initialRoute: bypass ? '/blog' : '/login',
  //     routes: {
  //       '/blog': (context) => Blog(username),
  //       '/login': (context) => Login(),
  //     },
  //     debugShowCheckedModeBanner: false,
  //     theme: ThemeData(fontFamily: 'Sarabun'),
  //   ),
  // );
}
