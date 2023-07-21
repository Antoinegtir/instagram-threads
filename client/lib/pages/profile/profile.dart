// ignore_for_file: deprecated_member_use, unnecessary_null_comparison
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threads/pages/profile/edit.dart';
import 'package:threads/common/settings.dart';
import 'package:threads/state/profile.state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.profileId, this.scaffoldKey})
      : super(key: key);
  final GlobalKey<ScaffoldState>? scaffoldKey;

  final String profileId;
  static PageRouteBuilder getRoute({required String profileId}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        return Provider(
          create: (_) => ProfileState(profileId),
          child: ChangeNotifierProvider(
            create: (BuildContext context) => ProfileState(profileId),
            builder: (_, child) => ProfilePage(
              profileId: profileId,
            ),
          ),
        );
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool isMyProfile = false;
  int pageIndex = 0;
  int counter = 3;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late TabController _tabController;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabController = TabController(length: 2, vsync: this);
      var authstate = Provider.of<ProfileState>(context, listen: false);
      isMyProfile = authstate.isMyProfile;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authstate = Provider.of<ProfileState>(context);
    return authstate.isbusy
        ? Container()
        : Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.black,
            appBar: AppBar(
              actions: [
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsPage()));
                    },
                    child: Container(
                        width: 50,
                        height: 50,
                        child: Icon(CupertinoIcons.list_bullet_indent,
                            color: Colors.white)))
              ],
              leading: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(CupertinoIcons.back, color: Colors.white)),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            body: Center(
                child: ListView(children: [
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  authstate.profileUserModel.displayName
                                      .toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditProfilePage()));
                                        },
                                        child: Text(
                                          authstate.profileUserModel.userName
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400),
                                        )),
                                    Container(
                                      width: 5,
                                    ),
                                    Container(
                                      height: 20,
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 19, 19, 19),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: EdgeInsets.all(2),
                                      child: Text(
                                        authstate.profileUserModel.link
                                            .toString(),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                            Container(
                              width: 63,
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditProfilePage()));
                                },
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        height: 100,
                                        imageUrl: authstate
                                            .profileUserModel.profilePic
                                            .toString(),
                                      ),
                                    ))),
                          ],
                        ),
                        Container(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditProfilePage()));
                                },
                                child: Text(
                                  "${authstate.profileUserModel.bio}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                )),
                          ],
                        ),
                        Container(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            !isMyProfile
                                ? Container()
                                : GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EditProfilePage()));
                                    },
                                    child: Container(
                                        height: 40,
                                        width: 170,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                            color: Colors.grey,
                                            width: 0.5,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text("Edit profile"))),
                            Container(
                              width: 10,
                            ),
                            Container(
                                height: 40,
                                width: 170,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.grey,
                                    width: 0.5,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text("Share profile"))
                          ],
                        ),
                        Container(
                          height: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: TabBar(
                            onTap: (index) {},
                            controller: _tabController,
                            isScrollable: false,
                            labelColor: Colors.white,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: Colors.white,
                            indicatorWeight: 1,
                            tabs: [
                              Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Tab(
                                      child: Text(
                                    'Threads',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ))),
                              Padding(
                                padding: EdgeInsets.only(right: 0),
                                child: Tab(
                                    child: Text(
                                  'Replies',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                              )
                            ],
                          ),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: 300,
                            child: TabBarView(
                                controller: _tabController,
                                children: [
                                  Container(
                                    height: 200,
                                    width: 200,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "You haven't posted any threads yet.",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 63, 63, 63)),
                                    ),
                                  ),
                                  Container(
                                    height: 100,
                                    width: 200,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "You haven't posted any threads yet.",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 63, 63, 63)),
                                    ),
                                  )
                                ]))
                      ]))
            ])));
  }
}

class Choice {
  const Choice(
      {required this.title, required this.icon, this.isEnable = false});
  final bool isEnable;
  final IconData icon;
  final String title;
}

const List<Choice> choices = <Choice>[
  Choice(title: 'Share', icon: Icons.directions_car, isEnable: true),
  Choice(title: 'QR code', icon: Icons.directions_railway, isEnable: true),
];
