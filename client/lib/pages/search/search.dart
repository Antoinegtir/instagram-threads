import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:threads/state/search.state.dart';
import 'package:threads/widget/list.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<SearchState>(context);
    final list = state.userlist;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          centerTitle: false,
          title: Text(
            "Search",
            style: TextStyle(
                color: Colors.white, fontSize: 35, fontWeight: FontWeight.w700),
          ),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black,
            child: ListView(
              children: [
                Container(
                    height: 40,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: TextField(
                        cursorColor: Colors.white,
                        keyboardAppearance: Brightness.dark,
                        onChanged: (value) {
                          state.filterByUsername(value);
                        },
                        style: const TextStyle(color: Colors.white),
                        controller: _textController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Iconsax.search_normal,
                              size: 18, color: Colors.grey),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 0.7),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 0.7),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fillColor: Color.fromARGB(255, 48, 48, 48),
                          filled: true,
                          contentPadding:
                              const EdgeInsets.only(left: 15, top: 5),
                          alignLabelWithHint: true,
                          hintText: 'Search',
                          hintStyle: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                              fontFamily: "arial"),
                        ))),
                Container(
                  height: 20,
                ),
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    addAutomaticKeepAlives: false,
                    itemBuilder: (context, index) {
                      return UserTilePage(
                        user: list![index],
                        isadded: false,
                      );
                    },
                    itemCount: list?.length ?? 0,
                    separatorBuilder: (BuildContext context, int index) {
                      return Padding(
                          padding: EdgeInsets.only(left: 65),
                          child: Container(
                              height: 0.5,
                              color: Color.fromARGB(255, 69, 69, 69),
                              width: MediaQuery.of(context).size.width - 65));
                    },
                  ),
                )
              ],
            )));
  }
}
