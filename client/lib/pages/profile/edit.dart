import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:threads/state/auth.state.dart';
import 'package:image_cropper/image_cropper.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _displayName;
  late TextEditingController _bio;
  late TextEditingController _link;
  File? _image;

  @override
  void initState() {
    _displayName = TextEditingController();
    _bio = TextEditingController();
    _link = TextEditingController();
    AuthState state = Provider.of<AuthState>(context, listen: false);
    _displayName.text = state.userModel?.displayName ?? '';
    _bio.text = state.userModel?.bio ?? '';
    _link.text = state.userModel?.link ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _bio.dispose();
    _link.dispose();
    _displayName.dispose();
    super.dispose();
  }

  Future<void> getImage(BuildContext context, ImageSource source,
      Function(File) onImageSelected) async {
    ImagePicker()
        .pickImage(source: source, imageQuality: 100)
        .then((XFile? file) async {
      await ImageCropper.platform.cropImage(
        sourcePath: file!.path,
        cropStyle: CropStyle.circle,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
      ).then((value) => setState(() {
            onImageSelected(File(value!.path));
          }));
    });
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthState>(context);
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          toolbarHeight: 68,
          leading: Container(),
          flexibleSpace: Padding(
              padding: EdgeInsets.only(left: 5, top: 60),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(left: 15, top: 5),
                                  child: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text("Cancel",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400)))),
                              Text(
                                "Edit profile   ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 15),
                                child: GestureDetector(
                                    onTap: _submitButton,
                                    child: Text("Done",
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600))),
                              )
                            ],
                          )),
                    ],
                  ))),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
            padding: EdgeInsets.only(top: 100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    height: 250,
                    width: 330,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 25, 25, 25),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.5,
                      ),
                    ),
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 200,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 10,
                                      ),
                                      Text(
                                        "Name",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18),
                                      ),
                                      CupertinoTextField(
                                        controller: _displayName,
                                        prefix: Icon(
                                          Icons.lock_outline_rounded,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                        placeholder:
                                            state.userModel!.displayName,
                                        placeholderStyle: TextStyle(
                                            color: Colors.grey, fontSize: 18),
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      Container(
                                        height: 5,
                                      ),
                                      Container(
                                        width: 300,
                                        height: 0.5,
                                        color: Colors.grey,
                                      ),
                                      Container(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 30,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    showCupertinoModalPopup(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            CupertinoTheme(
                                              data: CupertinoThemeData(
                                                brightness: Brightness
                                                    .dark, // Définir le mode sombre
                                              ),
                                              child: CupertinoActionSheet(
                                                title: Text(
                                                    'Changer de photo de profil'),
                                                message: Text(
                                                    'Ta photo de profil est visible par tous et permetttra à tes amis de t\'ajoyter plus facilement'),
                                                actions: <Widget>[
                                                  CupertinoActionSheetAction(
                                                    child: Text('Photothèque'),
                                                    onPressed: () {
                                                      getImage(context,
                                                          ImageSource.gallery,
                                                          (file) {
                                                        setState(() {
                                                          _image = file;
                                                        });
                                                      });
                                                      setState(() {});
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  CupertinoActionSheetAction(
                                                    child:
                                                        Text('Appareil photo'),
                                                    onPressed: () {
                                                      getImage(context,
                                                          ImageSource.camera,
                                                          (file) {
                                                        setState(() {
                                                          _image = file;
                                                        });
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  CupertinoActionSheetAction(
                                                    child: Text(
                                                      'Supprimer la photo de profil',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ],
                                                cancelButton:
                                                    CupertinoActionSheetAction(
                                                  child: Text('Annuler'),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                            ));
                                  },
                                  child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 25,
                                      backgroundImage: (_image != null
                                          ? FileImage(_image!)
                                          : CachedNetworkImageProvider(
                                              scale: 2,
                                              state.profileUserModel!.profilePic
                                                  .toString(),
                                            ) as ImageProvider)),
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Bio",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                                CupertinoTextField(
                                  controller: _bio,
                                  prefix: Icon(
                                    Icons.add,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                  placeholder: 'Write bio',
                                  placeholderStyle: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                Container(
                                  height: 10,
                                ),
                                Container(
                                  width: 300,
                                  height: 0.5,
                                  color: Colors.grey,
                                ),
                                Container(
                                  height: 20,
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Link",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                                CupertinoTextField(
                                  controller: _link,
                                  prefix: Icon(
                                    Icons.add,
                                    size: 15,
                                    color: Colors.white,
                                  ),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                  placeholder: 'Add Link',
                                  placeholderStyle: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ))),
              ],
            )));
  }

  void _submitButton() {
    if (_displayName.text.length > 100) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))),
        backgroundColor: Colors.white,
        content: Container(
            alignment: Alignment.center,
            height: 30,
            child: Text(
              'Max Len: 100 char',
              style: TextStyle(
                  fontFamily: "icons.ttf",
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w900),
            )),
      ));
      return;
    }
    if (_bio.text.length > 100) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40))),
        backgroundColor: Colors.white,
        content: Container(
            alignment: Alignment.center,
            height: 30,
            child: Text(
              'Max Len: 100 char',
              style: TextStyle(
                  fontFamily: "icons.ttf",
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w900),
            )),
      ));
      return;
    }
    var state = Provider.of<AuthState>(context, listen: false);
    var model = state.userModel!.copyWith(
      key: state.userModel!.userId,
      displayName: state.userModel!.displayName,
      link: state.userModel!.link,
      bio: state.userModel!.bio,
      profilePic: state.userModel!.profilePic,
    );
    model.bio = _bio.text;
    model.displayName = _displayName.text;
    model.link = _link.text;
    state.updateUserProfile(
      model,
      image: _image,
    );
    Navigator.pop(context);
  }
}
