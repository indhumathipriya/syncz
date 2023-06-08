import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String imageSrc;
  final String name;

  UserModel({required this.id, required this.imageSrc, required this.name});

  toJson() {
    return {
      'imageSrc': imageSrc,
      'name': name,
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return UserModel(
        id: data!['id'] ?? "",
        imageSrc: data['imageSrc'] ?? "",
        name: data['username'] ?? "Username");
  }
}
