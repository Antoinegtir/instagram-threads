import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:threads/auth/onboard/privacy.dart';
import 'package:threads/helper/utility.dart';
import 'package:provider/provider.dart';
import '../../model/user.module.dart';
import '../../state/auth.state.dart';
import '../../widget/custom/rippleButton.dart';

class EmailPage extends StatefulWidget {
  final String? name;
  final String? bio;
  final String? link;
  final File? image;

  const EmailPage({Key? key, this.name, this.bio, this.link, this.image})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _SignupState();
}

class _SignupState extends State<EmailPage> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _body(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      Container(
        height: 130,
      ),
      Image.asset(
        "assets/thread.png",
        height: 100,
      ),
      Text(
        "Crée ton compte avec ton\nadresse e-mail",
        style: TextStyle(
            color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
      Container(
        height: 30,
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            _entryFeild('Enter email',
                controller: _emailController, isEmail: true),
            _entryFeild('Enter password',
                controller: _passwordController, isPassword: true),
            Container(
              height: MediaQuery.of(context).size.height / 10,
            ),
            _submitButton(context),
          ],
        ),
      )
    ]);
  }

  Widget _entryFeild(String hint,
      {required TextEditingController controller,
      bool isPassword = false,
      bool isEmail = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: TextField(
        keyboardAppearance: Brightness.dark,
        controller: controller,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
        style: const TextStyle(
          color: Colors.white,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.normal,
        ),
        obscureText: isPassword,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0.0),
          labelText: hint,
          hintText: hint,
          labelStyle: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
          ),
          hintStyle: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
          ),
          prefixIcon: Icon(
            Icons.supervised_user_circle,
            color: Colors.white,
            size: 18,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Color.fromARGB(255, 163, 163, 163), width: 1.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
          floatingLabelStyle: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 61, 61, 61), width: 1.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return Container(
        height: 164,
        color: Colors.transparent,
        child: Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 40),
            child: Column(children: [
              Text(
                  "En continuant, tu acceptes notre Politique de\nConfidentialité et nos Conditions Générales\nd'Utilisation.\n",
                  style: TextStyle(
                      color: Color.fromARGB(255, 61, 61, 61),
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RippleButton(
                      splashColor: Colors.transparent,
                      child: Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width - 80,
                          decoration: BoxDecoration(
                            color: _emailController.text.length < 30 &&
                                    _emailController.text.isNotEmpty
                                ? Colors.white
                                : Color.fromARGB(255, 61, 61, 61),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                              child: Text(
                            "Continuer",
                            style: TextStyle(
                                fontFamily: "icons.ttf",
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w800),
                          ))),
                      onPressed: _submitForm),
                ],
              )
            ])));
  }

  void _submitForm() {
    if (_emailController.text.length > 30) {
      Utility.customSnackBar(
          _scaffoldKey, 'Username length cannot exceed 50 character', context);
      return;
    }
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      Utility.customSnackBar(
          _scaffoldKey, 'Please fill form carefully', context);
      return;
    }

    var state = Provider.of<AuthState>(context, listen: false);

    UserModel user = UserModel(
      email: _emailController.text.toLowerCase(),
      displayName: widget.name,
      userName: "@" + "${widget.name}" + "${Random().nextInt(1000)}",
      bio: widget.bio,
      profilePic:
          "https://static.vecteezy.com/system/resources/previews/005/544/718/original/profile-icon-design-free-vector.jpg",
      link: widget.link,
    );
    state.updateUserProfile(
      user,
      image: widget.image,
    );
    state
        .signUp(
      user,
      context,
      password: _passwordController.text,
      scaffoldKey: _scaffoldKey,
    )
        .then((status) {
      print(status);
    }).whenComplete(
      () {
        Future.delayed(const Duration(seconds: 0)).then((_) {
          var state = Provider.of<AuthState>(context, listen: false);
          state.getCurrentUser();
          Navigator.push(
            context,
            MaterialPageRoute(builder: ((context) => PrivacyPage())),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: Container(),
        elevation: 0,
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
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(child: _body(context)),
    );
  }
}
