import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart' as db;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:threads/helper/enum.dart';
import 'package:threads/helper/shared_prefrence_helper.dart';
import 'package:threads/helper/utility.dart';
import 'package:threads/model/user.dart';
import 'package:threads/state/appState.dart';
import '../common/locator.dart';
import 'package:path/path.dart' as path;

class AuthState extends AppStates {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  bool isSignInWithGoogle = false;
  User? user;
  late String userId;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  db.Query? _profileQuery;
  late AuthState authRepository;
  UserModel? _userModel;

  UserModel? get userModel => _userModel;

  UserModel? get profileUserModel => _userModel;

  void logoutCallback() async {
    authStatus = AuthStatus.NOT_LOGGED_IN;
    userId = '';
    _userModel = null;
    user = null;
    _profileQuery!.onValue.drain();
    _profileQuery = null;
    if (isSignInWithGoogle) {
      isSignInWithGoogle = false;
    }
    _firebaseAuth.signOut();
    notifyListeners();
    await getIt<SharedPreferenceHelper>().clearPreferenceValues();
  }

  void databaseInit() {
    try {
      if (_profileQuery == null) {
        _profileQuery = kDatabase.child("profile").child(user!.uid);
        _profileQuery!.onChildChanged.listen(_onProfileUpdated);
      }
    } catch (error) {
      print(error);
    }
  }

  Future<String?> signUp(UserModel userModel, BuildContext context,
      {required GlobalKey<ScaffoldState> scaffoldKey,
      required String password}) async {
    try {
      var result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: userModel.email!,
        password: password,
      );
      user = result.user;
      authStatus = AuthStatus.LOGGED_IN;
      kAnalytics.logSignUp(signUpMethod: 'register');
      result.user!.updateDisplayName(
        userModel.displayName,
      );
      result.user!.updatePhotoURL(userModel.profilePic);

      _userModel = userModel;
      _userModel!.key = user!.uid;
      _userModel!.userId = user!.uid;
      createUser(_userModel!, newUser: true);
      return user!.uid;
    } catch (error) {
      Utility.customSnackBar(scaffoldKey, error.toString(), context);
      return null;
    }
  }

  void createUser(UserModel user, {bool newUser = false}) {
    if (newUser) {
      user.userName =
          Utility.getUserName(id: user.userId!, name: user.displayName!);
      kAnalytics.logEvent(name: 'create_newUser');

      user.createAt = DateTime.now().toUtc().toString();
    }

    kDatabase.child('profile').child(user.userId!).set(user.toJson());
    _userModel = user;
  }

  Future<User?> getCurrentUser() async {
    try {
      user = _firebaseAuth.currentUser;
      if (user != null) {
        await getProfileUser();
        authStatus = AuthStatus.LOGGED_IN;
        userId = user!.uid;
      } else {
        authStatus = AuthStatus.NOT_LOGGED_IN;
      }
      return user;
    } catch (error) {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      return null;
    }
  }

  Future<void> updateUserProfile(UserModel? userModel,
      {File? image, File? bannerImage}) async {
    try {
      if (image == null && bannerImage == null) {
        createUser(userModel!);
      } else {
        if (image != null) {
          userModel!.profilePic = await _uploadFileToStorage(image,
              'user/profile/${userModel.userName}/${path.basename(image.path)}');
          var name = userModel.displayName ?? user!.displayName;
          _firebaseAuth.currentUser!.updateDisplayName(name);
          _firebaseAuth.currentUser!.updatePhotoURL(userModel.profilePic);
        }

        if (userModel != null) {
          createUser(userModel);
        } else {
          createUser(_userModel!);
        }
      }
    } catch (error) {
      print(error);
    }
  }

  Future<String> _uploadFileToStorage(File file, path) async {
    var task = _firebaseStorage.ref().child(path);
    var status = await task.putFile(file);
    print(status.state.name);

    return await task.getDownloadURL();
  }

  Future<UserModel?> getUserDetail(String userId) async {
    UserModel user;
    var event = await kDatabase.child('profile').child(userId).once();

    final map = event.snapshot.value as Map?;
    if (map != null) {
      user = UserModel.fromJson(map);
      user.key = event.snapshot.key!;
      return user;
    } else {
      return null;
    }
  }

  FutureOr<void> getProfileUser({String? userProfileId}) {
    try {
      userProfileId = userProfileId ?? user!.uid;
      kDatabase
          .child("profile")
          .child(userProfileId)
          .once()
          .then((DatabaseEvent event) async {
        final snapshot = event.snapshot;
        if (snapshot.value != null) {
          var map = snapshot.value as Map<dynamic, dynamic>?;
          if (map != null) {
            if (userProfileId == user!.uid) {
              _userModel = UserModel.fromJson(map);

              getIt<SharedPreferenceHelper>().saveUserProfile(_userModel!);
            }
          }
        }
      });
    } catch (error) {
      print(error);
    }
  }

  void _onProfileUpdated(DatabaseEvent event) {
    final val = event.snapshot.value;
    if (val is List &&
        ['following', 'followers'].contains(event.snapshot.key)) {
      final list = val.cast<String>().map((e) => e).toList();
      if (event.previousChildKey == 'following') {
        _userModel = _userModel!.copyWith(
          followingList: val.cast<String>().map((e) => e).toList(),
        );
      } else if (event.previousChildKey == 'followers') {
        _userModel = _userModel!.copyWith(
          followersList: list,
        );
      }
      getIt<SharedPreferenceHelper>().saveUserProfile(_userModel!);
      notifyListeners();
    }
  }
}
