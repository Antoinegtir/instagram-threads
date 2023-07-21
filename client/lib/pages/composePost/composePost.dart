import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:threads/animation/animation.dart';
import 'package:threads/model/post.module.dart';
import 'package:threads/pages/composePost/preview.dart';
import 'package:threads/pages/composePost/widget/composeBottomIconWidget.dart';
import 'package:threads/state/post.state.dart';
import 'package:threads/widget/custom/rippleButton.dart';
import 'widget/bio.dart';
import 'widget/composePostsImage.dart';

class ComposePostPage extends StatefulWidget {
  const ComposePostPage({
    Key? key,
  }) : super(key: key);

  @override
  _ComposePostReplyPageState createState() => _ComposePostReplyPageState();
}

class _ComposePostReplyPageState extends State<ComposePostPage> {
  late PostModel? model;
  late ScrollController scrollcontroller;

  File? _image;
  late TextEditingController _textEditingController;
  @override
  void dispose() {
    scrollcontroller.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    var feedState = Provider.of<PostState>(context, listen: false);
    model = feedState.postToReplyModel;
    scrollcontroller = ScrollController();
    _textEditingController = TextEditingController();
    super.initState();
  }

  void _onCrossIconPressed() {
    setState(() {
      _image = null;
    });
  }

  void _onImageIconSelcted(File file) {
    setState(() {
      _image = file;
    });
  }

  bool select = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  height: MediaQuery.of(context).size.height / 3,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ComposeBottomIconWidget(
                        textEditingController: _textEditingController,
                        onImageIconSelcted: _onImageIconSelcted,
                      )
                    ],
                  )),
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width / 5,
                    right: MediaQuery.of(context).size.width / 5,
                    bottom: 60.0),
                child: Container(
                    width: MediaQuery.of(context).size.width / 1,
                    height: MediaQuery.of(context).size.height / 4,
                    alignment: Alignment.center,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: _image == null
                        ? SizedBox.shrink()
                        : GestureDetector(
                            onTap: (() {
                              Navigator.push(
                                context,
                                AwesomePageRoute(
                                  transitionDuration:
                                      Duration(milliseconds: 600),
                                  exitPage: widget,
                                  enterPage:
                                      Preview(file: _image, isRepost: true),
                                  transition: ZoomOutSlideTransition(),
                                ),
                              );
                            }),
                            child: Container(
                                height: 200,
                                child: ComposePostImage(
                                  image: _image,
                                  onCrossIconPressed: _onCrossIconPressed,
                                )))),
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
                      "Next",
                      style: TextStyle(
                          fontFamily: "icons.ttf",
                          color: Colors.black,
                          fontSize: 35,
                          fontWeight: FontWeight.w900),
                    ))),
                onPressed: () {
                  HapticFeedback.heavyImpact();
                  Navigator.push(
                    context,
                    AwesomePageRoute(
                      transitionDuration: Duration(milliseconds: 600),
                      exitPage: widget,
                      enterPage: Bio(isRepost: false, file: _image!),
                      transition: ZoomOutSlideTransition(),
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
