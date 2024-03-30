import 'dart:convert';
import 'dart:io';
import 'package:untitled1/constants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:untitled1/screens/UserPage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/auth/SignUp.dart';
import 'package:http/http.dart' as http;
import 'package:untitled1/models/LogInModel.dart';
import 'package:untitled1/helpers/Utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'forgotPassword.dart';
import 'package:local_auth/local_auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String email = "", password = "";
  bool hidden = true;
  File? image;
  String? name;
  double deviceHeight = Constants().deviceHeight,
      deviceWidth = Constants().deviceWidth;

  String base_url = Constants().base_url;

  final formKey = GlobalKey<FormState>();

  late final LocalAuthentication auth;
  bool _supportState = false;

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
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Form(
        key: formKey,
        child: SafeArea(
          bottom: false,
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
              body: GestureDetector(
                onTap: () {
                  FocusScopeNode currentFocus = FocusScope.of(context);

                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                },
                child: SingleChildScrollView(
                  child: Column(children: [
                    SizedBox(
                      width: width * (20 / deviceWidth),
                      height: height * (30.0 / deviceHeight),
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.only(top: 60.0),
                        child: Text(
                          AppLocalizations.of(context)!.railwayBuddy,
                          style: TextStyle(
                              color: Colors.cyan[500],
                              fontSize: 50.0,
                              fontWeight: FontWeight.w700,
                              fontFamily: "productSansReg"),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        AppLocalizations.of(context)!.loginCatchphrase,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                            fontFamily: "productSansReg"),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Padding(padding: EdgeInsets.all(60.0)),
                    Container(
                        padding: const EdgeInsets.only(left: 35.0, right: 35.0),
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.all(13),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: AppLocalizations.of(context)!.email,
                                  hintStyle: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                      fontFamily: "productSansReg"),
                                  errorStyle: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "productSansReg"),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0),
                                      borderSide: BorderSide.none)),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (email) {
                                if (email != null &&
                                    !EmailValidator.validate(email)) {
                                  return 'Please enter a Valid Email';
                                }
                                return null;
                              },
                              controller: _emailController,
                              onSaved: (value) {
                                email = value!;
                              },
                            ),
                            const Padding(padding: EdgeInsets.all(10.0)),
                            TextFormField(
                              obscureText: hidden,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(10),
                                fillColor: Colors.white,
                                filled: true,
                                hintText:
                                    AppLocalizations.of(context)!.password,
                                hintStyle: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontFamily: "productSansReg"),
                                errorStyle: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "productSansReg"),
                                suffix: InkWell(
                                  onTap: () {
                                    setState(() {
                                      hidden = !hidden;
                                    });
                                  },
                                  child: Icon(
                                    !hidden
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    size: 20,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(7.0),
                                    borderSide: BorderSide.none),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter Password';
                                } else if (value.length < 6) {
                                  return "Enter minimum six characters";
                                }
                                return null;
                              },
                              controller: _passwordController,
                              onSaved: (value) {
                                password = value!;
                              },
                            ),
                            SizedBox(
                              width: width * (20 / deviceWidth),
                              height: height * (30.0 / deviceHeight),
                            ),
                            SizedBox(
                                width: width * (200.0 / deviceWidth),
                                height: height * (20.0 / deviceHeight),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        Colors.cyan[500],
                                      ),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(7.0),
                                      ))),
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      var lst = await LoginGetTokens(
                                          _emailController.text.trim(),
                                          _passwordController.text.trim());

                                      if (lst[1] == 200) {
                                        print(_supportState);
                                        if (_supportState) {
                                          bool? finger =
                                              await _fingerprintAuthenticate();

                                          if (finger!) {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            await prefs.setBool(
                                                'isLoggedIn', true);
                                            await prefs.setString(
                                                'token', lst[0]);

                                            Navigator.of(context).pop();
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        UserPage(
                                                          token: lst[0],
                                                        )));
                                            Utils.showSnackBar1(
                                                "Login successful!");
                                          } else {
                                            Utils.showSnackBar(
                                                "Enable fingerprint authentication.");
                                          }
                                        } else {
                                          Utils.showSnackBar("Error occurred");
                                        }
                                      }
                                    }
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.login,
                                    style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        fontFamily: "productSansReg"),
                                  ),
                                )),
                            SizedBox(
                              width: width * (20 / deviceWidth),
                              height: height * (10.0 / deviceHeight),
                            ),
                            GestureDetector(
                              child: Text(
                                AppLocalizations.of(context)!.forgotPassword,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "productSansReg"),
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPassWord()));
                              },
                            ),
                            SizedBox(
                              width: width * (20 / deviceWidth),
                              height: height * (40.0 / deviceHeight),
                            ),
                            RichText(
                              text: TextSpan(
                                  text: AppLocalizations.of(context)!.madeAnAcc,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "productSansReg"),
                                  children: [
                                    TextSpan(
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const SignUp()));
                                          },
                                        text:
                                            " ${AppLocalizations.of(context)!.forSignUp}.",
                                        style: TextStyle(
                                            fontFamily: "productSansReg",
                                            decoration:
                                                TextDecoration.underline,
                                            color: Colors.cyan[500]!))
                                  ]),
                            ),
                          ],
                        )),
                  ]),
                ),
              ),
            ),
          ),
        ));
  }

  Future LoginGetTokens(String? email, String? password) async {
    var res = await http.post(
      Uri.parse('$base_url/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body:
          jsonEncode(<String, String>{"email": email!, "password": password!}),
    );

    if (kDebugMode) {
      print(res.statusCode);
    }

    var responseBody = res.body;
    Map<String, dynamic> data = jsonDecode(responseBody);
    var loginData = LogInModel.fromJson(data);
    var list = [loginData.token, res.statusCode];
    return list;
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
}
