import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:untitled1/auth/Login.dart';
import 'package:untitled1/language/changeLanguageDropdown.dart';
import 'package:untitled1/screens/UserPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>?>(
      future: getFlagValuesSF(),
      builder: (context, snapshot) {
        print("Login data is = ${snapshot.data}");
        print(snapshot.data?[0] == null);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.data?[0] == null) {
          return const SelectLanguageDropdown();
        } else if (!snapshot.data![0]) {
          return const Login();
        } else if (snapshot.data![0]) {
          return UserPage(
            token: snapshot.data![1]!,
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

Future<List<dynamic>?> getFlagValuesSF() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool('isLoggedIn');
    String? token = prefs.getString('token');
    return [isLoggedIn, token];
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }
  return null;
}
