import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:organizze_moderator/auth_screens/auth_screen.dart';
import 'package:organizze_moderator/screens/home_screen.dart';
import 'package:organizze_moderator/splashScreen/my_splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'global/global.dart';


Future <void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();



  //CONEXÃO WEB
  if(kIsWeb){
    await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyBbbfbXisBl7ebcs4lZWUnuNFRSeit3YRs",
          appId: "1:525741142028:web:fe26519183bb73a65f3e29",
          messagingSenderId: "525741142028",
          projectId: "ifprorganizze",
          storageBucket: "oifprorganizze.appspot.com"),
    );
  }else{
    await Firebase.initializeApp();
  }









  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Organizze Modder',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      debugShowCheckedModeBanner: false,
      home: AuthScreen(),
    );
  }
}

