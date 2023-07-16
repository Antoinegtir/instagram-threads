import 'package:awesome_icons/awesome_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:threads/pages/home.dart';

import '../../widget/custom/rippleButton.dart';

class ThreadPage extends StatefulWidget {
  const ThreadPage({super.key});

  @override
  State<ThreadPage> createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: RippleButton(
                    splashColor: Colors.transparent,
                    child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                            child: Text(
                          "Join Threads",
                          style: TextStyle(
                              fontFamily: "icons.ttf",
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ))),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    })),
          ],
        ),
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: Container(),
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
            ],
          ),
        ),
        backgroundColor: Colors.black,
        body: ListView(
          children: [
            Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                height: 10,
              ),
              Text(
                "How Threads works",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              Container(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 20,
                  ),
                  Icon(
                    CupertinoIcons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                  Container(
                    width: 10,
                  ),
                  Text(
                    "Powered by Instagram",
                    style: TextStyle(
                        fontFamily: "arial",
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Container(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                  ),
                  Text(
                    "Threads is  part of the Instagram\nplatform. We will use your Threads\nand Instagram information to\npersonalize ads and other experiences\nacross Threads and Instagram. Lean\nmore",
                    style: TextStyle(
                        fontFamily: "arial",
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        wordSpacing: 1.2),
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
                    FontAwesomeIcons.globeAmericas,
                    color: Colors.white,
                    size: 28,
                  ),
                  Container(
                    width: 10,
                  ),
                  Text(
                    "The fediverse",
                    style: TextStyle(
                        fontFamily: "arial",
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Container(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                  ),
                  Text(
                    "Future versions of Threads will work\nwith the fediverse, a new type of\nsocial media network that allows\npeople to follow and interact with each\nother on different pplatfirms, like\nMastodon. Learn more",
                    style: TextStyle(
                        fontFamily: "arial",
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        wordSpacing: 1.2),
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
                    FontAwesomeIcons.globeAmericas,
                    color: Colors.white,
                    size: 28,
                  ),
                  Container(
                    width: 10,
                  ),
                  Text(
                    "Your data",
                    style: TextStyle(
                        fontFamily: "arial",
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Container(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                  ),
                  Text(
                    "By joining Threads, you agree to\nthe Meta Terms and Threads\nSupplemental Terms,\nand acknowledge you have read\nthe Meta Privacy Policy and Threads\nSupplement Privacy Policy.",
                    style: TextStyle(
                        fontFamily: "arial",
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        wordSpacing: 1.2),
                  )
                ],
              )
            ]),
          ],
        ));
  }
}
