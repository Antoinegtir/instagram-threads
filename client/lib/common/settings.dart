import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threads/state/auth.state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthState>(context);
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: AppBar(
            flexibleSpace: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 50,
                      ),
                      Row(
                        children: [
                          Stack(
                            children: [
                              BackButton(),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                    padding: EdgeInsets.only(left: 35, top: 12),
                                    child: Text("Back",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                        ))),
                              )
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ]),
            leading: Container(),
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Padding(
                padding: EdgeInsets.only(bottom: 27),
                child: FadeInRight(
                    duration: Duration(milliseconds: 300),
                    child: Text(
                      "Settings",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                    )))),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: ListView(
              children: [
                Container(
                  height: 0.5,
                  color: Color.fromARGB(255, 77, 77, 77),
                  width: MediaQuery.of(context).size.width,
                ),
                Container(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                    ),
                    Icon(
                      CupertinoIcons.person_add,
                      size: 30,
                    ),
                    Container(
                      width: 20,
                    ),
                    Text(
                      "Follow and invite friends",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )
                  ],
                ),
                Container(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                    ),
                    Icon(
                      CupertinoIcons.bell,
                      size: 30,
                    ),
                    Container(
                      width: 20,
                    ),
                    Text(
                      "Notifications",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )
                  ],
                ),
                Container(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                    ),
                    Icon(
                      Icons.lock_outline,
                      size: 30,
                    ),
                    Container(
                      width: 20,
                    ),
                    Text(
                      "Privacy",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )
                  ],
                ),
                Container(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                    ),
                    Icon(
                      Icons.help_outline,
                      size: 30,
                    ),
                    Container(
                      width: 20,
                    ),
                    Text(
                      "Help",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )
                  ],
                ),
                Container(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                    ),
                    Icon(
                      CupertinoIcons.info,
                      size: 30,
                    ),
                    Container(
                      width: 20,
                    ),
                    Text(
                      "About",
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )
                  ],
                ),
                Container(
                  height: 15,
                ),
                Container(
                  height: 0.5,
                  color: Color.fromARGB(255, 77, 77, 77),
                  width: MediaQuery.of(context).size.width,
                ),
                Container(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                    ),
                    GestureDetector(
                        onTap: () {
                          state.logoutCallback();
                          Navigator.pop(context);
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              child: Text(
                                "Log out",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 17),
                              ),
                            ))),
                  ],
                ),
              ],
            )));
  }
}
