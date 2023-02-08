import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../splashScreen/my_splash_screen.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();

    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (c) => MySplashScreen()));
                },
                child: Text('Link para alteração da senha enviado! Confira seu e-mail!')),

          );
        },

      );

    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),

          );

        },

      );

    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperar senha'),
        backgroundColor: Colors.green,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              'Digite seu e-mail e receberá um link para alterar sua senha',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18,),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: _emailController,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.deepPurple),
                ),
                hintText: 'E-mail',
                fillColor: Colors.white,
                filled: true,

              ),
            ),
          ),
          SizedBox(height: 15,),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
              padding:
              EdgeInsets.symmetric(horizontal: 50, vertical: 12),
            ),
              onPressed: () async {
                passwordReset();
               await Navigator.push(context, MaterialPageRoute(builder: (c) => MySplashScreen()));
              },
              child: Text('Recuperar senha')),
        ],
      ),
    );
  }
}
