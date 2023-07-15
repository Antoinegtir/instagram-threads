// ignore_for_file: avoid_print

import 'package:flutter/src/widgets/basic.dart';
import 'package:threads/model/user.module.dart';

class PostModel {
  String? key;
  String? imageFrontPath;
  String? imageBackPath;
  String? bio;
  late String createdAt;
  UserModel? user;
  List<String?>? comment;

  PostModel({
    this.key,
    required this.createdAt,
    this.imageFrontPath,
    this.bio,
    this.imageBackPath,
    this.user,
  });

  toJson() {
    return {
      "createdAt": createdAt,
      "bio": bio,
      "imageBackPath": imageBackPath,
      "imageFrontPath": imageFrontPath,
      "user": user == null ? null : user!.toJson(),
    };
  }

  PostModel.fromJson(Map<dynamic, dynamic> map) {
    key = map['key'];
    bio = map['bio'];
    imageBackPath = map['imageBackPath'];
    createdAt = map['createdAt'];
    imageFrontPath = map['imageFrontPath'];
    user = UserModel.fromJson(map['user']);
  }

  map(Stack Function(dynamic model) param0) {}
}
