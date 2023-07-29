import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:threads/helper/utility.dart';
import 'package:threads/model/post.module.dart';

// ignore: must_be_immutable
class FeedPostWidget extends StatefulWidget {
  PostModel postModel;
  FeedPostWidget({required this.postModel, super.key});

  @override
  State<FeedPostWidget> createState() => _FeedPostWidgetState();
}

class _FeedPostWidgetState extends State<FeedPostWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 0.2,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey,
            ),
            Container(
              height: 10,
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
                Container(
                  width: 5,
                ),
                Text(
                  widget.postModel.user!.displayName.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 4,
                ),
                Text(
                  Utility.getdob(widget.postModel.createdAt),
                  style:
                      TextStyle(color: const Color.fromARGB(255, 78, 78, 78)),
                ),
                Container(
                  width: 5,
                ),
                Icon(Icons.more_horiz, color: Colors.white)
              ],
            ),
            Padding(
                padding: EdgeInsets.only(left: 55),
                child: Text(
                  widget.postModel.bio!,
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                )),
            widget.postModel.imagePath == null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 12,
                      ),
                      Column(
                        children: [
                          Container(
                            width: 2,
                            height: 30,
                            color: const Color.fromARGB(255, 46, 46, 46),
                          ),
                          Container(
                            height: 5,
                          ),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Container(
                                  height: 15,
                                  width: 15,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.postModel.user!.profilePic
                                        .toString(),
                                  ))),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 20, right: 10),
                          child: widget.postModel.imagePath == null
                              ? SizedBox.shrink()
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                      height: 300,
                                      width: 330,
                                      fit: BoxFit.cover,
                                      imageUrl: widget.postModel.imagePath
                                          .toString()))),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Container(
                            width: 2,
                            height: 300,
                            color: const Color.fromARGB(255, 46, 46, 46),
                          ),
                          Container(
                            height: 5,
                          ),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Container(
                                  height: 15,
                                  width: 15,
                                  child: CachedNetworkImage(
                                    imageUrl: widget.postModel.user!.profilePic
                                        .toString(),
                                  ))),
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 48, right: 10),
                          child: widget.postModel.imagePath == null
                              ? SizedBox.shrink()
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                      height: 300,
                                      width: 290,
                                      fit: BoxFit.cover,
                                      imageUrl: widget.postModel.imagePath
                                          .toString()))),
                    ],
                  ),
            Container(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 50,
                ),
                Icon(
                  Iconsax.heart,
                  size: 20,
                ),
                Container(
                  width: 10,
                ),
                Icon(
                  Iconsax.share,
                  size: 20,
                ),
                Container(
                  width: 10,
                ),
                Icon(
                  Iconsax.repeat,
                  size: 20,
                ),
                Container(
                  width: 10,
                ),
                Icon(
                  Iconsax.send_2,
                  size: 20,
                ),
              ],
            ),
            Container(
              height: 15,
            ),
          ],
        ));
  }
}
