import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class MemoriesPage extends StatelessWidget {
  const MemoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        title: FadeInRight(
            duration: Duration(milliseconds: 300),
            child: Text(
              "Memories",
              style: TextStyle(color: Colors.white),
            )),
        backgroundColor: Colors.black,
      ),
    );
  }
}
