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
      backgroundColor: Color(0xff0a0a0a),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipRect(
              child: Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              "assets/signin.jpg",
              fit: BoxFit.cover,
            ),
          )),
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
                            " antoine.gtier",
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
