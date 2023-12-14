import 'dart:io';

import 'package:firebase_database/firebase_database.dart';

class GlobalService {
  Future<int> getCurrentTime() async {
    int timeStamp = 0;
    await FirebaseDatabase.instance
        .ref()
        .child('SaTtAaYz')
        .child("currentTime")
        .set({"timeStamp": ServerValue.timestamp});
    var event = await FirebaseDatabase.instance
        .ref()
        .child('SaTtAaYz')
        .child("currentTime")
        .once();
    if (event.snapshot.value != null) {
      final myMap = Map<dynamic, dynamic>.from(
          event.snapshot.value as Map<dynamic, dynamic>);
      timeStamp = myMap["timeStamp"];
    }
    return timeStamp;
  }

  Future<String> getChatId(String uid1, String uid2) async {
    int compare = uid1.compareTo(uid2);
    print(compare);
    String chatId;

    if (compare == 1) {
      chatId = "$uid1-$uid2";
    } else {
      chatId = "$uid2-$uid1";
    }
    return chatId;
  }

  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      print('not connected');
      return false;
    }
  }
}
