import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/helpers/Utils.dart';
import 'package:untitled1/models/identifyUserModel.dart';
import 'package:untitled1/screens/bottomBar/queries/contacts.dart';
import 'package:untitled1/screens/bottomBar/queries/web_search.dart';
import '../../../constants.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:translator/translator.dart';

var lst = [];
var authLst = [];

class AudioInput extends StatefulWidget {
  const AudioInput({super.key});

  @override
  State<AudioInput> createState() => _AudioInputState();
}

class _AudioInputState extends State<AudioInput>
    with SingleTickerProviderStateMixin {
  String lastWords = '';
  int maxDuration = 10;

  double deviceHeight = Constants().deviceHeight,
      deviceWidth = Constants().deviceWidth;

  late AnimationController _controller;

  final recorder = FlutterSoundRecorder();
  final player = FlutterSoundPlayer();

  bool isRecorderReady = false,
      gotSomeTextYo = false,
      isPlaying = false,
      isNameDisplayed = false;
  String TTSLocaleID = 'en-IN', nameDisplay = "";
  String _secondLanguage = 'English';
  String ngrokurl = Constants().ngrokurl;
  final translator = GoogleTranslator();

  String base_url = Constants().base_url;

  late final LocalAuthentication auth;
  bool _supportState = false;

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

    authLst = await sendAudioForUser(audioPath);
    setState(() {
      nameDisplay = authLst[1];
      isNameDisplayed = true;
    });

    lst = await sendAudio(audioPath);

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
    auth = LocalAuthentication();
    auth.isDeviceSupported().then((bool isSupported) {
      print("hi$isSupported");
      setState(() {
        _supportState = isSupported;
      });
    });

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

    initRecorder();

    player.openPlayer().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    recorder.closeRecorder();
    player.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.grey[900]!,
                Colors.black,
                Colors.grey[900]!,
              ]),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: 20 * (height / deviceHeight),
                ),
                if (isNameDisplayed)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Hello ' + nameDisplay + "!",
                      style: const TextStyle(
                          fontFamily: "productSansReg",
                          color: Colors.cyan,
                          fontWeight: FontWeight.w700,
                          fontSize: 25),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    AppLocalizations.of(context)!.speakMic,
                    style: const TextStyle(
                        fontFamily: "productSansReg",
                        color: Colors.cyan,
                        fontWeight: FontWeight.w700,
                        fontSize: 25),
                  ),
                ),
                SizedBox(
                  height: 30 * (height / deviceHeight),
                ),
                StreamBuilder<RecordingDisposition>(
                    stream: recorder.onProgress,
                    builder: (context, snapshot) {
                      final duration = snapshot.hasData
                          ? snapshot.data!.duration
                          : Duration.zero;
                      String twoDigits(int n) => n.toString().padLeft(2, '0');
                      final twoDigitMinutes =
                          twoDigits(duration.inMinutes.remainder(60));
                      final twoDigitSeconds =
                          twoDigits(duration.inSeconds.remainder(60));
                      return Text(
                        "$twoDigitMinutes:$twoDigitSeconds s",
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan,
                          fontFamily: "productSansReg",
                        ),
                      );
                    }),
                SizedBox(
                  height: 40 * (height / deviceHeight),
                ),
                if (isPlaying)
                  Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.cyan,
                    size: 20 * (height / deviceHeight),
                  )),
                if (!isPlaying)
                  SizedBox(
                    height: 60 * (height / deviceHeight),
                    child: gotSomeTextYo
                        ? Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1.5, color: const Color(0xFF009CFF)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SingleChildScrollView(
                                child: Text(
                                  lastWords,
                                  style: const TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "productSansReg",
                                      color: Color(0xFF009CFF)),
                                ),
                              ),
                            ),
                          )
                        : const Padding(
                            padding: EdgeInsets.all(8.0),
                          ),
                  ),
                if (!isPlaying)
                  SizedBox(
                    height: 50 * (height / deviceHeight),
                  ),
                if (isPlaying)
                  SizedBox(
                    height: 80 * (height / deviceHeight),
                  ),
                Container(
                  alignment: Alignment.center,
                  height: 50 * (height / deviceHeight),
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

                        if (!['files', 'email', 'call', 'web_search']
                            .contains(lst[0])) {
                          if (kDebugMode) {
                            print("Before translation:${lst[0]}");
                          }
                          Translation x = await translator.translate(lst[0],
                              from: 'en', to: lst[1]);
                          lastWords = x.text;
                          gotSomeTextYo = true;
                          if (kDebugMode) {
                            print("After translation:$lastWords");
                          }
                        } else {
                          if (lst[0] == 'call') {
                            lastWords = lst[2];
                            await _fingerprintAuthenticate();
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Contacts()));
                            _callNumber();
                          }
                          if (lst[0] == 'web_search') {
                            lastWords = lst[2];
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => WebSearch(
                                      query: lst[2],
                                    )));
                          }
                        }
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
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(isPlaying ? 6 : 60),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20 * (height / deviceHeight),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<dynamic>> sendAudioForUser(File? audioPath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    List<dynamic> lst = [];
    var response = http.MultipartRequest(
      'POST',
      Uri.parse('$base_url/voice-match/'),
    );
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
    var bodyData = IdentifyUserModel.fromJson(data);
    lst = [bodyData.success, bodyData.name];

    Utils.showSnackBar1("Welcome, ${lst[1]}!");

    return lst;
  }

  Future<List<dynamic>> sendAudio(File? audioPath) async {
    List<dynamic> lst = [];
    var response = http.MultipartRequest(
      'POST',
      Uri.parse('$ngrokurl/transcription'),
    );
    response.files.add(http.MultipartFile(
        'audio', audioPath!.readAsBytes().asStream(), audioPath.lengthSync(),
        filename: basename(audioPath.path),
        contentType: MediaType('application', 'octet-stream')));
    var res = await response.send();
    var responseBody = await res.stream.bytesToString();
    if (kDebugMode) {
      print(responseBody);
      print(res.statusCode);
    }

    var data = jsonDecode(responseBody);

    if (responseBody.contains("predicted")) {
      lst.addAll([data['predicted'], data['src_lang'], data['src']]);
    } else {
      lst.addAll([data['message'], data['src_lang'], data['src']]);
    }

    return lst;
  }

  Future<bool?> _fingerprintAuthenticate() async {
    try {
      bool authenticated = await auth.authenticate(
          localizedReason:
              "To secure your app companion in ways more than one.",
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ));
      debugPrint("Authenticated: $authenticated");
      return authenticated;
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }

  Future<File> saveAudioPermanently(String path) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(path);
    final audio = File('${directory.path}/$name');
    return File(path).copy(audio.path);
  }

  _callNumber() async {
    const number = '+91 98192 81311'; //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  }
}
