import 'package:flutter/material.dart';
import 'package:untitled1/screens/BuildProfile/makeUserCard.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants.dart';
import '../UserPage.dart';

class BuildProfile extends StatefulWidget {
  const BuildProfile({super.key, required this.token});
  final String token;

  @override
  State<BuildProfile> createState() => _BuildProfileState();
}

class _BuildProfileState extends State<BuildProfile> {
  double deviceHeight = Constants().deviceHeight,
      deviceWidth = Constants().deviceWidth;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
          backgroundColor: Colors.black,
          title: Text(
            AppLocalizations.of(context)!.addProfiles,
            style: const TextStyle(
                color: Colors.cyan,
                fontSize: 25.0,
                fontWeight: FontWeight.w700,
                fontFamily: "productSansReg"),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height * (10 / deviceHeight),
                width: width * (10 / deviceWidth),
              ),
              for (int i = 0; i < 3; i++)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: MakeUserCard(token: widget.token, index: i)),
                ),
              SizedBox(
                  width: width * (300.0 / deviceWidth),
                  height: height * (20.0 / deviceHeight),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.cyan),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                        ))),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UserPage(
                                token: widget.token,
                              )));
                    },
                    child: Text(
                      AppLocalizations.of(context)!.enter,
                      style: const TextStyle(
                        fontFamily: "productSansReg",
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
