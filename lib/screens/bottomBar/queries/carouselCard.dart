import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CarouselCard extends StatefulWidget {
  const CarouselCard({super.key, required this.initialVideoId});
  final String initialVideoId;

  @override
  State<CarouselCard> createState() => _CarouselCardState();
}

class _CarouselCardState extends State<CarouselCard> {
  late YoutubePlayerController player;

  @override
  void initState() {
    super.initState();
    player = YoutubePlayerController(initialVideoId: widget.initialVideoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: true,
      ),);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: YoutubePlayer(
            controller: player,
          ),
        ));
  }
}