// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'dart:ui';
import 'package:animate_do/animate_do.dart';
import 'package:awesome_icons/awesome_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:threads/model/post.module.dart';
import 'package:threads/model/user.module.dart';
import 'package:threads/state/auth.state.dart';
import 'package:threads/state/compose.state.dart';
import 'package:threads/state/post.state.dart';
import 'package:threads/state/search.state.dart';
import 'package:threads/widget/custom/rippleButton.dart';
import 'package:threads/widget/custom/title_text.dart';

class Bio extends StatefulWidget {
  const Bio(
      {Key? key,
      required this.file,
      this.isPost = true,
      required this.isRepost})
      : super(key: key);

  final bool isPost;
  final File file;
  final bool isRepost;
  @override
  _ComposePostReplyPageState createState() => _ComposePostReplyPageState();
}

class _ComposePostReplyPageState extends State<Bio> {
  late PostModel? model;
  late ScrollController scrollcontroller;
  late TextEditingController _textEditingController;
  late TextEditingController _youtubeUrl;
  late TextEditingController _tag;
  late TextEditingController _modelUrl;

  @override
  void dispose() {
    scrollcontroller.dispose();
    _textEditingController.dispose();
    _youtubeUrl.dispose();
    _tag.dispose();
    _modelUrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    var feedState = Provider.of<PostState>(context, listen: false);
    model = feedState.postToReplyModel;
    scrollcontroller = ScrollController();
    _textEditingController = TextEditingController();
    _youtubeUrl = TextEditingController();
    _tag = TextEditingController();
    _modelUrl = TextEditingController();
    super.initState();
  }

  String sofware = "";
  String tagss = "";

  RegExp youtubeUrlPattern = RegExp(
      r"^(https?://)?(www\.)?(youtube\.com|youtu\.be)\/(watch\?v=)?([\w-]+)");

  RegExp modelPattern = RegExp(r'^https://.*\.(glb|gtlf)$');

  /// Submit post to save in firebase database
  void _submitButton() async {
    if (!youtubeUrlPattern.hasMatch(_youtubeUrl.text) &&
            _youtubeUrl.text != "" ||
        !modelPattern.hasMatch(_modelUrl.text) && _modelUrl.text != "") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))),
        backgroundColor: Colors.white,
        content: Container(
            alignment: Alignment.center,
            height: 30,
            child: Text(
              'Oups,url not good 0_o',
              style: TextStyle(
                  fontFamily: "icons.ttf",
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w900),
            )),
      ));
      return;
    }
    if (_textEditingController.text.length > 280) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))),
        backgroundColor: Colors.white,
        content: Container(
            alignment: Alignment.center,
            height: 30,
            child: Text(
              "Max Description: 280",
              style: TextStyle(
                  fontFamily: "icons.ttf",
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w900),
            )),
      ));
      return;
    }

    Navigator.pop(context);
    var state = Provider.of<PostState>(context, listen: false);

    PostModel postModel = await createPostModel();
    String? postId;

    if (widget.file != null) {
      await state.uploadFile(widget.file).then((imagePath) async {
        if (imagePath != null) {
          postModel.imagePath = imagePath;
          if (widget.isPost) {
            postId = await state.createPost(postModel);
          }
        }
      });
    } else {
      if (widget.isPost) {
        postId = await state.createPost(postModel);
      }
    }
    postModel.key = postId;
  }

  Widget _entry(BuildContext context, String title, Icon icon,
      {required TextEditingController controller,
      bool isenable = true,
      bool test = true}) {
    return Container(
      margin: const EdgeInsets.only(top: 10, right: 10, left: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              title,
              style: TextStyle(
                  fontFamily: "icons.ttf",
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
            ),
          ),
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                  width: MediaQuery.of(context).size.width / 1.12,
                  height: 30,
                  color: Colors.black,
                  child: TextField(
                    keyboardAppearance: Brightness.dark,
                    style: TextStyle(
                        fontFamily: "icons.ttf",
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                    controller: controller,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                          fontFamily: "icons.ttf",
                          color: Color.fromARGB(255, 149, 149, 149),
                          fontSize: 15,
                          fontWeight: FontWeight.w400),
                      hintText: !test
                          ? "Draw, Painting, 3D..."
                          : isenable
                              ? "https://path/to/file.glb"
                              : "https://youtu.be/",
                      prefixIcon: icon,
                      contentPadding: EdgeInsets.only(left: 10),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 0),
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 0),
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                    ),
                  )))
        ],
      ),
    );
  }

  bool more = false;

  /// Return Post model which is either a new Post , repost model or comment model
  /// If post is new post then `parentkey` and `childRetwetkey` should be null
  /// IF post is a comment then it should have `parentkey`
  /// IF post is a repost then it should have `childRetwetkey`
  Future<PostModel> createPostModel() async {
    var authState = Provider.of<AuthState>(context, listen: false);
    var myUser = authState.userModel;
    var profilePic = myUser!.profilePic;

    /// User who are creting reply post
    var commentedUser = UserModel(
        displayName: myUser.displayName ?? myUser.email!.split('@')[0],
        profilePic: profilePic,
        userId: myUser.userId,
        userName: authState.userModel!.userName);
    PostModel reply = PostModel(
        user: commentedUser,
        createdAt: DateTime.now().toUtc().toString(),
        key: myUser.userId!);
    return reply;
  }

  bool select = false;
  int nums = 0;
  @override
  Widget build(BuildContext context) {
    final searchState = Provider.of<SearchState>(context, listen: false);
    List<String> words = tagss.split(" ");
    List<String> wordss = sofware.split(" ");
    var authState = Provider.of<AuthState>(context);
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: ClipRRect(
                child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      color: Colors.black.withOpacity(0),
                      width: MediaQuery.of(context).size.width / 1,
                      height: 200,
                    )))),
        backgroundColor: Colors.black,
        body: GestureDetector(
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx > 0) {
                setState(() {
                  Navigator.pop(context);
                });
              }
            },
            child: ListView(
              children: [
                Container(
                  height: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.all(20),
                        child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 1),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(15))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.all(20),
                                        child: Hero(
                                            tag: 'PP',
                                            child: CachedNetworkImage(
                                                imageUrl: authState
                                                    .user!.photoURL
                                                    .toString(),
                                                height: 40))),
                                    nums >= 100
                                        ? FadeIn(
                                            child: Text(
                                            "${nums.toString()} / 280",
                                            style: TextStyle(
                                                color: nums >= 280
                                                    ? Colors.blue
                                                    : Colors.white),
                                          ))
                                        : SizedBox.shrink(),
                                  ],
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        TextField(
                                          maxLength: 280,
                                          keyboardAppearance:
                                              MediaQuery.of(context)
                                                          .platformBrightness ==
                                                      Brightness.dark
                                                  ? Brightness.dark
                                                  : Brightness.light,
                                          style: TextStyle(color: Colors.white),
                                          controller: _textEditingController,
                                          onChanged: (texts) {
                                            setState(() {
                                              nums = _textEditingController
                                                  .text.length;
                                            });
                                            Provider.of<ComposePostState>(
                                                    context,
                                                    listen: false)
                                                .onDescriptionChanged(
                                                    texts, searchState);
                                          },
                                          maxLines: null,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText:
                                                  "Info about you're art..",
                                              hintStyle: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  overflow:
                                                      TextOverflow.ellipsis)),
                                        ),
                                      ]),
                                )
                              ],
                            ))),
                    Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.only(left: 23),
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    more == true ? more = false : more = true;
                                  });
                                },
                                child: FadeIn(
                                    child: Text(
                                  more ? "Show less.." : "Show more..",
                                  style: TextStyle(color: Colors.blue),
                                )))),
                      ],
                    ),
                    Visibility(
                        visible: more,
                        child: FadeInDown(
                            child: _entry(
                                context,
                                'Video Url Demo',
                                Icon(
                                  FontAwesomeIcons.youtube,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                                controller: _youtubeUrl,
                                isenable: false))),
                    Visibility(
                        visible: more,
                        child: FadeInDown(
                            child: _entry(context, '3D Model View',
                                Icon(Iconsax.d_rotate, color: Colors.white),
                                controller: _modelUrl))),
                    Visibility(
                        visible: more,
                        child: FadeInDown(
                          child: Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 23, bottom: 10),
                                          child: Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Container(
                                                width: 5,
                                              ),
                                              Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1.5,
                                                  height: 25,
                                                  child: ListView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    children: [
                                                      for (String word
                                                          in wordss)
                                                        if (word != 'null' &&
                                                            word != " ")
                                                          Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                left: 5,
                                                              ),
                                                              child: Container(
                                                                height: 25,
                                                                width:
                                                                    word.length *
                                                                        9,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  shape: BoxShape
                                                                      .rectangle,
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .white,
                                                                      width: 1),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                      word.contains(
                                                                              ",")
                                                                          ? word.replaceAll(
                                                                              ",",
                                                                              "")
                                                                          : word,
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                                ),
                                                              )),
                                                    ],
                                                  )),
                                            ],
                                          )),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 23, bottom: 10),
                                          child: Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1.5,
                                                  height: 25,
                                                  child: ListView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    children: [
                                                      for (String word in words)
                                                        if (word != 'null' &&
                                                            word != " ")
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 5),
                                                              child: Container(
                                                                height: 25,
                                                                width:
                                                                    word.length *
                                                                        9,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5),
                                                                  shape: BoxShape
                                                                      .rectangle,
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .white,
                                                                      width: 1),
                                                                ),
                                                                child: Center(
                                                                  child: Text(
                                                                      word.contains(
                                                                              ",")
                                                                          ? word.replaceAll(
                                                                              ",",
                                                                              "")
                                                                          : word,
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white)),
                                                                ),
                                                              )),
                                                    ],
                                                  )),
                                            ],
                                          )),
                                    ],
                                  )
                                ],
                              )),
                        )),
                    Container(
                      height: 50,
                    ),
                    RippleButton(
                      splashColor: Colors.transparent,
                      child: Container(
                          height: 70,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                              child: Text(
                            "Upload",
                            style: TextStyle(
                                fontFamily: "icons.ttf",
                                color: Colors.black,
                                fontSize: 35,
                                fontWeight: FontWeight.w900),
                          ))),
                      onPressed: () {
                        HapticFeedback.heavyImpact();
                        _submitButton();
                      },
                    ),
                    Container(
                      height: 100,
                    )
                  ],
                ),
              ],
            )));
  }
}

class _UserList extends StatelessWidget {
  const _UserList({Key? key, this.list, required this.textEditingController})
      : super(key: key);
  final List<UserModel>? list;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    final searchState = Provider.of<SearchState>(context, listen: false);
    return !Provider.of<ComposePostState>(context).displayUserList ||
            list == null ||
            list!.length < 0 ||
            list!.isEmpty
        ? const SizedBox.shrink()
        : Container(
            padding: const EdgeInsetsDirectional.only(bottom: 50),
            color: Colors.black,
            constraints:
                const BoxConstraints(minHeight: 30, maxHeight: double.infinity),
            child: ListView.builder(
              itemCount: list!.length,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                return _UserTile(
                  user: list![index],
                  onUserSelected: (user) {
                    textEditingController.text =
                        Provider.of<ComposePostState>(context, listen: false)
                                .getDescription(user.userName!) +
                            " ";
                    textEditingController.selection = TextSelection.collapsed(
                        offset: textEditingController.text.length);
                    Provider.of<ComposePostState>(context, listen: false)
                        .onUserSelected();
                  },
                );
              },
            ),
          );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({Key? key, required this.user, required this.onUserSelected})
      : super(key: key);
  final UserModel user;
  final ValueChanged<UserModel> onUserSelected;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onUserSelected(user);
      },
      leading: CachedNetworkImage(imageUrl: user.profilePic!, height: 35),
      title: Row(
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: 0, maxWidth: 105),
            child: TitleText(user.displayName!,
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
      subtitle: TitleText(user.userName!,
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w500,
          overflow: TextOverflow.ellipsis),
    );
  }
}
