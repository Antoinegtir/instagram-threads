import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwitchAccount extends StatefulWidget {
  const SwitchAccount({super.key});

  @override
  State<SwitchAccount> createState() => _SwitchAccountState();
}

class _SwitchAccountState extends State<SwitchAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Container(),
          flexibleSpace: Column(
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
                            padding: EdgeInsets.only(left: 35, top: 10),
                            child: Text("Back",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                ))),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  "Switch accounts",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w700),
                ),
                Container(
                  height: 20,
                ),
                Text(
                  "If you don't see the account you're looking\nfor here, you'll need to sign in on Instagram\nfirst.",
                  style: TextStyle(
                      color: Color.fromARGB(255, 112, 112, 112),
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                Container(
                  height: 100,
                ),
                GestureDetector(
                    onTap: () {
                      Platform.isIOS
                          ? showDialog(
                              context: context,
                              builder: (_) => CupertinoAlertDialog(
                                    title: const Text("Account"),
                                    content: const Text(
                                        "There is no more account in this test application, create it"),
                                    actions: [
                                      CupertinoDialogAction(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Confirm',
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ),
                                    ],
                                  ))
                          : showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    contentPadding: EdgeInsets.only(
                                        right: 50,
                                        left: 50,
                                        top: 20,
                                        bottom: 20),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(40))),
                                    backgroundColor: Colors.black,
                                    title: Text(
                                      "Account",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    content: Text(
                                      'There is no more account in this test application, create it',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 198, 198, 198),
                                          fontSize: 15,
                                          fontWeight: FontWeight.w100),
                                    ),
                                    actions: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("Ok",
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 14))),
                                        ],
                                      )
                                    ],
                                  ));
                    },
                    child: Container(
                        height: 175,
                        width: 330,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 30,
                                ),
                                Image.asset(
                                  "assets/pp.jpg",
                                  height: 60,
                                ),
                                Container(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Test_account",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "testaccount123",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 80,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                )
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child: Container(
                                  width: 300,
                                  height: 0.5,
                                  color: Colors.grey,
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 20,
                                ),
                                Image.asset(
                                  "assets/pp.jpg",
                                  height: 60,
                                ),
                                Container(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Test_account2",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "testaccount21",
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  ],
                                ),
                                Container(
                                  width: 70,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ],
                        ))),
                Container(
                  height: MediaQuery.of(context).size.height / 4,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Log in to another Instagram account",
                    style: TextStyle(
                        color: Color.fromARGB(255, 112, 112, 112),
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
