import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'carouselCard.dart';

class YtPage extends StatefulWidget {
  const YtPage({super.key});

  @override
  State<YtPage> createState() => _YtPageState();
}

class _YtPageState extends State<YtPage> {
  int now = DateTime.now().hour;
  List<CarouselCard> videoList = const [
    CarouselCard(initialVideoId: 'Xg6iLQrezOk'),
    CarouselCard(initialVideoId: '8KkKuTCFvzI'),
    CarouselCard(initialVideoId: '6Pm0Mn0-jYU'),
    CarouselCard(initialVideoId: 'e-or_D-qNqM'),
    CarouselCard(initialVideoId: 'ZoZT8-HqI64'),
  ];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Web Search",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontFamily: "productSansReg"),
            ),
          ),
          SizedBox(
            height: height * (15 / 888),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  now <= 12
                      ? "Good morning, user."
                      : now > 12 && now < 17
                          ? "Good afternoon, user."
                          : "Good evening, user.",
                  style: const TextStyle(
                      color: Colors.purple,
                      fontSize: 20,
                      fontFamily: "productSansReg"),
                )),
          ),
          Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset("assets/images/cute_old_couple.jpg"),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      child: Text(
                          "The following links provide practical help to you.",
                          style: TextStyle(
                              color: Colors.purple,
                              fontSize: 16,
                              fontFamily: "productSansReg")),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CarouselSlider(
                items: videoList, options: CarouselOptions(autoPlay: true)),
          )
        ],
      ),
    );
  }
}
