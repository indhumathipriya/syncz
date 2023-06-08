import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:syncz/controller/state_update.dart';
import 'package:syncz/model/friends_model.dart';
import 'package:syncz/model/user_model.dart';

class FriendsCtrl extends ProviderState {
  //initialization
  bool isFollowing = false;
  var firebaseUser = FirebaseAuth.instance.currentUser;
  late String decoImage = "";
  late Uint8List bytesImage;

  @override
  String? id;

  //updateFollowing Method
  Future<void> forUpdateFollowing(bool isFollowing) async {
    if (firebaseUser != null) {
      id = firebaseUser!.uid;
    } else {
      id = ProviderState().id;
    }
    final addFriends = FriendsModel(
      userId: id ?? "",
      isFollowing: isFollowing,
    );
    await FirebaseFirestore.instance
        .collection('friends')
        .doc(firebaseUser!.uid)
        .update(addFriends.toJson());
  }

//updateFollower Method
  Future<void> forUpdateFollower(bool isFollower) async {
    if (firebaseUser != null) {
      id = firebaseUser!.uid;
    } else {
      id = ProviderState().id;
    }
    final addFriends = FriendsModel(userId: id ?? "", isFollower: isFollower);
    await FirebaseFirestore.instance
        .collection('friends')
        .doc(firebaseUser!.uid)
        .update(addFriends.toJson());
  }

  
//Reteriving All Post
  Stream<List<UserModel>> allPost() {
    return FirebaseFirestore.instance.collection('friends').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList());
  }
}
