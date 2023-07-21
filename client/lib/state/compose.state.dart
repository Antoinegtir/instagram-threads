import 'package:flutter/material.dart';
import 'package:threads/state/search.state.dart';

class ComposePostState extends ChangeNotifier {
  bool showUserList = false;
  bool enableSubmitButton = false;
  bool hideUserList = false;
  String description = "";
  String? serverToken;
  final usernameRegex = r'(@\w*[a-zA-Z1-9]$)';

  bool _isScrollingDown = false;
  bool get isScrollingDown => _isScrollingDown;
  set setIsScrolllingDown(bool value) {
    _isScrollingDown = value;
    notifyListeners();
  }

  bool get displayUserList {
    RegExp regExp = RegExp(usernameRegex);
    var status = regExp.hasMatch(description);
    if (status && !hideUserList) {
      return true;
    } else {
      return false;
    }
  }

  String getDescription(String username) {
    RegExp regExp = RegExp(usernameRegex);
    Iterable<Match> _matches = regExp.allMatches(description);
    var name = description.substring(0, _matches.last.start);
    description = '$name $username';
    return description;
  }

  void onUserSelected() {
    hideUserList = true;
    notifyListeners();
  }

  void onDescriptionChanged(String text, SearchState searchState) {
    description = text;
    hideUserList = false;
    if (text.isEmpty || text.length > 280) {
      enableSubmitButton = false;
      notifyListeners();
      return;
    }

    enableSubmitButton = true;
    var last = text.substring(text.length - 1, text.length);

    RegExp regExp = RegExp(usernameRegex);
    var status = regExp.hasMatch(text);
    if (status) {
      Iterable<Match> _matches = regExp.allMatches(text);
      var name = text.substring(_matches.last.start, _matches.last.end);

      if (last == "@") {
        searchState.filterByUsername("");
      } else {
        searchState.filterByUsername(name);
      }
    } else {
      hideUserList = false;
      notifyListeners();
    }
  }
}
