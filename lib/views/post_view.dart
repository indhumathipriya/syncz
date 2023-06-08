import 'dart:convert';
import 'dart:io';
//import 'dart:io' as Io;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:syncz/confiqs/common_widget/ui_alert_dialog.dart';
import 'package:syncz/confiqs/common_widget/ui_textfield.dart';

import 'package:syncz/confiqs/shared.dart/ui_snackbar.dart';
// ignore: library_prefixes
import 'dart:io' as Io;
import '../confiqs/common_widget/ui_button.dart';
import '../confiqs/shared.dart/constant.dart';
import '../confiqs/shared.dart/shared_pref.dart';

class PostView extends StatefulWidget {
  const PostView({super.key});

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  //variable declarations
  final controller = TextEditingController();
  final CollectionReference uploadImage =
      FirebaseFirestore.instance.collection('post');
  File? _image;
  late String decoImage = "";
  late Uint8List bytesImage;
  final picker = ImagePicker();
  String image64 = "";
  String id = SharedPreferenceHelper.shared.userId;
  //picking image from camera
  Future getImageCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile!.path);
    });
    final bytes = Io.File(_image!.path).readAsBytesSync();
    image64 = base64Encode(bytes);
    debugPrint(image64);
  }

//picking image from gallery
  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile!.path);
    });
    final bytes = Io.File(_image!.path).readAsBytesSync();
    image64 = base64Encode(bytes);
    debugPrint(image64);
  }

//uploading Image
  Future<String?> uploadingImage(BuildContext context) async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    try {
      await uploadImage.add({
        'comment': '',
        'caption': controller.text,
        'imageSrc': image64,
        'like': false,
        'username': firebaseUser!.displayName.toString() ,
        'userid': id
      });

      // Data added successfully
      // ignore: use_build_context_synchronously
      return SnackMesage.exception("Success", context);
    } catch (error) {
      debugPrint('Error in uploading image: $error');
      SnackMesage.exception("$error", context);
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _showDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavBar(context),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
            ),
            _buildImage(),
            _buildTextField('Caption'),
          ],
        ),
      ),
    );
  }

  showImgDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UiAlertDialog(onGallery: () {
          getImageGallery();
        }, onCamera: () {
          getImageCamera();
        });
      },
    );
  }

  _buildTextField(String hintText) {
    return UiTextField(ctrl: controller, text: hintText);
  }

  _bottomNavBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constant.appDefaultPadding * 2),
      child: UiPrimaryButton(
          backgroundColor: Constant.appPrimary,
          foregroundColor: Constant.appWhite,
          onPressed: () {
            uploadingImage(context);
          },
          text: "Upload"),
    );
  }

  _showDialog() {
    return Future.delayed(
      const Duration(milliseconds: 3),
      () {
        return showImgDialog(context);
      },
    );
  }

  _buildImage() {
    return _image != null
        ? Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(Constant.appDefaultPadding / 2),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: FileImage(_image!),
              ),
            ),
          )
        : SizedBox(
            height: MediaQuery.of(context).size.height * 0.30,
          );
  }
}
