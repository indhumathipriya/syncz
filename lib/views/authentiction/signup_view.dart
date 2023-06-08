import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:syncz/confiqs/common_widget/ui_appbar.dart';
import 'package:syncz/confiqs/shared.dart/constant.dart';
import 'package:syncz/confiqs/shared.dart/ui_navigation.dart';
import 'package:syncz/confiqs/shared.dart/ui_snackbar.dart';
import 'package:syncz/controller/state_update.dart';
import 'package:syncz/model/user_model.dart';
import 'package:syncz/views/dashboard/dashboard_view.dart';
import 'dart:io' as Io;
import '../../confiqs/common_widget/ui_alert_dialog.dart';
import '../../confiqs/common_widget/ui_button.dart';
import '../../confiqs/shared.dart/shared_pref.dart';

class SignUpView extends StatefulWidget {
  final bool isEdit;
  const SignUpView({super.key, this.isEdit = false});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  //variable declarations
  final controller = TextEditingController();
  final CollectionReference createUser =
      FirebaseFirestore.instance.collection('usertable');
  File? _image;
  late String decoImage = "";
  late Uint8List bytesImage;
  final picker = ImagePicker();
  String image64 = "";
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

//validating userName 
  bool validate() {
    if (controller.text.isEmpty) {
      return SnackMesage.exception("Enter valid user name", context);
    }
    return true;
  }

//update profile
  Future<void> updateProfile() async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    String? id;
    if (firebaseUser != null) {
      id = firebaseUser.uid;
    } else {
      id = ProviderState().id;
    }
    final editUser =
        UserModel(id: id!, imageSrc: image64, name: controller.text.trim());
    await FirebaseFirestore.instance
        .collection('usertable')
        .doc(firebaseUser!.uid)
        .update(editUser.toJson());
  }

  //creating account in database
  Future<String> createUserAccount(BuildContext context) async {
    final DocumentReference docRef = await createUser.add({
      'name': controller.text.trim(),
      'profile': image64,
    }).catchError((error) {
      debugPrint('Error creating user account: $error');
      SnackMesage.exception("$error", context);
      // ignore: invalid_return_type_for_catch_error
      return null;
    });

    if (docRef.id.isNotEmpty) {
      final String userId = docRef.id;
      // ignore: use_build_context_synchronously
      SnackMesage.exception("Success", context);
      SharedPreferenceHelper.shared.setUserId(userId);
      SharedPreferenceHelper.shared.setLoginStatus(true);
      // ignore: use_build_context_synchronously
      Provider.of<ProviderState>(context, listen: false).setId(userId);
      // ignore: use_build_context_synchronously
      NavByMe.pushCompleteReplacement(context, const Dashboard());
      return userId;
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavBar(context),
      backgroundColor: Constant.appPrimary,
      appBar: UiAppBar(
        isBack: true,
        iconcolor: Constant.appSecondary,
        bgColor: Constant.appPrimary,
        title: Text(
          widget.isEdit ? "Edit Account" : "Create Account",
          textScaleFactor: 1,
          style: const TextStyle(
              color: Constant.appSecondary,
              fontSize: 24,
              fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Constant.appDefaultPadding * 2),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: Constant.appDefaultPadding,
                ),
                _buildProfilePicture(context),
                const SizedBox(
                  height: Constant.appDefaultPadding * 2,
                ),
                _buildFriendsDetils(),
                const SizedBox(
                  height: 80,
                ),
                _buildTextField('Username'),
                const SizedBox(
                  height: Constant.appDefaultPadding,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildTextField(String hintText) {
    return SizedBox(
      height: 50,
      child: Material(
        elevation: 5,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constant.appDefaultPadding / 2),
          borderSide: const BorderSide(color: Constant.appWhite, width: 0.15),
        ),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(Constant.appDefaultPadding * 2),
                borderSide:
                    const BorderSide(color: Constant.appWhite, width: 0.15),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(Constant.appDefaultPadding * 2),
                borderSide:
                    const BorderSide(color: Constant.appWhite, width: 0.15),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(Constant.appDefaultPadding * 2),
                borderSide:
                    const BorderSide(color: Constant.appWhite, width: 0.15),
              ),
              hintText: hintText,
              hintStyle: const TextStyle(color: Constant.appSecondary),
              filled: true,
              fillColor: Constant.appWhite,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0)),
        ),
      ),
    );
  }

  _bottomNavBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constant.appDefaultPadding * 2),
      child: UiPrimaryButton(
          backgroundColor: Constant.appSecondary,
          foregroundColor: Constant.appWhite,
          onPressed: () {
            if (validate()) {
              widget.isEdit ? updateProfile() : createUserAccount(context);
            }
          },
          text: widget.isEdit ? "Submit" : "Register"),
    );
  }

  showImgDialog(context) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UiAlertDialog(
            onGallery: (){
              getImageGallery();
            }, onCamera: (){
              getImageCamera();
            });
      },
    );
  }

  Widget _buildProfilePicture(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showImgDialog(context);
      },
      child: CircleAvatar(
        radius: 70,
        foregroundColor: Constant.appBalck,
        backgroundColor: Constant.appBlue.withAlpha(40),
        child: _image == null
            ? const Text(
                "Add \nPhoto",
                textAlign: TextAlign.center,
              )
            : CircleAvatar(
                radius: 70,
                backgroundImage: FileImage(
                  _image!,
                ),
              ),
      ),
    );
  }

  _buildFriendsDetils() {
    return const Flex(
      mainAxisAlignment: MainAxisAlignment.center,
      direction: Axis.horizontal,
      children: [
        Column(
          children: [
            Text(
              "Followings",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Constant.appSecondary),
            ),
            Text(
              "0",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Constant.appSecondary),
            )
          ],
        ),
        SizedBox(
          width: Constant.appDefaultPadding * 2,
        ),
        Column(
          children: [
            Text(
              "Followers",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Constant.appSecondary),
            ),
            Text(
              "0",
            )
          ],
        )
      ],
    );
  }
}
