import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth_screens/auth_screen.dart';
import '../screens/home_screen.dart';


class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  splashScreenTimer(){
    Timer(Duration(seconds: 2),()async{


      if(FirebaseAuth.instance.currentUser != null){
        Navigator.push(context, MaterialPageRoute(builder: (c)=>HomeScreen()));
      }else{
        Navigator.push(context, MaterialPageRoute(builder: (c)=>AuthScreen()));
      }



    });
}


@override
void initState() {

    super.initState();
    splashScreenTimer();//ligar o splash automatico
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
       color: Colors.white,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[ Padding(
              padding: EdgeInsets.all(12.0),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                    "images/assets/logo.png"
                ),
              ),
            ),
              // Text('Aqui vai um texto',
              // style: TextStyle(
              //   color: Colors.black,
              //   fontSize: 24,
              // ),),
        ],
          ),
        ),
      ),
    );
  }
}
