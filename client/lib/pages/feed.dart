// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> with TickerProviderStateMixin {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: Container(),
          title: Lottie.network(
              "https://assets3.lottiefiles.com/packages/lf20_Ht77kFLXYw.json",
              height: 50),
          toolbarHeight: 37,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Container());
  }
}
