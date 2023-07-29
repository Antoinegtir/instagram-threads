import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:threads/pages/composePost/post.dart';
import 'package:threads/pages/notification/notification.dart';
import 'package:threads/pages/search/search.dart';
import 'package:threads/state/auth.state.dart';
import 'package:threads/state/post.state.dart';
import 'package:threads/state/search.state.dart';
import 'package:threads/pages/profile/myprofile.dart';
import 'camera/camera.dart';
import 'feed/feed.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initPosts();
      initSearch();
      initProfile();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void initSearch() {
    var searchState = Provider.of<SearchState>(context, listen: false);
    searchState.getDataFromDatabase();
  }

  void initProfile() {
    var state = Provider.of<AuthState>(context, listen: false);
    state.databaseInit();
  }

  void initPosts() {
    var state = Provider.of<PostState>(context, listen: false);
    state.databaseInit();
    state.getDataFromDatabase();
  }

  Widget tabPage(int index) {
    if (index == 0) return FeedPage();
    if (index == 1) return SearchPage();
    if (index == 2) return ComposePost();
    if (index == 3) return NotificationPage();
    if (index == 4) return MyProfilePage();
    return FeedPage();
  }

  bool isSelected = false;
  Widget iconBar(int tabCount, IconData icon) {
    return GestureDetector(
        onTap: () {
          setState(() {
            tab = tabCount;
          });
        },
        child: Icon(
          icon,
          size: 30,
          color: Colors.grey,
        ));
  }

  Widget bottomNavBar() {
    Widget separator = Container(
      width: 40,
    );
    return Container(
        color: Colors.black,
        height: 90,
        padding: EdgeInsets.only(bottom: 20),
        width: MediaQuery.of(context).size.width,
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          iconBar(0, Iconsax.home),
          separator,
          iconBar(1, Iconsax.search_normal),
          separator,
          iconBar(2, Iconsax.edit),
          separator,
          iconBar(3, Iconsax.heart),
          separator,
          iconBar(
            4,
            CupertinoIcons.person,
          ),
        ]));
  }

  int tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: CameraPage(),
        extendBody: true,
        bottomNavigationBar: bottomNavBar(),
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        body: tabPage(tab));
  }
}
