import 'package:flutter/material.dart';
import 'package:threads/auth/signup/signup.dart';

import 'account.dart';

class NamePage extends StatefulWidget {
  final VoidCallback? loginCallback;
  const NamePage({Key? key, this.loginCallback}) : super(key: key);

  @override
  _NamePageState createState() => _NamePageState();
}

bool empt = false;

class _NamePageState extends State<NamePage> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    setState(() {
      _nameController.text.isNotEmpty ? empt = true : empt = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRect(
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Stack(
                    children: [
                      Image.asset(
                        "assets/threads.png",
                        height: MediaQuery.of(context).size.height / 1.5,
                        fit: BoxFit.fitWidth,
                        width: MediaQuery.of(context).size.width,
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height / 1.5,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.bottomRight,
                                  end: Alignment.topRight,
                                  colors: [
                                Colors.black.withOpacity(1),
                                Colors.black.withOpacity(1),
                                Colors.black.withOpacity(1),
                                Colors.black.withOpacity(1),
                                Colors.black.withOpacity(0.9),
                                Colors.black.withOpacity(0.8),
                                Colors.black.withOpacity(0.7),
                                Colors.black.withOpacity(0.6),
                                Colors.black.withOpacity(0.5),
                                Colors.black.withOpacity(0.4),
                                Colors.black.withOpacity(0.3),
                                Colors.black.withOpacity(0.2),
                                Colors.black.withOpacity(0.1),
                                Colors.black.withOpacity(0.05),
                                Colors.black.withOpacity(0.025),
                                Colors.black.withOpacity(0.0),
                                Colors.black.withOpacity(0.0),
                                Colors.black.withOpacity(0.0),
                                Colors.black.withOpacity(0.0),
                                Colors.black.withOpacity(0.0),
                                Colors.black.withOpacity(0.0),
                                Colors.black.withOpacity(0.0),
                              ])))
                    ],
                  ))),
          Container(
            height: 50,
          ),
          GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Signup()));
              },
              child: Container(
                height: 70,
                width: 330,
                decoration: BoxDecoration(
                  color: Color(0xff0a0a0a),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            " Log in on Instagram",
                            style: TextStyle(
                                color: Color.fromARGB(255, 123, 123, 123),
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                          Container(
                            height: 3,
                          ),
                          Text(
                            " instagram account",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      Container(
                        width: 50,
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 14, top: 14, bottom: 14, right: 4),
                          child: Image.asset("assets/insta.png"))
                    ]),
              )),
          Container(
            height: 20,
          ),
          GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SwitchAccount()));
              },
              child: Text(
                "Switch Account",
                style: TextStyle(
                    color: Color.fromARGB(255, 123, 123, 123),
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
              )),
        ],
      ),
    );
  }
}
