// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:threads/model/post.module.dart';

class GridPostWidget extends StatefulWidget {
  PostModel postModel;
  GridPostWidget({required this.postModel, super.key});

  @override
  State<GridPostWidget> createState() => _GridPostWidgetState();
}

class _GridPostWidgetState extends State<GridPostWidget> {
  bool switcher = false;
  void switcherFunc() {
    setState(() {
      switcher = !switcher;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime? createdAt;

    if (widget.postModel.createdAt.isNotEmpty) {
      createdAt = DateTime.parse(widget.postModel.createdAt);
    }
    String? timeAgo;
    if (createdAt != null) {
      Duration difference = now.difference(createdAt);

      if (difference.inSeconds < 60) {
        timeAgo = 'Il y a quelques secondes';
      } else if (difference.inMinutes < 60) {
        int minutes = difference.inMinutes;
        timeAgo = 'Il y a $minutes minute${minutes > 1 ? 's' : ''}';
      } else {
        int hours = difference.inHours;
        timeAgo = 'Il y a $hours heure${hours > 1 ? 's' : ''}';
      }
    }

    return GestureDetector(
        onTap: switcherFunc,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
              alignment: Alignment.bottomCenter,
              fit: StackFit.expand,
              children: [
                FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 1.63,
                        child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: switcher
                                ? widget.postModel.imageBackPath.toString()
                                : widget.postModel.imageFrontPath.toString()))),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 7.5, left: 5),
                  child: Text.rich(
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
                          text: timeAgo,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ]),
        ));
  }
}
