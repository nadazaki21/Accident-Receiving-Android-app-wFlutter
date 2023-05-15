import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  List<String> userIDs = []; // List to store all user IDs
  int pointer = 0; // Pointer to track the current user index

  void setUsers(List<String> ids) {
    userIDs = ids;
    notifyListeners();
  }

  String getCurrentUserID() {
    return userIDs[pointer];
  }

  void moveToNextUser() {
    pointer = (pointer + 1) % userIDs.length;
    notifyListeners();
  }
}
