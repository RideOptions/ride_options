import 'dart:async';

import 'package:firebase_database/firebase_database.dart';

import '../Model/Earning/earning_model.dart';
import '../Model/response_model.dart';

class ActivityService {
  Future<MyResponse> getUserActivities(String uid) async {
    MyResponse myResponse =
        MyResponse(success: false, message: "no data", data: null);
    List<EarningModel> dummyList = [];
    try {
      var event = await FirebaseDatabase.instance
          .ref()
          .child('SaTtAaYz')
          .child("activities")
          .child(uid)
          .once()
          .timeout(Duration(seconds: 30));
      if (event.snapshot.exists) {
        final myActivity = Map<dynamic, dynamic>.from(
            event.snapshot.value as Map<dynamic, dynamic>);

        myActivity.forEach((key, value) {
          EarningModel model = EarningModel.fromMap(value);
          dummyList.add(model);
        });

        print("my activity data is: ${dummyList.length}");

        myResponse.success = true;
        myResponse.data = "my data exit";
        myResponse.data = dummyList;
      }

      return myResponse;
    } on TimeoutException catch (ex) {
      myResponse.message = "TimeoutException";
      return myResponse;
    } catch (ex) {
      print("Exception rideSessionAvailable: $ex");
      myResponse.message = "$ex";
      return myResponse;
    }
  }
}
