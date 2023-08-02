import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threads/model/post.module.dart';
import 'package:threads/state/auth.state.dart';
import 'package:threads/common/settings.dart';
import 'package:threads/state/post.state.dart';
import 'package:threads/widget/feedpost.dart';
import 'edit.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({super.key});

  @override
  State<MyProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<MyProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var authState = Provider.of<AuthState>(context, listen: false);
    var state = Provider.of<AuthState>(context);
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
          actions: [
            GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingsPage()));
                },
                child: Icon(CupertinoIcons.list_bullet_indent,
                    color: Colors.white))
          ],
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(CupertinoIcons.globe, color: Colors.white)),
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
                              state.profileUserModel?.displayName.toString() ??
                                  "",
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
                                      state.profileUserModel?.userName
                                              .toString() ??
                                          "",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400),
                                    )),
                                Container(
                                  width: 5,
                                ),
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
                                      builder: (context) => EditProfilePage()));
                            },
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    height: 100,
                                    imageUrl: state.profileUserModel!.profilePic
                                        .toString(),
                                  ),
                                ))),
                      ],
                    ),
                    Container(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 20,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 19, 19, 19),
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.all(2),
                          child: Text(
                            state.profileUserModel?.link.toString() ?? "",
                          ),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProfilePage()));
                            },
                            child: Text(
                              "${state.profileUserModel?.bio ?? ""}",
                              style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
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
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditProfilePage()));
                            },
                            child: Container(
                                height: 40,
                                width: 165,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(8),
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
                            width: 165,
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
                        height: MediaQuery.of(context).size.height,
                        child:
                            TabBarView(controller: _tabController, children: [
                          Consumer<PostState>(builder: (context, state, child) {
                            List<PostModel>? list = state
                                .getPostList(authState.userModel)!
                                .toList();
                            if (state.feedlist != null &&
                                state.feedlist!.isNotEmpty) {
                              list = state.feedlist!
                                  .where(
                                      (x) => x.user!.userId == authState.userId)
                                  .toList();
                            }
                            return ListView.builder(
                                itemCount: list.length,
                                itemBuilder: (context, index) {
                                  return FeedPostWidget(
                                    postModel: list![index],
                                  );
                                });
                          }),
                          Container(
                            height: 100,
                            width: 200,
                            alignment: Alignment.center,
                            child: Text(
                              "You haven't posted any threads yet.",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 84, 60, 60)),
                            ),
                          )
                        ]))
                  ]))
        ])));
  }
}
