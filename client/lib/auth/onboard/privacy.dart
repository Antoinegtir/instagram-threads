import 'package:flutter/material.dart';
import 'package:threads/auth/onboard/follow.dart';
import '../../widget/custom/rippleButton.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  bool isselected = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.black,
          leading: Container(),
          flexibleSpace:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
            )
          ])),
      backgroundColor: Colors.black,
      body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        Container(
          height: 10,
        ),
        Text(
          "Privacy",
          style: TextStyle(
              color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        Container(
          height: 20,
        ),
        Text(
          "You're privacy on Threads and Instagram\ncan be different. Learn more.",
          style: TextStyle(
              color: Color.fromARGB(255, 96, 96, 96),
              fontSize: 16,
              fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        Container(
          height: 90,
        ),
        GestureDetector(
            onTap: () {
              setState(() {
                isselected = false;
              });
            },
            child: Container(
              height: 120,
              width: 330,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: !isselected ? Colors.white : Colors.grey,
                  width: !isselected ? 2 : 0.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "   Public profile",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "\n   Anyone on or off Threads can see,\n   share and interact with your content.",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )),
        Container(
          height: 20,
        ),
        GestureDetector(
            onTap: () {
              setState(() {
                isselected = true;
              });
            },
            child: Container(
              height: 120,
              width: 330,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isselected ? Colors.white : Colors.grey,
                  width: isselected ? 2 : 0.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        "   Private profile",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                      Container(
                        width: 170,
                      ),
                      Icon(
                        Icons.lock_outlined,
                        color: Colors.white,
                      )
                    ],
                  ),
                  Text(
                    "\n   Only you aproved followers can\n   see and interact with your content.",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )),
        Container(
          height: MediaQuery.of(context).size.height / 7,
        ),
        RippleButton(
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
                  "Next",
                  style: TextStyle(
                      fontFamily: "icons.ttf",
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.w500),
                ))),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => FollowerPage()));
            }),
      ]),
    );
  }
}
