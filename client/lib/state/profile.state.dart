import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart' as dabase;
import 'package:flutter/foundation.dart';
import 'package:threads/helper/enum.dart';
import 'package:threads/helper/utility.dart';
import 'package:threads/model/user.module.dart';

class ProfileState extends ChangeNotifier {
  ProfileState(this.profileId) {
    databaseInit();
    userId = FirebaseAuth.instance.currentUser!.uid;
    _getloggedInUserProfile(userId);
    _getProfileUser(profileId);
  }

  late String userId;

  late UserModel _userModel;
  UserModel get userModel => _userModel;

  dabase.Query? _profileQuery;
  late StreamSubscription<DatabaseEvent> profileSubscription;

  final String profileId;

  late UserModel _profileUserModel;
  UserModel get profileUserModel => _profileUserModel;

  bool _isBusy = true;
  bool get isbusy => _isBusy;
  set loading(bool value) {
    _isBusy = value;
    notifyListeners();
  }

  databaseInit() {
    try {
      if (_profileQuery == null) {
        _profileQuery = kDatabase.child("profile").child(profileId);
        profileSubscription = _profileQuery!.onValue.listen(_onProfileChanged);
      }
    } catch (error) {}
  }

  bool get isMyProfile => profileId == userId;

  void _getloggedInUserProfile(String userId) async {
    kDatabase.child("profile").child(userId).once().then((DatabaseEvent event) {
      final snapshot = event.snapshot;
      if (snapshot.value != null) {
        var map = snapshot.value as Map<dynamic, dynamic>?;
        if (map != null) {
          _userModel = UserModel.fromJson(map);
        }
      }
    });
  }

  void _getProfileUser(String? userProfileId) {
    assert(userProfileId != null);
    try {
      loading = true;
      kDatabase
          .child("profile")
          .child(userProfileId!)
          .once()
          .then((DatabaseEvent event) {
        final snapshot = event.snapshot;
        if (snapshot.value != null) {
          var map = snapshot.value as Map;
          _profileUserModel = UserModel.fromJson(map);
        }
        loading = false;
      });
    } catch (error) {
      loading = false;
    }
  }

  followUser({bool removeFollower = false}) {
    try {
      if (removeFollower) {
        profileUserModel.followersList!.remove(userModel.userId);
        userModel.followingList!.remove(profileUserModel.userId);
      } else {
        profileUserModel.followersList ??= [];
        profileUserModel.followersList!.add(userModel.userId!);
        userModel.followingList ??= [];
        addFollowNotification();
        userModel.followingList!.add(profileUserModel.userId!);
      }
      kDatabase
          .child('profile')
          .child(profileUserModel.userId!)
          .child('followerList')
          .set({"key:": userModel.followingList, "accept": false});
      kDatabase
          .child('profile')
          .child(userModel.userId!)
          .child('followingList')
          .set({userModel.followingList, false});

      notifyListeners();
    } catch (error) {}
  }

  void addFollowNotification() {
    kDatabase.child('notification').child(profileId).child(userId).set({
      'type': NotificationType.Follow.toString(),
      'createdAt': DateTime.now().toUtc().toString(),
      'data': UserModel(
              displayName: userModel.displayName,
              profilePic: userModel.profilePic,
              userId: userModel.userId,
              bio: userModel.bio == "Edit profile to update bio"
                  ? ""
                  : userModel.bio,
              userName: userModel.userName)
          .toJson()
    });
  }

  void _onProfileChanged(DatabaseEvent event) {
    final updatedUser = UserModel.fromJson(event.snapshot.value as Map);
    if (updatedUser.userId == profileId) {
      _profileUserModel = updatedUser;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _profileQuery!.onValue.drain();
    profileSubscription.cancel();
    super.dispose();
  }
}
