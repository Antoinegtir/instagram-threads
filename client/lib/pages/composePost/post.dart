// ignore_for_file: unnecessary_null_comparison, unused_element
import 'dart:io';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:threads/model/post.module.dart';
import 'package:threads/model/user.module.dart';
import 'package:threads/pages/composePost/widget/composeBottomIconWidget.dart';
import 'package:threads/state/auth.state.dart';
import 'package:threads/state/compose.state.dart';
import 'package:threads/state/post.state.dart';
import 'package:threads/state/search.state.dart';
import 'package:threads/widget/custom/title_text.dart';

class ComposePost extends StatefulWidget {
  const ComposePost({
    Key? key,
  }) : super(key: key);

  @override
  _ComposePostReplyPageState createState() => _ComposePostReplyPageState();
}

class _ComposePostReplyPageState extends State<ComposePost> {
  late PostModel? model;
  late ScrollController scrollcontroller;
  late TextEditingController _textEditingController;
  File? _file;
  @override
  void dispose() {
    scrollcontroller.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    scrollcontroller = ScrollController();
    _textEditingController = TextEditingController();
    super.initState();
  }

  void _onImageIconSelcted(File file) {
    setState(() {
      _file = file;
    });
  }

  void _submitButton() async {
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
    if (_textEditingController.text.isEmpty) return;

    var state = Provider.of<PostState>(context, listen: false);

    PostModel postModel = await createPostModel();
    String? postId;

    if (_file != null) {
      await state.uploadFile(_file!).then((imagePath) async {
        if (imagePath != null) {
          postModel.imagePath = imagePath;
          postId = await state.createPost(postModel);
        }
      });
    } else {
      postId = await state.createPost(postModel);
    }
    postModel.key = postId;
    _textEditingController.clear();
    setState(() {
      _file = null;
    });
  }

  Widget _entry(
    BuildContext context,
    String title,
    Icon icon, {
    required TextEditingController controller,
  }) {
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
                      hintText: "Draw, Painting, 3D...",
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

  Future<PostModel> createPostModel() async {
    var authState = Provider.of<AuthState>(context, listen: false);
    var myUser = authState.userModel;
    var profilePic = myUser!.profilePic;

    var commentedUser = UserModel(
        displayName: myUser.displayName ?? myUser.email!.split('@')[0],
        profilePic: profilePic,
        userId: myUser.userId,
        userName: authState.userModel!.userName);
    PostModel reply = PostModel(
        user: commentedUser,
        bio: _textEditingController.text,
        createdAt: DateTime.now().toUtc().toString(),
        key: myUser.userId!);
    return reply;
  }

  bool select = false;
  int nums = 0;
  @override
  Widget build(BuildContext context) {
    final searchState = Provider.of<SearchState>(context, listen: false);
    var authState = Provider.of<AuthState>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 68,
        leading: Container(),
        flexibleSpace: Padding(
            padding: EdgeInsets.only(top: 76),
            child: Container(
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 29, 29, 29),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))),
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeIn(
                        duration: Duration(milliseconds: 1000),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(left: 15, top: 5),
                                child: GestureDetector(
                                    onTap: () {},
                                    child: Text("Cancel",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w400)))),
                            Container(
                              width: 65,
                            ),
                            Text(
                              "New threads   ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        )),
                  ],
                ))),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        color: Color.fromARGB(255, 29, 29, 29),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              imageUrl:
                                  authState.userModel!.profilePic.toString(),
                              height: 50,
                            )),
                        Container(
                          height: 6,
                        ),
                        Container(
                          height: 50,
                          width: 2,
                          color: const Color.fromARGB(255, 87, 87, 87),
                        ),
                        Container(
                          height: 10,
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                        )
                      ],
                    ),
                    Container(
                      width: 15,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            authState.userModel!.displayName.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 100,
                            height: MediaQuery.of(context).size.height / 3,
                            child: TextField(
                              maxLength: 500,
                              keyboardAppearance:
                                  MediaQuery.of(context).platformBrightness ==
                                          Brightness.dark
                                      ? Brightness.dark
                                      : Brightness.light,
                              style: TextStyle(color: Colors.white),
                              controller: _textEditingController,
                              onChanged: (texts) {
                                setState(() {
                                  nums = _textEditingController.text.length;
                                });
                                Provider.of<ComposePostState>(context,
                                        listen: false)
                                    .onDescriptionChanged(texts, searchState);
                              },
                              maxLines: null,
                              decoration: InputDecoration(
                                  suffix: Container(
                                    height: 70,
                                    width: 50,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        ComposeBottomIconWidget(
                                          textEditingController:
                                              _textEditingController,
                                          onImageIconSelcted:
                                              _onImageIconSelcted,
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              HapticFeedback.heavyImpact();
                                              _submitButton();
                                            },
                                            child: Text(
                                              "Post",
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontWeight: FontWeight.w600),
                                            ))
                                      ],
                                    ),
                                  ),
                                  border: InputBorder.none,
                                  hintText: "Start a threads..",
                                  hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 112, 112, 112),
                                      overflow: TextOverflow.ellipsis)),
                            ),
                          ),
                        ]),
                  ],
                )),
            Container(
                width: MediaQuery.of(context).size.width / 1,
                height: MediaQuery.of(context).size.height / 5,
                alignment: Alignment.center,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: _file == null
                    ? SizedBox.shrink()
                    : Container(
                        height: 200,
                        child: Image.file(
                          _file!,
                        ))),
          ],
        ),
      ),
    );

    //      Scaffold(
    // extendBodyBehindAppBar: true,
    // appBar: AppBar(
    //     centerTitle: true,
    //     backgroundColor: Colors.transparent,
    //     flexibleSpace: ClipRRect(
    //         child: BackdropFilter(
    //             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    //             child: Container(
    //               color: Colors.black.withOpacity(0),
    //               width: MediaQuery.of(context).size.width / 1,
    //               height: 200,
    //             )))),
    // backgroundColor: Colors.black,
    // body: GestureDetector(
    //     onHorizontalDragUpdate: (details) {
    //       if (details.delta.dx > 0) {
    //         setState(() {
    //           Navigator.pop(context);
    //         });
    //       }
    //     },
    //     child: ListView(
    //       children: [
    //         Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: <Widget>[
    //             Container(
    //                 height: 100,
    //                 alignment: Alignment.center,
    //                 child: Column(
    //                   mainAxisAlignment: MainAxisAlignment.center,
    //                   children: [
    //                     ComposeBottomIconWidget(
    //                       textEditingController: _textEditingController,
    //                       onImageIconSelcted: _onImageIconSelcted,
    //                     )
    //                   ],
    //                 )),
    //             Padding(
    //               padding: EdgeInsets.only(
    //                 left: MediaQuery.of(context).size.width / 5,
    //                 right: MediaQuery.of(context).size.width / 5,
    //               ),
    //               child: Container(
    //                   width: MediaQuery.of(context).size.width / 1,
    //                   height: MediaQuery.of(context).size.height / 4,
    //                   alignment: Alignment.center,
    //                   decoration: BoxDecoration(
    //                       borderRadius: BorderRadius.circular(10)),
    //                   child: _file == null
    //                       ? SizedBox.shrink()
    //                       : Container(
    //                           height: 200,
    //                           child: Image.file(
    //                             _file!,
    //                           ))),
    //             ),
    //             Padding(
    //                 padding: EdgeInsets.all(20),
    //                 child: Container(
    //                     padding: EdgeInsets.all(20),
    //                     decoration: BoxDecoration(
    //                         border:
    //                             Border.all(color: Colors.white, width: 1),
    //                         borderRadius: const BorderRadius.all(
    //                             Radius.circular(15))),
    //                     child: Row(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       crossAxisAlignment: CrossAxisAlignment.center,
    //                       children: <Widget>[
    //                         Column(
    //                           children: [
    //                             Padding(
    //                                 padding: EdgeInsets.all(20),
    //                                 child: Hero(
    //                                     tag: 'PP',
    //                                     child: CachedNetworkImage(
    //                                         imageUrl: authState
    //                                             .user!.photoURL
    //                                             .toString(),
    //                                         height: 40))),
    //                             nums >= 100
    //                                 ? FadeIn(
    //                                     child: Text(
    //                                     "${nums.toString()} / 280",
    //                                     style: TextStyle(
    //                                         color: nums >= 280
    //                                             ? Colors.blue
    //                                             : Colors.white),
    //                                   ))
    //                                 : SizedBox.shrink(),
    //                           ],
    //                         ),
    //                         const SizedBox(
    //                           width: 10,
    //                         ),
    //                         Expanded(
    //                           child: Column(
    //                               crossAxisAlignment:
    //                                   CrossAxisAlignment.start,
    //                               children: <Widget>[
    //                                 TextField(
    //                                   maxLength: 280,
    //                                   keyboardAppearance:
    //                                       MediaQuery.of(context)
    //                                                   .platformBrightness ==
    //                                               Brightness.dark
    //                                           ? Brightness.dark
    //                                           : Brightness.light,
    //                                   style: TextStyle(color: Colors.white),
    //                                   controller: _textEditingController,
    //                                   onChanged: (texts) {
    //                                     setState(() {
    //                                       nums = _textEditingController
    //                                           .text.length;
    //                                     });
    //                                     Provider.of<ComposePostState>(
    //                                             context,
    //                                             listen: false)
    //                                         .onDescriptionChanged(
    //                                             texts, searchState);
    //                                   },
    //                                   maxLines: null,
    //                                   decoration: InputDecoration(
    //                                       border: InputBorder.none,
    //                                       hintText:
    //                                           "Info about you're art..",
    //                                       hintStyle: TextStyle(
    //                                           fontSize: 18,
    //                                           color: Colors.white,
    //                                           overflow:
    //                                               TextOverflow.ellipsis)),
    //                                 ),
    //                               ]),
    //                         )
    //                       ],
    //                     ))),
    //             RippleButton(
    //               splashColor: Colors.transparent,
    //               child: Container(
    //                   height: 70,
    //                   width: 200,
    //                   decoration: BoxDecoration(
    //                     color: Colors.white,
    //                     borderRadius: BorderRadius.circular(50),
    //                   ),
    //                   child: Center(
    //                       child: Text(
    //                     "Upload",
    //                     style: TextStyle(
    //                         fontFamily: "icons.ttf",
    //                         color: Colors.black,
    //                         fontSize: 35,
    //                         fontWeight: FontWeight.w900),
    //                   ))),
    //               onPressed: () {
    //                 HapticFeedback.heavyImpact();
    //                 _submitButton();
    //               },
    //             ),
    //             Container(
    //               height: 100,
    //             )
    //           ],
    //         ),
    //       ],
    //     )));
  }
}

class _UserList extends StatelessWidget {
  const _UserList({Key? key, this.list, required this.textEditingController})
      : super(key: key);
  final List<UserModel>? list;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
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
