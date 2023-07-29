// ignore_for_file: deprecated_member_use
import 'dart:io';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:threads/model/post.module.dart';
import 'package:threads/model/user.module.dart';
import 'package:threads/state/auth.state.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import '../../main.dart';

class CameraPage extends StatefulWidget {
  CameraPage(
      {Key? key, this.text, this.initialDirection = CameraLensDirection.back})
      : super(key: key);

  final String? text;
  final CameraLensDirection initialDirection;

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with TickerProviderStateMixin {
  CameraController? _controller;
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.reference();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  int _cameraIndex = -1;
  double zoomLevel = 0.0, minZoomLevel = 0.0, maxZoomLevel = 0.0;
  bool _changingCameraLens = false;
  bool flashEnabled = false;
  String frontImagePath = "";
  String backImagePath = "";
  bool isFrontImageTaken = false;
  bool isBackImageTaken = false;
  AnimationController? rotationController;
  final Duration animationDuration = Duration(milliseconds: 1000);
  @override
  void initState() {
    super.initState();
    rotationController = AnimationController(
      vsync: this,
      duration: animationDuration,
    );
    if (cameras.any(
      (element) =>
          element.lensDirection == widget.initialDirection &&
          element.sensorOrientation == 90,
    )) {
      _cameraIndex = cameras.indexOf(
        cameras.firstWhere((element) =>
            element.lensDirection == widget.initialDirection &&
            element.sensorOrientation == 90),
      );
    } else {
      for (var i = 0; i < cameras.length; i++) {
        if (cameras[i].lensDirection == widget.initialDirection) {
          _cameraIndex = i;
          break;
        }
      }
    }

    _startLiveFeed();
  }

  @override
  void dispose() {
    // _stopLiveFeed();
    super.dispose();
  }

  Future<String> uploadImageToStorage(File file) async {
    String fileName = Path.basename(file.path);
    Reference storageRef = _storage.ref().child('images/$fileName');
    UploadTask uploadTask = storageRef.putFile(file);
    TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() {});
    String downloadUrl = await storageSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> addPostToDatabase(PostModel post) async {
    var newPostRef = _databaseRef.child('posts').push();
    newPostRef.set(post.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 140,
        flexibleSpace: Container(
            height: 300,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: _cameraIndex == 1
                        ? () {
                            HapticFeedback.heavyImpact();
                          }
                        : _flashEnable,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          height: 50,
                          width: 50,
                          color: Colors.white,
                          child: Icon(
                            flashEnabled
                                ? Iconsax.flash_15
                                : Iconsax.flash_slash5,
                            color: Colors.black,
                            size: 25,
                          ),
                        ))),
                Container(
                  width: 50,
                ),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          height: 50,
                          width: 50,
                          color: Colors.white,
                          child: Icon(
                            flashEnabled ? Iconsax.home : Iconsax.home,
                            color: Colors.black,
                            size: 25,
                          ),
                        ))),
                Container(
                  width: 50,
                ),
                GestureDetector(
                  onTap: _switchFrontCamera,
                  child: AnimatedBuilder(
                    animation: rotationController!,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: rotationController!.value * 2.0 * pi,
                        child: child,
                      );
                    },
                    child: Transform(
                        transform: Matrix4.identity()..scale(-1.0, 1.0, -1.0),
                        alignment: Alignment.center,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              height: 50,
                              width: 50,
                              color: Colors.white,
                              child: Icon(
                                Icons.loop_rounded,
                                color: Colors.black,
                                size: 27,
                              ),
                            ))),
                  ),
                )
              ],
            )),
        leading: SizedBox.shrink(),
      ),
      backgroundColor: Colors.black,
      body: _body(),
    );
  }

  Widget _body() {
    if (_controller?.value.isInitialized == false) {
      return Container();
    }
    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * _controller!.value.aspectRatio;

    if (scale < 1) scale = 1 / scale;

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color: Colors.black,
              height: MediaQuery.of(context).size.height / 1,
              width: MediaQuery.of(context).size.width / 1,
              child: _changingCameraLens
                  ? Container()
                  : GestureDetector(
                      onScaleUpdate: (ScaleUpdateDetails details) {
                        if (details.scale != 1.0) {
                          double newZoomLevel = zoomLevel * details.scale;
                          if (newZoomLevel < minZoomLevel) {
                            newZoomLevel = minZoomLevel;
                          } else if (newZoomLevel > maxZoomLevel) {
                            newZoomLevel = maxZoomLevel;
                          }
                          if (newZoomLevel < minZoomLevel) {
                            newZoomLevel = minZoomLevel;
                          }
                          setState(() {
                            zoomLevel = newZoomLevel;
                            _controller!.setZoomLevel(zoomLevel);
                          });
                        }
                      },
                      child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                              width: _controller!.value.previewSize!.height,
                              height: _controller!.value.previewSize!.width,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CameraPreview(_controller!),
                                  GestureDetector(
                                      onTap: _switchGiantAngle,
                                      child: _cameraIndex == 1
                                          ? Container()
                                          : Padding(
                                              padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      1.1),
                                              child: Container(
                                                height: 65,
                                                width: 65,
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 88, 88, 88),
                                                  shape: BoxShape.circle,
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  _cameraIndex == 2
                                                      ? "0.5x"
                                                      : "1x",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 25),
                                                ),
                                              )))
                                ],
                              )))),
            )),
        Padding(
            padding: EdgeInsets.only(bottom: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: _takePicture,
                    child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 213, 213, 213),
                          border: Border.all(color: Colors.white, width: 5),
                          shape: BoxShape.circle,
                        ))),
              ],
            ))
      ],
    );
  }

  Future _startLiveFeed() async {
    final camera = cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      // _controller?.getMinZoomLevel().then((value) {
      //   zoomLevel = value;
      //   minZoomLevel = value;
      // });
      // _controller?.getMaxZoomLevel().then((value) {
      //   maxZoomLevel = value;
      // });
      // _controller?.startImageStream(_processCameraImage);
      setState(() {});
    });
  }

  Future<void> _takePicture() async {
    HapticFeedback.heavyImpact();
    var state = Provider.of<AuthState>(context, listen: false);
    _controller!.takePicture().then((fpath) async {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _switchFrontCamera();
      });
      uploadImageToStorage(File(fpath.path)).then((path) {
        setState(() {
          backImagePath = path;
        });
      });
      return _controller!.takePicture();
    }).then((bpath) {
      uploadImageToStorage(File(bpath.path)).then((path) {
        UserModel user = UserModel(
          displayName: state.profileUserModel!.displayName ?? "",
          profilePic: state.profileUserModel!.profilePic,
          userId: state.profileUserModel!.userId,
        );
        PostModel post = PostModel(
          user: user,
          createdAt: DateTime.now().toUtc().toString(),
        );
        addPostToDatabase(post);
      });
      return bpath;
    });
  }

  Future _stopLiveFeed() async {
    _controller = null;
  }

  Future _flashEnable() async {
    HapticFeedback.heavyImpact();
    if (flashEnabled) {
      setState(() {
        flashEnabled = false;
      });
      _controller!.setFlashMode(FlashMode.off);
    } else {
      setState(() {
        flashEnabled = true;
      });
      _controller!.setFlashMode(FlashMode.torch);
    }
  }

  Future _switchGiantAngle() async {
    HapticFeedback.heavyImpact();
    if (_cameraIndex == 2) {
      setState(() => _changingCameraLens = true);
      _cameraIndex = 0;
      await _stopLiveFeed();
      await _startLiveFeed();
      setState(() => _changingCameraLens = false);
    } else {
      setState(() => _changingCameraLens = true);
      _cameraIndex = 2;

      await _stopLiveFeed();
      await _startLiveFeed();
      setState(() => _changingCameraLens = false);
    }
  }

  Future _switchFrontCamera() async {
    HapticFeedback.heavyImpact();
    if (_cameraIndex == 0 || _cameraIndex == 2) {
      setState(() => _changingCameraLens = true);
      _cameraIndex = 1;

      await _stopLiveFeed();
      await _startLiveFeed();
      setState(() => _changingCameraLens = false);
    } else {
      setState(() => _changingCameraLens = true);
      _cameraIndex = 0;

      await _stopLiveFeed();
      await _startLiveFeed();
      setState(() => _changingCameraLens = false);
      rotationController!.forward();
      rotationController!.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          rotationController!.reset();
        }
      });
    }
  }
}
