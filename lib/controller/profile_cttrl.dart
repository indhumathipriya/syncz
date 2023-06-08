import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncz/model/user_model.dart';
import '../model/post_model.dart';

class ProfileCtrl extends ChangeNotifier {
  //initialization

  String decoImage = "";
  late String profileImage;
  late String name;
  late Uint8List bytesImage;
  List localList = [];

//getImage
  Future<UserModel> getImage() async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      String displayName = firebaseUser.displayName ?? '';
      debugPrint('firebaseUser: $displayName');
      final snapshot = await FirebaseFirestore.instance
          .collection('usertable')
          .where('username', isEqualTo: displayName)
          .get();
      final result = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;

      return result;
    } else {
      throw Exception('User not authenticated');
    }
  }

//get All Post by currentUser
  Future<List<PostModel>> allPost(BuildContext context) async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      String displayName = firebaseUser.displayName ?? '';
      debugPrint('firebaseUser: $displayName');
      final snapshot = await FirebaseFirestore.instance
          .collection('post')
          .where('username', isEqualTo: displayName)
          .get();
      final result =
          snapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList();

      return result;
    } else {
      throw Exception('User not authenticated');
    }
  }

//update post
  Future<void> forUpdatePost(PostModel post) async {
    await FirebaseFirestore.instance
        .collection('post')
        .doc(post.userId)
        .update(post.toJson());
  }

//updating post
  void updatePost(ProfileCtrl profileCtrl, PostModel postData) {
    final post = PostModel(
      userId: postData.userId,
      imageSrc: postData.imageSrc,
      like: postData.like,
      caption: postData.caption,
      comment: postData.comment,
      userName: postData.userName,
    );
    forUpdatePost(post);
    notifyListeners();
  }
}
