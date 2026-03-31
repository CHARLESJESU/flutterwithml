import 'package:firebase_core/firebase_core.dart';
import 'package:firebasewithml/Bar_Code_Scanner.dart';
import 'package:firebasewithml/DetailScreen.dart';
import 'package:firebasewithml/Face_Detector.dart';
import 'package:firebasewithml/Label_Scanner.dart';
import 'package:firebasewithml/google_signin.dart';
import 'package:flutter/material.dart';

import 'firebasemessage(1).dart';
import 'firebasemessaging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Myapp());
}

class Myapp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Myapp1();
  }
}

class Myapp1 extends State<Myapp> {
  // final _notificationService = NotificationService();

  List<String> itemList = [
    'Text Scanner',
    'Bar Code Scanner',
    'Label Scanner',
    'Face Detector',
    'Google SignIn',
    'Firebase Message'
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase App',
      home: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              "Firebase ML",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.blue),
            ),
            backgroundColor: Colors.white,
          ),
          body: ListView.builder(
              itemCount: itemList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(onTap: (){
                    if(itemList[index]=='Text Scanner') {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Detailscreen(),
                          settings: RouteSettings(arguments: itemList[index])));
                    }
                    else if(itemList[index]=='Bar Code Scanner') {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => BarCodeScanner(),
                          settings: RouteSettings(arguments: itemList[index])));
                    }
                   else if(itemList[index]=='Label Scanner') {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => LabelScanner(),
                          settings: RouteSettings(arguments: itemList[index])));
                    }
                    else if(itemList[index]=='Google SignIn') {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => Login(),
                          settings: RouteSettings(arguments: itemList[index])));
                    }
                    // else if (itemList[index] == 'Firebase Message') {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //       builder: (context) => FirebaseMessageScreen(),
                    //       settings: RouteSettings(arguments: itemList[index]),
                    //     ),
                    //   );
                    // }
                    else {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => FaceDetectionScreen(),
                          settings: RouteSettings(arguments: itemList[index])));
                    }
                  },
                    title: Text(
                      itemList[index],
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  color: Colors.blue,
                );
              })),
    );
  }
}
