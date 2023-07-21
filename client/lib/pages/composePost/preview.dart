import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threads/model/post.module.dart';
import 'package:threads/state/post.state.dart';

class Preview extends StatefulWidget {
  const Preview(
      {Key? key,
      required this.file,
      required this.isRepost,
      this.isPost = true})
      : super(key: key);

  final bool isRepost;
  final bool isPost;
  final File? file;
  @override
  _ComposePostReplyPageState createState() => _ComposePostReplyPageState();
}

class _ComposePostReplyPageState extends State<Preview> {
  late PostModel? model;
  late ScrollController scrollcontroller;
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

  bool select = false;
  @override
  Widget build(BuildContext context) {
    final darkmode =
        MediaQuery.of(context).platformBrightness == Brightness.light
            ? Colors.white
            : Colors.black;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text("Preview"),
          backgroundColor: Colors.black,
        ),
        backgroundColor: darkmode,
        body: GestureDetector(
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx > 0) {
                setState(() {
                  Navigator.pop(context);
                });
              }
            },
            child: Container(
              height: MediaQuery.of(context).size.height / 1,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: FileImage(widget.file!), fit: BoxFit.contain),
              ),
            )));
  }
}
