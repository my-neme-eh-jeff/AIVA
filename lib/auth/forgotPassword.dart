import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/helpers/Utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../constants.dart';

class ForgotPassWord extends StatefulWidget {
  const ForgotPassWord({super.key});

  @override
  State<ForgotPassWord> createState() => _ForgotPassWordState();
}

class _ForgotPassWordState extends State<ForgotPassWord> {
  final formKey = GlobalKey<FormState>();
  double deviceHeight = Constants().deviceHeight,
      deviceWidth = Constants().deviceWidth;

  String email = "";

  final TextEditingController emailController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Form(
        key: formKey,
        child: SafeArea(
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
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
              child: Center(
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
                            child: Center(
                          child: Column(children: [
                            SizedBox(
                              width: width * (20 / deviceWidth),
                              height: height * (30 / deviceHeight),
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
                                  color: Colors.cyan[500],
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 230),
                              child: Text(
                                AppLocalizations.of(context)!.resetPass,
                                style: TextStyle(
                                  fontFamily: "productSansReg",
                                  color: Colors.cyan[500],
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            const Padding(padding: EdgeInsets.all(20.0)),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 35.0, right: 35.0),
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(13),
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText:
                                        AppLocalizations.of(context)!.email,
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
                                validator: (email) {
                                  if (email != null &&
                                      !EmailValidator.validate(email)) {
                                    return 'Please enter a Valid Email';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  email = value!;
                                },
                                controller: emailController,
                              ),
                            ),
                            const Padding(padding: EdgeInsets.all(20.0)),
                            SizedBox(
                                width: width * (300.0 / deviceWidth),
                                height: height * (20.0 / deviceHeight),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.cyan[500]),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(7.0),
                                      ))),
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      Utils.showSnackBar1(
                                          "Email sent to ${emailController.text.trim()}");
                                    }
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.sendEmail,
                                    style: const TextStyle(
                                      fontFamily: "productSansReg",
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                          ]),
                        )))),
              )),
        ));
  }
}
