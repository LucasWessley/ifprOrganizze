import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:shared_preferences/shared_preferences.dart';

import '../global/global.dart';
import '../screens/home_screen.dart';
import '../splashScreen/my_splash_screen.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/loading_dialog.dart';

class RegistrationTabPage extends StatefulWidget {
  const RegistrationTabPage({Key? key}) : super(key: key);

  @override
  State<RegistrationTabPage> createState() => _RegistrationTABPageState();
}

class _RegistrationTABPageState extends State<RegistrationTabPage> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController lastnameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmpassTextEditingController =
      TextEditingController();
  String downloadUrlImage = "";

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  XFile? imgXFile;
  final ImagePicker imagePicker = ImagePicker();

  getImageFromGallery() async {
    imgXFile = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imgXFile;
    });
  }

  formValidation() async {
    if (imgXFile == null) //image is not selected
    {
      Fluttertoast.showToast(msg: "Selecione uma imagem!");
    } else //image is already selected
    {
      //autenticar o usuario
      if (passwordTextEditingController.text ==
          confirmpassTextEditingController.text) {
        //autentica os demais campos
        if (nameTextEditingController.text.isNotEmpty &&
            emailTextEditingController.text.isNotEmpty &&
            passwordTextEditingController.text.isNotEmpty &&
            confirmpassTextEditingController.text.isNotEmpty &&
            phoneTextEditingController.text.isNotEmpty) {
          showDialog(
              context: context,
              builder: (c) {
                return LoadingDialogWidget(
                  massage: "Registrando sua conta...",
                );
              });

          // upa a imagem no servidor
          String fileName = DateTime.now().millisecondsSinceEpoch.toString();

          fStorage.Reference storageRef = fStorage.FirebaseStorage.instance
              .ref()
              .child("moderatorImages")
              .child(fileName);

          fStorage.UploadTask uploadImageTask =
              storageRef.putFile(File(imgXFile!.path));

          fStorage.TaskSnapshot taskSnapshot =
              await uploadImageTask.whenComplete(() {});

          await taskSnapshot.ref.getDownloadURL().then((urlImage) {
            downloadUrlImage = urlImage;
          });

          // salva as informações no database local
          saveInformationToDatabase();
        } else {
          Navigator.pop(context);
          Fluttertoast.showToast(msg: "Não deixe nenhum campo em branco!");
        }
      } else //se as senhas estiverem divergentes
      {
        Fluttertoast.showToast(msg: "As senhas não conferem.");
      }
    }
  }

  saveInformartionToDatabase() async {
    //autenticar o usuario
    User? currentUser;
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailTextEditingController.text.trim(),
            password: passwordTextEditingController.text.trim())
        .then((auth) {
      currentUser = auth.user;
    }).catchError((errorMessage) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "ERRO:\n $errorMessage");
    });

    if (currentUser != null) {
      //salvar no database
      saveInfoToFirestoreAndLocally(currentUser!);
    }
  }

  saveInformationToDatabase() async {
    //Autentica o Usuario
    User? currentUser;

    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
    }).catchError((errorMessage) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error Occurred: \n $errorMessage");
    });

    if (currentUser != null) {
      // salvar as info do usuario
      saveInfoToFirestoreAndLocally(currentUser!);
    }
  }

  saveInfoToFirestoreAndLocally(User currentUser) async {
    //no firestore
    FirebaseFirestore.instance
        .collection("moderators")
        .doc(currentUser.uid)
        .set({
      "uid": currentUser.uid,
      "email": currentUser.email,
      "name": nameTextEditingController.text.trim(),
      "phone": phoneTextEditingController.text.trim(),
      "photoUrl": downloadUrlImage,
      "status": "aprovado",
    });

    //local
    sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences!.setString("uid", currentUser.uid);
    await sharedPreferences!.setString("email", currentUser.email!);
    await sharedPreferences!
        .setString("name", nameTextEditingController.text.trim());
    await sharedPreferences!.setString("photoUrl", downloadUrlImage);
    await sharedPreferences!.setStringList("userCart", ["initialValue"]);

    Navigator.push(context, MaterialPageRoute(builder: (c) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 12,
            ),

            //Capturar imagem
            GestureDetector(
              onTap: () {
                getImageFromGallery();
              },
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.20,
                backgroundColor: Colors.white,
                backgroundImage:
                    imgXFile == null ? null : FileImage(File(imgXFile!.path)),
                child: imgXFile == null
                    ? Icon(
                        Icons.add_photo_alternate,
                        color: Colors.grey,
                        size: MediaQuery.of(context).size.width * 0.20,
                      )
                    : null,
              ),
            ),
            SizedBox(
              height: 12,
            ),

            Form(
                key: formKey,
                child: Column(
                  children: [
//NOME
                    CustomTextField(
                      textEditingController: nameTextEditingController,
                      iconData: Icons.person,
                      hintText: "Nome",
                      isObscure: false,
                      enable: true,
                    ),
//sobrenome
//                     CustomTextField(
//                       textEditingController: lastnameTextEditingController,
//                       iconData: Icons.person,
//                       hintText: "Sobrenome",
//                       isObscure: false,
//                       enable: true,
//                     ),
//Email
                    CustomTextField(
                      textEditingController: emailTextEditingController,
                      iconData: Icons.email,
                      hintText: "E-mail",
                      isObscure: false,
                      enable: true,
                    ),
//phone
                    CustomTextField(
                      textEditingController: phoneTextEditingController,
                      iconData: Icons.settings_cell,
                      hintText: "Telefone",
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
                    //Confirmar senha
                    CustomTextField(
                      textEditingController: confirmpassTextEditingController,
                      iconData: Icons.password,
                      hintText: "Confime sua senha",
                      isObscure: true,
                      enable: true,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 12),
                        ),
                        onPressed: () {
                          formValidation();
                        },
                        child: Text(
                          'Cadastrar',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ))
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
