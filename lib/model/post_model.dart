import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String userId;
  final String imageSrc;
  final bool like;
  final String caption;
  final String comment;
  final String userName;

  PostModel({
    required this.userId,
    required this.imageSrc,
    required this.like,
    required this.caption,
    required this.comment,
    required this.userName,
  });

  toJson() {
    return {
      'userid': userId,
      'imageSrc': imageSrc,
      'like': like,
      'caption': caption,
      'comment': comment,
      'userName': userName,
    };
  }

  factory PostModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return PostModel(
        userId: data!['userid'] ?? "",
        imageSrc: data['imageSrc'] ?? "",
        caption: data['caption'] ?? "No Caption",
        comment: data['comment'] ?? "Always Good",
        userName: data['username'] ?? "Username",
        like: data['like'] ?? false);
  }
}
