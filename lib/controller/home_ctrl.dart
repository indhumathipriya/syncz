import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncz/controller/state_update.dart';
import 'package:syncz/model/friends_model.dart';
import '../model/post_model.dart';

class HomeCtrl extends ProviderState {
  //initialization
  bool isFollowing = false;

  late String decoImage = "";
  late Uint8List bytesImage;

  //updateFriends
  Future<void> forUpdateFriends(bool isFollowing) async {
    var firebaseUser = FirebaseAuth.instance.currentUser;
    final addFriends = FriendsModel(
        userId: firebaseUser!.uid, isFollowing: isFollowing, isFollower: false);
    await FirebaseFirestore.instance
        .collection('friends')
        .doc(firebaseUser.uid)
        .update(addFriends.toJson());
  }

//allPost
  Stream<List<PostModel>> allPost() {
    return FirebaseFirestore.instance.collection('post').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((e) => PostModel.fromSnapshot(e)).toList());
  }

  //updatePost

  Future<void> forUpdatePost(PostModel post) async {
    await FirebaseFirestore.instance
        .collection('post')
        .doc(post.userId)
        .update(post.toJson());
  }

//updating POst
  updatePost(HomeCtrl homeCtrl, PostModel postData) {
    final post = PostModel(
        userId: postData.userId,
        imageSrc: postData.imageSrc,
        like: postData.like,
        caption: postData.caption,
        userName: postData.userName,
        comment: postData.comment);
    forUpdatePost(post);
    notifyListeners();
  }
}
