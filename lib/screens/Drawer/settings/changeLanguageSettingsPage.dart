import 'package:untitled1/screens/UserPage.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants.dart';

class SelectLanguageDropdownSetting extends StatefulWidget {
  const SelectLanguageDropdownSetting({super.key});

  @override
  State<SelectLanguageDropdownSetting> createState() =>
      _SelectLanguageDropdownSettingState();
}

class _SelectLanguageDropdownSettingState
    extends State<SelectLanguageDropdownSetting> {
  String selectedVal = 'en';
  double deviceHeight = Constants().deviceHeight,
      deviceWidth = Constants().deviceWidth;
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
                body: Center(
                  child: Column(children: [
                    SizedBox(
                      width: width * (20 / deviceWidth),
                      height: height * (30.0 / deviceHeight),
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 300.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_sharp),
                          color: Colors.cyan,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 35 * (height / deviceHeight),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocalizations.of(context)!.chooseLanguage,
                        style: const TextStyle(
                            fontFamily: "productSansReg",
                            color: Color(0xFF009CFF),
                            fontWeight: FontWeight.w700,
                            fontSize: 30),
                      ),
                    ),
                    SizedBox(
                      height: 20 * (height / deviceHeight),
                    ),
                    Lottie.asset(
                      'assets/languageTranslate.json',
                      width: 150 * (height / deviceHeight),
                      height: 150 * (height / deviceHeight),
                      fit: BoxFit.contain,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: DropdownButtonFormField(
                        onChanged: (v) => setState(() async {
                          MainApp.setLocale(context, Locale(v.toString()));
                          selectedVal = v!;
                          var prefs = await SharedPreferences.getInstance();
                          prefs.setString('languageCode', v);
                        }),
                        value: selectedVal,
                        items: const [
                          DropdownMenuItem(
                            value: 'en',
                            child: Text('English'),
                          ),
                          DropdownMenuItem(value: 'hi', child: Text('हिंदी')),
                          DropdownMenuItem(value: 'mr', child: Text('मराठी')),
                          DropdownMenuItem(
                              value: 'fr', child: Text('Française')),
                          DropdownMenuItem(value: 'ar', child: Text('عربي')),
                          DropdownMenuItem(value: 'pa', child: Text('فارسی')),
                        ],
                        style: const TextStyle(
                            fontFamily: "productSansReg",
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 20),
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(13),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide.none)),
                      ),
                    ),
                    SizedBox(
                      height: 20 * (height / deviceHeight),
                    ),
                  ]),
                ))));
  }
}
