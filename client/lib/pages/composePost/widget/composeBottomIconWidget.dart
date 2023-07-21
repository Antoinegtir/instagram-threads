import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ComposeBottomIconWidget extends StatefulWidget {
  final TextEditingController textEditingController;
  final Function(File) onImageIconSelcted;
  const ComposeBottomIconWidget(
      {Key? key,
      required this.textEditingController,
      required this.onImageIconSelcted})
      : super(key: key);

  @override
  _ComposeBottomIconWidgetState createState() =>
      _ComposeBottomIconWidgetState();
}

class _ComposeBottomIconWidgetState extends State<ComposeBottomIconWidget> {
  bool reachToWarning = false;
  bool reachToOver = false;
  late Color wordCountColor;
  String post = '';

  @override
  void initState() {
    wordCountColor = Colors.blue;
    super.initState();
  }

  Widget _bottomIconWidget() {
    return Container(
        color: Colors.black.withOpacity(0),
        width: 100,
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
                onPressed: () {
                  setImage(ImageSource.gallery);
                },
                icon: Icon(
                  Iconsax.picture_frame,
                  size: 40,
                  color: Colors.blue,
                )),
          ],
        ));
  }

  Future<void> setImage(ImageSource source) async {
    ImagePicker()
        .pickImage(source: source, imageQuality: 100)
        .then((XFile? file) async {
      await ImageCropper.platform.cropImage(
        sourcePath: file!.path,
        cropStyle: CropStyle.rectangle,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
      ).then((value) => setState(() {
            widget.onImageIconSelcted(File(value!.path));
          }));
    });
  }

  double getPostLimit() {
    if (/*post == null || */ post.isEmpty) {
      return 0.0;
    }
    if (post.length > 280) {
      return 1.0;
    }
    var length = post.length;
    var val = length * 100 / 28000.0;
    return val;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: _bottomIconWidget(),
        )
      ],
    );
  }
}
