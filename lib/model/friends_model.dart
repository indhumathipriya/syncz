import 'package:cloud_firestore/cloud_firestore.dart';

class FriendsModel {
  final String userId;
  final bool? isFollowing;
  final bool? isFollower;

  FriendsModel({
    required this.userId,
     this.isFollowing,
     this.isFollower,
  });

  toJson() {
    return {
      'userid': userId,
      'followingId': isFollowing,
      'followerId': isFollower,
    };
  }

  factory FriendsModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return FriendsModel(
        userId: data!['userid'] ?? "",
        isFollowing: data['followingId'] ?? false,
        isFollower: data['followerId'] ?? false);
  }
}
