import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled1/constants.dart';

class WebSearch extends StatefulWidget {
  const WebSearch({super.key, required this.query});
  final String query;

  @override
  State<WebSearch> createState() => _WebSearchState();
}

class _WebSearchState extends State<WebSearch> {
  String base_url = Constants().base_url;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: FutureBuilder(
          future: getLinks(widget.query),
          builder: (snapshot, data) {
            return Container();
          }),
    ));
  }

  Future getLinks(String query) async {
    http.Response value = await http.post(Uri.parse("$base_url/web-search"),
        body: jsonEncode(<String, String>{"query": query}));

    print(value.statusCode);
    print(value.body);
  }
}
