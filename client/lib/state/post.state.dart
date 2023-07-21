import 'dart:async';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/firebase_database.dart' as dabase;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:threads/helper/utility.dart';
import 'package:threads/model/user.module.dart';
import 'package:threads/state/app.state.dart';
import '../model/post.module.dart';
import 'package:path/path.dart' as path;

class PostState extends AppStates {
  bool isBusy = false;
  Map<String, List<PostModel>?> postReplyMap = {};
  PostModel? _postToReplyModel;
  PostModel? get postToReplyModel => _postToReplyModel;
  set setPostToReply(PostModel model) {
    _postToReplyModel = model;
  }

  List<PostModel>? _feedlist;
  dabase.Query? _feedQuery;
  List<PostModel>? _postDetailModelList;

  List<PostModel>? get postDetailModel => _postDetailModelList;

  List<PostModel>? get feedlist {
    if (_feedlist == null) {
      return null;
    } else {
      return List.from(_feedlist!.reversed);
    }
  }

  Future<String?> createPost(PostModel model) async {
    ///  Create post in [Firebase kDatabase]
    isBusy = true;
    notifyListeners();
    String? postKey;
    try {
      DatabaseReference dbReference = kDatabase.child('post').push();

      await dbReference.set(model.toJson());

      postKey = dbReference.key;
    } catch (error) {
      print(error);
    }
    isBusy = false;
    notifyListeners();
    return postKey;
  }

  Future<String?> uploadFile(File file) async {
    try {
      isBusy = true;
      notifyListeners();
      var storageReference = FirebaseStorage.instance
          .ref()
          .child("threadsImage")
          .child(path.basename(DateTime.now().toIso8601String() + file.path));
      await storageReference.putFile(file);

      var url = await storageReference.getDownloadURL();
      return url;
    } catch (error) {
      print(error);
      return null;
    }
  }

  List<PostModel>? getPostList(UserModel? userModel) {
    final now = DateTime.now();

    if (userModel == null) {
      return null;
    }
    List<PostModel>? list;
    if (!isBusy && feedlist != null && feedlist!.isNotEmpty) {
      list = feedlist!.where((x) {
        if ((x.user!.userId == userModel.userId ||
                (userModel.followingList != null &&
                    userModel.followingList!.contains(x.user!.userId))) &&
            now.difference(DateTime.parse(x.createdAt)).inHours < 24) {
          return true;
        } else {
          return false;
        }
      }).toList();
      if (list.isEmpty) {
        list = null;
      }
    }
    return list;
  }

  List<PostModel>? getPostLists(UserModel? userModel) {
    if (userModel == null) {
      return null;
    }

    List<PostModel>? list;

    if (!isBusy && feedlist != null && feedlist!.isNotEmpty) {
      list = feedlist!.where((x) {
        return true;
      }).toList();
      if (list.isEmpty) {
        list = null;
      }
    }
    return list;
  }

  set setFeedModel(PostModel model) {
    _postDetailModelList ??= [];

    _postDetailModelList!.add(model);
    notifyListeners();
  }

  Future<bool> databaseInit() {
    try {
      if (_feedQuery == null) {
        _feedQuery = kDatabase.child("posts");
        _feedQuery!.onChildAdded.listen(onPostAdded);
      }
      return Future.value(true);
    } catch (error) {
      return Future.value(false);
    }
  }

  void getDataFromDatabase() {
    try {
      isBusy = true;
      _feedlist = null;
      notifyListeners();
      kDatabase.child('posts').once().then((DatabaseEvent event) {
        final snapshot = event.snapshot;
        _feedlist = <PostModel>[];
        if (snapshot.value != null) {
          var map = snapshot.value as Map<dynamic, dynamic>?;
          if (map != null) {
            map.forEach((key, value) {
              var model = PostModel.fromJson(value);
              model.key = key;
              _feedlist!.add(model);
            });
            _feedlist!.sort((x, y) => DateTime.parse(x.createdAt)
                .compareTo(DateTime.parse(y.createdAt)));
          }
        } else {
          _feedlist = null;
        }
        isBusy = false;
        notifyListeners();
      });
    } catch (error) {
      isBusy = false;
    }
  }

  onPostAdded(DatabaseEvent event) {
    PostModel post = PostModel.fromJson(event.snapshot.value as Map);
    post.key = event.snapshot.key!;

    post.key = event.snapshot.key!;
    _feedlist ??= <PostModel>[];
    if ((_feedlist!.isEmpty || _feedlist!.any((x) => x.key != post.key))) {
      _feedlist!.add(post);
    }
    isBusy = false;
    notifyListeners();
  }
}
