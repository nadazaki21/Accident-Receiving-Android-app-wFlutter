import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  List<String> userIDs = []; // List to store all user IDs
  int pointer = 0; // Pointer to track the current user index

  void fetchUserIDs() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users') // Update with your Firestore collection name
          .get();

      final List<String> ids =
          snapshot.docs.map((doc) => doc.get('id') as String).toList();
      setUsers(ids);

      print(userIDs); // for the sake of debugging
    } catch (error) {
      print('Error fetching user IDs: $error');
    }
  }

  void setUsers(List<String> ids) {
    userIDs = ids;
    notifyListeners();
  }

  String getCurrentUserID() {
    if (userIDs.isEmpty) {
      // Return a default value or handle the empty case
      return '';
    }
    return userIDs[pointer];
  }

  // String getCurrentUserID() {
  //   return userIDs[pointer];
  // }

  String moveToNextUser() {
    pointer = (pointer + 1) % userIDs.length;
    notifyListeners();
    print("This is from the moveToNextUser function, the current user is ");
    print(userIDs[pointer]);
    return userIDs[pointer];
  }
}
