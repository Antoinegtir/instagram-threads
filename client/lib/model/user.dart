import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class UserModel extends Equatable {
  String? key;
  String? email;
  String? userId;
  String? bio;
  String? link;
  String? userName;
  String? displayName;
  String? profilePic;
  String? createAt;
  String? fcmToken;
  List<String>? followersList;
  List<String>? followingList;

  UserModel(
      {this.email,
      this.key,
      this.userName,
      this.link,
      this.bio,
      this.userId,
      this.displayName,
      this.profilePic,
      this.createAt,
      this.followingList,
      this.followersList,
      this.fcmToken});

  UserModel.fromJson(Map<dynamic, dynamic>? map) {
    if (map == null) {
      return;
    }
    followersList ??= [];
    email = map['email'];
    userId = map['userId'];
    userName = map['userName'];
    displayName = map['displayName'];
    link = map['link'];
    bio = map['bio'];
    profilePic = map['profilePic'];
    key = map['key'];
    createAt = map['createAt'];
    fcmToken = map['fcmToken'];
    if (map['followerList'] != null) {
      followersList = <String>[];
      map['followerList'].forEach((value) {
        followersList!.add(value);
      });
    }
    if (map['followingList'] != null) {
      followingList = <String>[];
      map['followingList'].forEach((value) {
        followingList!.add(value);
      });
    }
  }
  toJson() {
    return {
      'key': key,
      "userId": userId,
      "userName": userName,
      "bio": bio,
      "link": link,
      "email": email,
      'displayName': displayName,
      'createAt': createAt,
      'profilePic': profilePic,
      'fcmToken': fcmToken,
      'followerList': followersList,
      'followingList': followingList
    };
  }

  UserModel copyWith({
    String? email,
    String? userId,
    String? userName,
    String? displayName,
    String? profilePic,
    String? createAt,
    String? bio,
    String? link,
    String? key,
    String? fcmToken,
    List<String>? followingList,
    List<String>? followersList,
  }) {
    return UserModel(
      email: email ?? this.email,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      displayName: displayName ?? this.displayName,
      profilePic: profilePic ?? this.profilePic,
      createAt: createAt ?? this.createAt,
      bio: bio ?? this.bio,
      link: link ?? this.link,
      key: key ?? this.key,
      fcmToken: fcmToken ?? this.fcmToken,
      followersList: followersList ?? this.followersList,
      followingList: followingList ?? this.followingList,
    );
  }

  @override
  List<Object?> get props => [
        key,
        email,
        bio,
        link,
        userName,
        userId,
        createAt,
        displayName,
        fcmToken,
        profilePic,
        followersList,
        followingList
      ];
}
