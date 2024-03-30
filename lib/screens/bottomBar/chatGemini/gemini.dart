import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:path_provider/path_provider.dart';
import 'package:untitled1/helpers/Utils.dart';
import '../../../constants.dart';
import 'chatBubble.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

String apiKey = Constants().apiKey;

class GeminiPage extends StatefulWidget {
  const GeminiPage({super.key});

  @override
  State<GeminiPage> createState() => _GeminiPageState();
}

class _GeminiPageState extends State<GeminiPage> {
  final model = GenerativeModel(
      model: 'gemini-pro-vision',
      apiKey: apiKey,);
  final modelText = GenerativeModel(
      model: 'gemini-pro', apiKey: apiKey);

  double deviceHeight = Constants().deviceHeight,
      deviceWidth = Constants().deviceWidth;
  String promptGemini = Constants().prompt;

  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<String> lst = [];
  bool readOnly = false;
  File? image;
  String? name;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    print(promptGemini);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: lst.length,
                      itemBuilder: (context, index) {
                        return index % 2 == 0
                            ? ChatBubble(text: lst[index], isCurrentUser: true)
                            : ChatBubble(
                                text: lst[index], isCurrentUser: false);
                      },
                    ),
                  ),
                  SizedBox(
                    height: height * (40 / deviceHeight),
                  ),
                  if (image != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.cyan,
                            width: 2,
                          ),
                        ),
                        child: Image.file(
                          image!,
                          width: width * (250 / deviceWidth),
                          height: height * (75 / deviceHeight),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                        child: TextFormField(
                      readOnly: readOnly,
                      controller: _controller,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          hintText: "Enter text and/or image",
                          hintStyle: TextStyle(
                            fontSize: 17.5,
                            fontWeight: FontWeight.w500,
                            color: Colors.cyan[500],
                          ),
                          suffix: SizedBox(
                            width: width * (200 / deviceWidth),
                            height: height * (10 / deviceHeight),
                            child: !readOnly
                                ? Row(children: [
                                    InkWell(
                                      onTap: () async {
                                        var path = await pickImage();
                                      },
                                      child: Icon(
                                        Icons.image,
                                        size: 25,
                                        color: Colors.cyan[500],
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * (50 / deviceWidth),
                                    ),
                                    InkWell(
                                      onTap: () async {

                                        String text = _controller.text.trim();

                                        setState(() {
                                          lst.add(text);
                                          _controller.clear();
                                          readOnly = !readOnly;
                                        });

                                        late final response;

                                        final prompt =
                                            TextPart(promptGemini + text);

                                        if (image != null) {
                                          final imageBytes =
                                              await image!.readAsBytes();

                                          final imageParts = [
                                            DataPart('image/jpeg', imageBytes),
                                          ];

                                          response =
                                              await model.generateContent([
                                            Content.multi(
                                                [prompt, ...imageParts])
                                          ]);
                                          if (kDebugMode) {
                                            print(response.text);
                                          }

                                          setState(() {
                                            lst.add(response.text!);
                                            readOnly = !readOnly;
                                          });
                                        } else {
                                          final content = [
                                            Content.text(promptGemini + text)
                                          ];

                                          response = await modelText
                                              .generateContent(content);
                                        }

                                        print(response.text);

                                        try {
                                          if (response.text == '0') {
                                            setState(() {
                                              lst.add(
                                                  "Okay, performing this task!");
                                              readOnly = !readOnly;
                                            });
                                          } else {
                                            setState(() {
                                              lst.add(response.text!);
                                              readOnly = !readOnly;
                                            });
                                          }
                                        } catch (e) {
                                          Utils.showSnackBar(e.toString());
                                          setState(() {
                                            lst.add(
                                                "Sorry, can't answer that!");
                                            readOnly = !readOnly;
                                          });
                                        }
                                      },
                                      child: Icon(
                                        Icons.send_rounded,
                                        size: 25,
                                        color: Colors.cyan[500],
                                      ),
                                    ),
                                  ])
                                : const Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: SpinKitDoubleBounce(
                                      color: Colors.cyan,
                                    )),
                          ),
                          fillColor: Colors.white),
                    )),
                  ),
                ])),
      ),
    );
  }

  Future pickImage() async {
    try {
      final XFile? image = await ImagePicker().pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front);
      if (image == null) return;
      File imagePath = await saveImagePermanently(image.path);
      name = image.name;
      setState(() {
        this.image = imagePath;
      });
      return imagePath;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Failed to pick image: $e');
      }
    }
  }

  Future<File> saveImagePermanently(String path) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(path);
    final image = File('${directory.path}/$name');
    return File(path).copy(image.path);
  }
}
