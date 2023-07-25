// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:threads/state/auth.state.dart';
import 'package:threads/state/post.state.dart';
import 'package:threads/widget/feedpost.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> with TickerProviderStateMixin {
  ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<AuthState>(context, listen: false);
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: Container(),
        centerTitle: true,
        title: Lottie.network(
            "https://assets3.lottiefiles.com/packages/lf20_Ht77kFLXYw.json",
            height: 50),
        toolbarHeight: 37,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<PostState>(builder: (context, state, child) {
        if (state.isBusy)
          return Container();
        else
          return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount:
                      state.getPostList(authState.userModel)?.toList().length ??
                          0,
                  itemBuilder: (context, index) {
                    return FeedPostWidget(
                      postModel: state.getPostList(authState.userModel)![index],
                    );
                  }));
      }),
    );
  }
}
