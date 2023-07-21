// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';

class ComposePostImage extends StatelessWidget {
  final File? image;
  final VoidCallback onCrossIconPressed;
  const ComposePostImage(
      {Key? key, this.image, required this.onCrossIconPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (image != null) assert(onCrossIconPressed != null);
    return Container(
      child: image == null
          ? Container()
          : Stack(
              children: <Widget>[
                InteractiveViewer(
                  child: Container(
                    alignment: Alignment.topRight,
                    child: Container(
                      height: 220,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        image: DecorationImage(
                            image: FileImage(image!), fit: BoxFit.contain),
                      ),
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 10, 0),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                              child: Container(
                                color: Colors.grey.withOpacity(1),
                                padding: const EdgeInsets.all(0),
                                child: IconButton(
                                  padding: const EdgeInsets.all(0),
                                  iconSize: 20,
                                  onPressed: onCrossIconPressed,
                                  icon: Icon(
                                    Icons.close,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ))))
              ],
            ),
    );
  }
}
