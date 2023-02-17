import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:organizze_moderator/global/global.dart';
import 'package:organizze_moderator/models/type_events.dart';
import 'package:organizze_moderator/screens/home_screen.dart';
import 'package:organizze_moderator/splashScreen/my_splash_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

import 'package:organizze_moderator/widgets/progress_bar.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class UploadItemScreen extends StatefulWidget {
  TypeEvent? model;
  BuildContext? context;

  UploadItemScreen({this.model, this.context});

  @override
  State<UploadItemScreen> createState() => _UploadItemScreenState();
}

class _UploadItemScreenState extends State<UploadItemScreen> {
  XFile? imgXFile;
  final ImagePicker imagePicker = ImagePicker();
  TextEditingController itemInfoTextEditingController = TextEditingController();
  TextEditingController itemNameTextEditingController = TextEditingController();
  TextEditingController itemDateStartTextEditingController =
      TextEditingController();
  TextEditingController itemDateEndTextEditingController =
      TextEditingController();
  TextEditingController itemLocalTextEditingController =
      TextEditingController();
  TextEditingController itemHourTextEditingController = TextEditingController();
  TextEditingController itemDescriptionTextEditingController =
      TextEditingController();
  TextEditingController itemDurationTextEditingController =
      TextEditingController();
  bool uploading = false;
  String downloadUrlImage = "";
  String itemUniqueId = DateTime.now().millisecondsSinceEpoch.toString();

  final dateFormatter = MaskTextInputFormatter(mask: '##/##/####',
      filter: {'#': RegExp(
        r'[0-9]',),
      });
  final phoneFormatter = MaskTextInputFormatter(mask: '## # ####-####',
      filter: {'#': RegExp(
        r'[0-9]',),
      });

  final hourFormatter = MaskTextInputFormatter(mask: '##:##',
      filter: {'#': RegExp(
        r'[0-9]',),
      });



  // String dateTimeInitial = "";
  // String dateTimeEnd = "";
  // DateTime _dateTime = DateTime.now();

  saveCatInfo() {
    FirebaseFirestore.instance
        .collection("moderators")
        .doc(sharedPreferences!.getString("uid"))
        .collection("categories")
        .doc(widget.model!.catID)
        .collection("items")
        .doc(itemUniqueId)
        .set({
      "itemID": itemUniqueId,
      "catID": widget.model!.catID.toString(),
      "moderatorUID": sharedPreferences!.getString("uid"),
      "moderatorName": sharedPreferences!.getString("name"),
      "itemName": itemNameTextEditingController.text.trim(),
      "itemDateStart": itemDateStartTextEditingController.text.trim(),
      "itemDateEnd": itemDateEndTextEditingController.text.trim(),
      "itemLocal": itemLocalTextEditingController.text.trim(),
      "itemHour": itemHourTextEditingController.text.trim(),
      "itemDuration": itemDurationTextEditingController.text.trim(),
      "itemDescription": itemDescriptionTextEditingController.text.trim(),
      "publishedDate": DateTime.now(),
      "thumbnailUrl": downloadUrlImage,
      "status": "aprovado",
    }).then((value) {
      FirebaseFirestore.instance.collection("items").doc(itemUniqueId).set({
        "itemID": itemUniqueId,
        "catID": widget.model!.catID.toString(),
        "moderatorUID": sharedPreferences!.getString("uid"),
        "moderatorName": sharedPreferences!.getString("name"),
        "itemName": itemNameTextEditingController.text.trim(),
        "itemDateStart": itemDateStartTextEditingController.text.trim(),
        "itemDateEnd": itemDateEndTextEditingController.text.trim(),
        "itemLocal": itemLocalTextEditingController.text.trim(),
        "itemHour": itemHourTextEditingController.text.trim(),
        "itemDuration": itemDurationTextEditingController.text.trim(),
        "itemDescription": itemDescriptionTextEditingController.text.trim(),
        "publishedDate": DateTime.now(),
        "status": "aprovado",
        "thumbnailUrl": downloadUrlImage,
      });
    });
    setState(() {
      uploading = false;
      itemUniqueId = DateTime.now().millisecondsSinceEpoch.toString();
    });
    Navigator.push(context, MaterialPageRoute(builder: (c) => HomeScreen()));
  }

  validateUploadForm() async {
    if (imgXFile != null) {
      if (itemNameTextEditingController.text.isNotEmpty &&
          itemDateStartTextEditingController.text.isNotEmpty &&
          itemDateEndTextEditingController.text.isNotEmpty &&
          itemLocalTextEditingController.text.isNotEmpty &&
          itemDescriptionTextEditingController.text.isNotEmpty) {
        setState(() {
          uploading = true;
        });
        // upa a imagem no servidor
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();

        fStorage.Reference storageRef = fStorage.FirebaseStorage.instance
            .ref()
            .child("itemImages")
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

  //
  // _showDatePicker() {
  //   showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2022),
  //     lastDate: DateTime(2025),
  //   ).then((value) {
  //     dateTimeInitial = value!.toString();
  //   });
  // }


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

          // ListTile(
          //   leading: Icon(
          //     Icons.perm_device_information,
          //     color: Colors.black,
          //   ),
          //   title: Container(
          //     width: 250,
          //     child: TextField(
          //       controller: itemInfoTextEditingController,
          //       decoration: InputDecoration(
          //         hintText: "Categoria",
          //         hintStyle: TextStyle(color: Colors.black),
          //         border: InputBorder.none,
          //       ),
          //     ),
          //   ),
          // ),
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
                controller: itemNameTextEditingController,
                decoration: InputDecoration(
                  hintText: "Nome do evento",
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
              Icons.calendar_today,
              color: Colors.black,
            ),
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Center(
                //   child: MaterialButton(
                //     onPressed: () {
                //       _showDatePicker();
                //       dateTimeInitial = _dateTime.day.toString();
                //       itemDateStartTextEditingController.text = dateTimeInitial.toString();
                //     },
                //     color: Colors.green,
                //     child: Padding(
                //       padding: EdgeInsets.all(5),
                //       child: Text(
                //         'Data Inicial',
                //         style: TextStyle(color: Colors.white),
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(width: 12,),
                // Center(
                //   child: MaterialButton(
                //     onPressed: () {
                //       _showDatePicker();
                //       dateTimeEnd = _dateTime.day.toString();
                //       itemDateEndTextEditingController.text = dateTimeEnd.toString();
                //     },
                //     color: Colors.green,
                //     child: Padding(
                //       padding: EdgeInsets.all(5),
                //       child: Text(
                //         'Data final',
                //         style: TextStyle(color: Colors.white),
                //       ),
                //     ),
                //   ),
                // ),

                Expanded(
                  child: Container(
                    width: 250,
                    child: TextField(
                      controller: itemDateStartTextEditingController,
                      decoration: InputDecoration(
                        hintText: "Data Inicial",
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                      ),
                      inputFormatters: [
                        dateFormatter
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 250,
                    child: TextField(
                      controller: itemDateEndTextEditingController,
                      decoration: InputDecoration(
                        hintText: "Data Final",
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none,
                      ),
                      inputFormatters: [
                        dateFormatter
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 2,
          ),
          // Text(itemDateStartTextEditingController.toString()),
          ListTile(
            leading: Icon(
              Icons.description_outlined,
              color: Colors.black,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: itemDescriptionTextEditingController,
                decoration: InputDecoration(
                  hintText: "Descrição do Evento",
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
              Icons.timer,
              color: Colors.black,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: itemDurationTextEditingController,
                decoration: InputDecoration(
                  hintText: "Duração",
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
                inputFormatters: [
                  hourFormatter
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 2,
          ),
          ListTile(
            leading: Icon(
              Icons.timer_outlined,
              color: Colors.black,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: itemHourTextEditingController,
                decoration: InputDecoration(
                  hintText: "Horário",
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
                inputFormatters: [
                  hourFormatter
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.grey,
            thickness: 2,
          ),
          ListTile(
            leading: Icon(
              Icons.local_library_outlined,
              color: Colors.black,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: itemLocalTextEditingController,
                decoration: InputDecoration(
                  hintText: "Local do evento",
                  hintStyle: TextStyle(color: Colors.black),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
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
          "Novo Evento",
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
                Icons.event,
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
                child: Text("Novo Evento"),
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
