import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:threads/model/post.module.dart';

// ignore: must_be_immutable
class FeedPostWidget extends StatefulWidget {
  PostModel postModel;
  FeedPostWidget({required this.postModel, super.key});

  @override
  State<FeedPostWidget> createState() => _FeedPostWidgetState();
}

class _FeedPostWidgetState extends State<FeedPostWidget> {
  bool switcher = false;
  void switcherFunc() {
    setState(() {
      switcher = !switcher;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        height: MediaQuery.of(context).size.height / 1.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                        height: 35,
                        width: 35,
                        child: CachedNetworkImage(
                          imageUrl:
                              widget.postModel.user!.profilePic.toString(),
                        ))),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: widget.postModel.user!.displayName.toString() +
                            "\n",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      TextSpan(
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 3,
                ),
                Icon(Icons.more_horiz, color: Colors.white)
              ],
            ),
            Container(
              height: 10,
            ),
            GestureDetector(
                onTap: switcherFunc,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                        height: MediaQuery.of(context).size.height / 1.63,
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          children: [
                            FittedBox(
                                fit: BoxFit.cover,
                                child: SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height /
                                        1.63,
                                    child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        imageUrl: switcher
                                            ? widget.postModel.imageFrontPath
                                                .toString()
                                            : widget.postModel.imageBackPath
                                                .toString()))),
                            Padding(
                                padding: EdgeInsets.all(20),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                6,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3.9,
                                        child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: !switcher
                                                ? widget
                                                    .postModel.imageFrontPath
                                                    .toString()
                                                : widget.postModel.imageBackPath
                                                    .toString())))),
                          ],
                        )))),
            Padding(
                padding: EdgeInsets.only(top: 10, left: 10),
                child: Text(
                  "Antoine Gonthier",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.left,
                ))
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ));
  }
}
