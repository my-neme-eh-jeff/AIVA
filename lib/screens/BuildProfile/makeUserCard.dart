import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'package:untitled1/helpers/Utils.dart';
import 'package:untitled1/models/BuildProfileModel.dart';
import '../../constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

var lst = [];

class MakeUserCard extends StatefulWidget {
  const MakeUserCard({super.key, required this.token, required this.index});
  final String token;
  final int index;

  @override
  State<MakeUserCard> createState() => _MakeUserCardState();
}

class _MakeUserCardState extends State<MakeUserCard>
    with SingleTickerProviderStateMixin {
  final TextEditingController firstNameController = TextEditingController();

  int maxDuration = 10;

  double deviceHeight = Constants().deviceHeight,
      deviceWidth = Constants().deviceWidth;

  final recorder = FlutterSoundRecorder();
  final player = FlutterSoundPlayer();

  bool isRecorderReady = false, gotSomeTextYo = false, isPlaying = false;
  String base_url = Constants().base_url;

  late AnimationController _controller;

  Future record() async {
    if (!isRecorderReady) return;
    await recorder.startRecorder(toFile: 'audio');
  }

  Future stop() async {
    if (!isRecorderReady) return;
    String? path = await recorder.stopRecorder();
    File audioPath = await saveAudioPermanently(path!);
    if (kDebugMode) {
      print('Recorded audio: $path');
    }
    lst = await sendAudio1(audioPath, firstNameController.text.trim());
    if (kDebugMode) {
      print(lst);
    }
    if (true) {
      gotSomeTextYo = true;
      setState(() {
        maxDuration = maxDuration;
      });
    }
  }

  Future initRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw 'Microphone permission not granted';
    }

    await recorder.openRecorder();
    isRecorderReady = true;
    recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  @override
  void initState() {
    super.initState();
    initRecorder();

    _controller = AnimationController(
        vsync: this, duration: Duration(seconds: maxDuration))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          isPlaying = false;
        }
      });

    player.openPlayer().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    final String cardNumStr = (widget.index + 1).toString();
    const double fontSize = 28;
    const double fontHeight = 1.66;
    const Color borderColor = Colors.cyan;

    return SizedBox(
      width: width * (500 / deviceWidth),
      height: height * (100 / deviceHeight),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyan,
                    blurRadius: 50.0,
                    offset: Offset(30, 0),
                  ),
                ],
              ),
              width: width * (480 / deviceWidth),
              height: height * (380 / deviceHeight),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Container(
                            color: Colors.black54,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: width * (48 / deviceWidth),
                                    height: height * (55 / deviceHeight),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      keyboardType: TextInputType.name,
                                      decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(13),
                                          fillColor: Colors.white,
                                          filled: true,
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .firstName,
                                          hintStyle: const TextStyle(
                                              fontFamily: "productSansReg",
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black),
                                          errorStyle: const TextStyle(
                                              fontFamily: "productSansReg",
                                              color: Colors.red,
                                              fontWeight: FontWeight.w500),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(7.0),
                                              borderSide: BorderSide.none)),
                                      controller: firstNameController,
                                      validator: (name) {
                                        if (name == null) {
                                          return 'Enter your first name';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) {},
                                    ),
                                  ),
                                  SizedBox(
                                    width: width * (48 / deviceWidth),
                                    height: height * (25 / deviceHeight),
                                  ),
                                  if (isPlaying)
                                    Center(
                                        child: LoadingAnimationWidget
                                            .staggeredDotsWave(
                                      color: Colors.cyan[500]!,
                                      size: 20 * (height / deviceHeight),
                                    )),
                                  Container(
                                    alignment: Alignment.center,
                                    height: 40 * (height / deviceHeight),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                        shape: BoxShape.circle),
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (recorder.isRecording) {
                                          isPlaying = false;
                                          await stop();
                                          _controller.reset();
                                          Navigator.of(context).pop();
                                          Utils.showSnackBar1(
                                              "Profiles created!");
                                        } else {
                                          isPlaying = true;
                                          await record();
                                          _controller.reset();
                                          _controller.forward();
                                        }
                                        setState(() {});
                                      },
                                      child: AnimatedContainer(
                                        height: isPlaying
                                            ? 10 * (height / deviceHeight)
                                            : 25 * (height / deviceHeight),
                                        width: isPlaying
                                            ? 10 * (height / deviceHeight)
                                            : 25 * (height / deviceHeight),
                                        duration:
                                            const Duration(milliseconds: 300),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              isPlaying ? 6 : 60),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
                child: Card(
                  shadowColor: Colors.cyan,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset('assets/images/new_profile.png'),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Stack(
              children: [
                Text(
                  cardNumStr,
                  style: TextStyle(
                      shadows: const [
                        Shadow(blurRadius: 12, color: borderColor),
                      ],
                      height: fontHeight,
                      fontWeight: FontWeight.bold,
                      fontSize: fontSize,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 6.5
                        ..color = borderColor),
                ),
                Text(
                  cardNumStr,
                  style: const TextStyle(
                    fontFamily: "productSansReg",
                    height: fontHeight,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<List<dynamic?>> sendAudio1(File? audioPath, String name) async {
    List<dynamic?> lst = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var response = http.MultipartRequest(
      'POST',
      Uri.parse('$base_url/child'),
    );
    response.fields['name'] = name;
    response.fields['token'] = token!;
    response.files.add(http.MultipartFile(
        'file', audioPath!.readAsBytes().asStream(), audioPath.lengthSync(),
        filename: basename(audioPath.path),
        contentType: MediaType('application', 'octet-stream')));
    var res = await response.send();
    var responseBody = await res.stream.bytesToString();
    if (kDebugMode) {
      print(responseBody);
      print(res.statusCode);
    }

    var data = jsonDecode(responseBody);
    var bodyData = BuildProfileModel.fromJson(data);
    lst = [bodyData.success, bodyData.data?.child?.name];

    return lst;
  }

  Future<File> saveAudioPermanently(String path) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(path);
    final audio = File('${directory.path}/$name');
    return File(path).copy(audio.path);
  }
}
