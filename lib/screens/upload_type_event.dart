import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:organizze_moderator/global/global.dart';
import 'package:organizze_moderator/screens/home_screen.dart';
import 'package:organizze_moderator/splashScreen/my_splash_screen.dart';
import 'package:organizze_moderator/widgets/myBoxDecoration.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

import 'package:organizze_moderator/widgets/progress_bar.dart';

class UploadTypeEvent extends StatefulWidget {

  @override
  State<UploadTypeEvent> createState() => _UploadTypeEventState();
}

class _UploadTypeEventState extends State<UploadTypeEvent> {
  XFile? imgXFile;
  final ImagePicker imagePicker = ImagePicker();
  TextEditingController cattypeTextEditingController = TextEditingController();
  TextEditingController catnameTextEditingController = TextEditingController();
  bool uploading = false;
  String downloadUrlImage = "";
  String catUniqueId = DateTime.now().millisecondsSinceEpoch.toString();

  saveCatInfo() {
    FirebaseFirestore.instance
        .collection('moderators')
        .doc(sharedPreferences!.getString("uid"))
        .collection('categories')
        .doc(catUniqueId)
        .set({
      "catID": catUniqueId,
      "moderatorUID": sharedPreferences!.getString('uid'),
      "catType": cattypeTextEditingController.text.trim(),
      "catName": catnameTextEditingController.text.trim(),
      "publishedDate": DateTime.now(),
      "thumbnailUrl" : downloadUrlImage,
      "status" : "aprovado",
    });
    setState(() {
      uploading = false;
      String catUniqueId = DateTime.now().millisecondsSinceEpoch.toString();
    });
    Navigator.push(context, MaterialPageRoute(builder: (c)=> HomeScreen()));
  }

  validateUploadForm() async {
    if (imgXFile != null) {
      if (cattypeTextEditingController.text.isNotEmpty &&
          catnameTextEditingController.text.isNotEmpty) {
        setState(() {
          uploading = true;
        });
        // upar a imagem
        // upa a imagem no servidor
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();

        fStorage.Reference storageRef = fStorage.FirebaseStorage.instance
            .ref()
            .child("categoriesImages")
            .child(fileName);

        fStorage.UploadTask uploadImageTask =
            storageRef.putFile(File(imgXFile!.path));

        fStorage.TaskSnapshot taskSnapshot =
            await uploadImageTask.whenComplete(() {});

        await taskSnapshot.ref.getDownloadURL().then((urlImage) {
          downloadUrlImage = urlImage;
        });

        //salva as outras infos
        saveCatInfo();
      } else {
        Fluttertoast.showToast(msg: "Preencha todos os campos");
      }
    } else {
      Fluttertoast.showToast(msg: "Favor insira uma imagem");
    }
  }

  uploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (c) => MySplashScreen()));
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                uploading == true ? null : validateUploadForm();
              },
              icon: Icon(Icons.cloud_upload),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading == true ? linearProgressBar() : Container(),
          SizedBox(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: FileImage(
                      File(
                        imgXFile!.path,
                      ),
                    ),
                  )),
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 2,
          ),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.black,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: cattypeTextEditingController,
                decoration: InputDecoration(
                  hintText: "Tipo categoria",
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 2,
          ),
          ListTile(
            leading: Icon(
              Icons.title_outlined,
              color: Colors.black,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: catnameTextEditingController,
                decoration: InputDecoration(
                  hintText: "Nome categoria",
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return imgXFile == null ? defaultScreen() : uploadFormScreen();
  }

  defaultScreen() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (c) => HomeScreen()));
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(color: Colors.green),
        ),
        title: Text(
          "Cadastrar tipo de evento",
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_a_photo_outlined,
                color: Colors.grey,
                size: 200,
              ),
              ElevatedButton(
                onPressed: () {
                  obtainImageDialogBox();
                },
                style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                child: Text("Criar novo tipo de evento"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  obtainImageDialogBox() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              'Fonte da imagem',
              style: TextStyle(color: Colors.black),
            ),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  captureImageFromPhoneCamera();
                },
                child: Text(
                  'Capturar com a camera',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  getImageFromGallery();
                },
                child: Text(
                  'Selecionar da galeria',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Center(
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  getImageFromGallery() async {
    Navigator.pop(context);
    imgXFile = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imgXFile;
    });
  }

  captureImageFromPhoneCamera() async {
    Navigator.pop(context);
    imgXFile = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imgXFile;
    });
  }
}
