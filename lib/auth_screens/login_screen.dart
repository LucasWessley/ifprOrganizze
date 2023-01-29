import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../splashScreen/my_splash_screen.dart';
import '../global/global.dart';
import '../screens/home_screen.dart';
import '../widgets/custom_text_field.dart';


import '../widgets/loading_dialog.dart';

class LoginTabPage extends StatefulWidget {
  const LoginTabPage({Key? key}) : super(key: key);

  @override
  State<LoginTabPage> createState() => _LoginTabPageState();
}

class _LoginTabPageState extends State<LoginTabPage> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  validateForm() {
    if (emailTextEditingController.text.isNotEmpty &&
        passwordTextEditingController.text.isNotEmpty) {
      loginNow();
    } else {
      Fluttertoast.showToast(msg: "Informe seus dados.");
    }
  }

  loginNow() async {
    showDialog(
      context: context,
      builder: (c) {
        return LoadingDialogWidget(
          massage: "Validando informações..",
        );
      },
    );
    User? currentUser;
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    ).then((auth)
    {
      currentUser = auth.user;
    }).catchError((errorMessage)
    {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Erro:  \n $errorMessage");
    });

    if(currentUser != null)
    {
      checkIfUserRecordExists(currentUser!);
    }
  }

  checkIfUserRecordExists(User currentUser) async
  {
    await FirebaseFirestore.instance
        .collection("moderators")
        .doc(currentUser.uid)
        .get()
        .then((record) async
    {
      if(record.exists) //variavel record
          {
        //se estiver aprovado
        if(record.data()!["status"] == "aprovado")
        {
          await sharedPreferences!.setString("uid", record.data()!["uid"]);
          await sharedPreferences!.setString("email", record.data()!["email"]);
          await sharedPreferences!.setString("name", record.data()!["name"]);
          await sharedPreferences!.setString("photoUrl", record.data()!["photoUrl"]);

          //puxa a tela de home
          Navigator.push(context, MaterialPageRoute(builder: (c)=> MySplashScreen()));
        }
        else //se não estiver aprovado
            {
          FirebaseAuth.instance.signOut();
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Bloqueado, contate um administrador");
        }
      }
      else //se não existir
          {
        FirebaseAuth.instance.signOut();
        Navigator.pop(context, MaterialPageRoute(builder:(c) => MySplashScreen()));
        Fluttertoast.showToast(msg: "Essa conta não existe");
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextField(
                  textEditingController: emailTextEditingController,
                  iconData: Icons.email,
                  hintText: "E-mail",
                  isObscure: false,
                  enable: true,
                ),
// SizedBox(height: 12,),
//Senha
                CustomTextField(
                  textEditingController: passwordTextEditingController,
                  iconData: Icons.password,
                  hintText: "Senha",
                  isObscure: true,
                  enable: true,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                    ),
                    onPressed: () {
                      validateForm();
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
