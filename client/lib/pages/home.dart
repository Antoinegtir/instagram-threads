import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:threads/state/authState.dart';
import 'package:threads/state/post.dart';
import 'package:threads/state/searchState.dart';
import 'package:threads/pages/myprofile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;
  ScrollController _scrollController = ScrollController();
  bool _isScrolledDown = false;
  bool _isGrid = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initPosts();
      initSearch();
      initProfile();
    });
    _scrollController.addListener(_scrollListener);
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _tabController.dispose();
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

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      setState(() {
        _isScrolledDown = true;
      });
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      setState(() {
        _isScrolledDown = false;
      });
    }
  }

  Future _bodyView() async {
    if (_isGrid) {
      setState(() {
        _isGrid = false;
      });
    } else {
      setState(() {
        _isGrid = true;
      });
    }
  }

  int tab = 0;
  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<AuthState>(context, listen: false);
    final state = Provider.of<SearchState>(context);

    authState.getCurrentUser().then((value) {
      setState(() {});
    });
    return Scaffold(
        extendBody: true,
        bottomNavigationBar: Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                Iconsax.home,
                size: 30,
                color: Colors.white,
              ),
              Container(
                width: 40,
              ),
              Icon(
                Iconsax.search_normal,
                size: 30,
                color: Colors.white,
              ),
              Container(
                width: 40,
              ),
              Icon(
                Iconsax.edit,
                size: 30,
                color: Colors.white,
              ),
              Container(
                width: 40,
              ),
              Icon(
                Iconsax.heart,
                size: 30,
                color: Colors.white,
              ),
              Container(
                width: 40,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => MyProfilePage())));
                  },
                  child: Icon(
                    CupertinoIcons.person,
                    size: 30,
                    color: Colors.white,
                  ))
            ])),
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: Container(),
          title: Lottie.network(
              "https://assets3.lottiefiles.com/packages/lf20_Ht77kFLXYw.json",height: 50),
          toolbarHeight: 37,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
            ),
            Text(
              '🚧',
              style: TextStyle(fontSize: 40),
            )
          ],
        ));
  }
}
