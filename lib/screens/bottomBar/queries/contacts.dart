import 'package:flutter/material.dart';
import 'package:fast_contacts/fast_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../constants.dart';

class Contacts extends StatelessWidget {
  const Contacts({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceHeight = Constants().deviceHeight,
        deviceWidth = Constants().deviceWidth;

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Contacts"),
          centerTitle: true,
          backgroundColor: Colors.cyan,
          elevation: 0.0,
        ),
        body: SizedBox(
            height: double.infinity,
            child: FutureBuilder(
              future: getContacts(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                  return Center(
                    child: SizedBox(
                        width: deviceWidth * (10.0 / width),
                        height: deviceHeight * (50.0 / height),
                        child: const CircularProgressIndicator(
                          color: Colors.cyan,
                        )),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data?.length,
                    itemBuilder: (context, index) {
                      Contact contact = snapshot.data![index];
                      print(snapshot.data![index]);
                      return ListTile(
                        leading: const CircleAvatar(
                          radius: 20.0,
                          child: Icon(Icons.person),
                        ),
                        title: Text(contact.displayName),
                      );
                    });
              },
            )),
      ),
    );
  }
}

Future<List<Contact>> getContacts() async {
  bool isGranted = await Permission.contacts.isGranted;
  if (!isGranted) {
    isGranted = await Permission.contacts.request().isGranted;
  }
  if (isGranted) {
    return await FastContacts.getAllContacts();
  }
  return [];
}
