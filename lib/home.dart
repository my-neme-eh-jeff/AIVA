import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:untitled1/screens/bottomBar/chatGemini/gemini.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  _callNumber();
                },
                child: const Text("Call")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const GeminiPage()));
                },
                child: const Text("Gemini")),
          ],
        ),
      ),
    );
  }

  _callNumber() async {
    const number = '+91 88500 14291'; //set the number here
    await FlutterPhoneDirectCaller.callNumber(number);
  }
}
