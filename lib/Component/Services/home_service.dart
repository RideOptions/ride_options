import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import '../Model/Authentication/location.dart';
import '../Model/response_model.dart';

class HomeService {
  updateRideRequestStatus(
      String uid, List<LocationModel> suggestionList) async {
    DatabaseReference ref = FirebaseDatabase.instance
        .ref("SaTtAaYz")
        .child('Suggestion')
        .child(uid);
    await ref.remove();
    suggestionList.forEach((element) async {
      String? nodeKey = ref.push().key;
      if (nodeKey != null) {
        await ref.child(nodeKey).set(element.toMap());
      }
    });
  }

  Future<MyResponse> getUserSuggestions(String uid) async {
    MyResponse myResponse =
    MyResponse(success: false, message: "no data", data: null);
    List<LocationModel> dummyList = [];
    try {
      var event = await FirebaseDatabase.instance
          .ref()
          .child('SaTtAaYz')
          .child("suggestion")
          .child(uid)
          .once()
          .timeout(Duration(seconds: 30));
      if (event.snapshot.exists) {
        final mySuggestion = Map<dynamic, dynamic>.from(
            event.snapshot.value as Map<dynamic, dynamic>);
        print("mySuggestion map $mySuggestion");
        mySuggestion.forEach((key, value) {
          LocationModel model = LocationModel.fromMap(value);
          print("LocationModel: $model");
          dummyList.add(model);
        });

        print("my Suggestion data is: ${dummyList.length}");

        myResponse.success = true;
        myResponse.data = "my data exit";
        myResponse.data = dummyList;
      }

      return myResponse;
    } on TimeoutException catch (ex) {
      myResponse.message = "TimeoutException";
      return myResponse;
    } catch (ex) {
      print("Exception userSuggestion: $ex");
      myResponse.message = "$ex";
      return myResponse;
    }
  }
}