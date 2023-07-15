import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:threads/auth/signup/name.dart';
import 'package:threads/helper/enum.dart';
import 'package:threads/state/auth.state.dart';
import 'package:threads/pages/home.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timer();
    });
    super.initState();
  }

  bool isAppUpdated = true;

  void timer() async {
    if (isAppUpdated) {
      Future.delayed(const Duration(seconds: 1)).then((_) {
        var state = Provider.of<AuthState>(context, listen: false);
        state.getCurrentUser();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthState>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: state.authStatus == AuthStatus.NOT_LOGGED_IN
          ? const NamePage()
          : HomePage(),
    );
  }
}
