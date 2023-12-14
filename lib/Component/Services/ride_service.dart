import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../Screens/HomePage/NavBarPages/Ride/customer_live_tracking_page.dart';
import '../Model/Authentication/driver_user_model.dart';
import '../Model/Authentication/location.dart';
import '../Model/Ride/ride_model.dart';
import '../Model/Ride/ride_request_model.dart';
import '../Model/Vehicle/vehicle_rate.dart';
import '../Model/response_model.dart';
import '../Provider/ride_provider.dart';
import '../common_function.dart';
import '../constant.dart';

class RideService {
  StreamSubscription? rideSteam;

  Future<MyResponse> getVehiclesRate() async {
    MyResponse myResponse =
        MyResponse(success: false, message: "no data", data: null);
    List<VehicleRateModel> dummyList = [];
    try {
      var event = await FirebaseDatabase.instance
          .ref()
          .child('SaTtAaYz')
          .child("metadata")
          .child("rates")
          .once()
          .timeout(Duration(seconds: 20));
      if (event.snapshot.value != null) {
        final myVehicleRate = Map<dynamic, dynamic>.from(
            event.snapshot.value as Map<dynamic, dynamic>);

        for (var key in myVehicleRate.keys) {
          var value = myVehicleRate[key];
          VehicleRateModel vehicleRate = VehicleRateModel.fromMap(value);
          print("vehicle model: ${vehicleRate.toMap()}");
          dummyList.add(vehicleRate);
        }

        if (dummyList.isNotEmpty) {
          myResponse.success = true;
          myResponse.message = "data found!";
          myResponse.data = dummyList;
        }
      }

      return myResponse;
    } on TimeoutException catch (e) {
      myResponse.message = "TimeoutException";

      return myResponse;
    } catch (ex) {
      print("Exception checkUserAlreadyRegister: $ex");
      myResponse.message = "$ex";
      return myResponse;
    }
  }

  Future<MyResponse> getAvailableDrivers(
      String vehicleType, BuildContext context) async {
    List<DriverUserModel> dummyList = [];
    MyResponse myResponse =
        MyResponse(success: false, message: "no data", data: null);
    print("vehicle type is: $vehicleType");
    try {
      var event = await FirebaseDatabase.instance
          .ref()
          .child('SaTtAaYz')
          .child("driverUsers")
          .orderByChild("vehicleType")
          .equalTo(vehicleType)
          .once()
          .timeout(Duration(seconds: 30));
      if (event.snapshot.exists) {
        final myUser = Map<dynamic, dynamic>.from(
            event.snapshot.value as Map<dynamic, dynamic>);

        Position? currentPosition =
            await CommonFunctions().getCurrentLocation();

        for (int i = 0; i < myUser.length; i++) {
          print("my users ${myUser[myUser.keys.toList()[i]]}");
          final driverDetail = myUser[myUser.keys.toList()[i]];
          DriverUserModel driverOrder = DriverUserModel.fromMap(driverDetail);
          print("driver model: ${driverOrder.toMap()}");
          if (driverOrder.active == true) {

            if (driverOrder.location != null) {
              if (driverOrder.location?.lat != "" &&
                  driverOrder.location?.long != "") {
                double distance = CommonFunctions().calculateDistance(
                    currentPosition!.latitude,
                    currentPosition.longitude,
                    driverOrder.location!.lat,
                    driverOrder.location!.long);
                print("distance in km: $distance");
                print("active ${driverOrder.active}");
                if (driverOrder.status == Constant.accountApprovedStatus &&
                    distance < 5) {
                  dummyList.add(driverOrder);
                }
              }
            }
          }
        }



        myResponse.success = true;
        myResponse.data = "my data exit";
        myResponse.data = dummyList;
      }

      print("my response ${dummyList.length}");

      // showSnackBar(context,
      //     "my response ${dummyList.length}");

      return myResponse;
    } on TimeoutException catch (ex) {
      myResponse.message = "TimeoutException";
      // showSnackBar(context,
      //     "TimeoutException ${ex.message}");
      return myResponse;
    } catch (ex, st) {
      print("Exception getAvailableDrivers: $ex | StackTrace: $st");
      // showSnackBar(context,
      //     "Exception getAvailableDrivers: $ex | StackTrace: $st");
      myResponse.message = "$ex";
      return myResponse;
    }
  }

  Future<MyResponse> getAvailableCarDrivers(String vehicleType) async {
    List<DriverUserModel> dummyList = [];
    MyResponse myResponse =
        MyResponse(success: false, message: "no data", data: null);
    print("vehicle type is: $vehicleType");
    try {
      var event = await FirebaseDatabase.instance
          .ref()
          .child('SaTtAaYz')
          .child("driverUsers")
          .orderByChild(vehicleType)
          .equalTo(true)
          .once()
          .timeout(Duration(seconds: 30));
      if (event.snapshot.exists) {
        final myUser = Map<dynamic, dynamic>.from(
            event.snapshot.value as Map<dynamic, dynamic>);

        for (int i = 0; i < myUser.length; i++) {
          print("my users ${myUser[myUser.keys.toList()[i]]}");
          final driverDetail = myUser[myUser.keys.toList()[i]];
          DriverUserModel driverOrder = DriverUserModel.fromMap(driverDetail);
          print("driver model: ${driverOrder.toMap()}");
          if (driverOrder.active == true) {
            Position? currentPosition =
                await CommonFunctions().getCurrentLocation();
            double distance = CommonFunctions().calculateDistance(
                currentPosition!.latitude,
                currentPosition.longitude,
                driverOrder.location!.lat,
                driverOrder.location!.long);
            print("distance in km: $distance");
            print("active ${driverOrder.active}");
            if (driverOrder.status == Constant.accountApprovedStatus &&
                distance < 5) {
              dummyList.add(driverOrder);
            }
          }
        }


        myResponse.success = true;
        myResponse.data = "my data exit";
        myResponse.data = dummyList;
      }

      print("my response ${dummyList.length}");
      return myResponse;
    } on TimeoutException catch (ex) {
      myResponse.message = "TimeoutException";
      return myResponse;
    } catch (ex) {
      print("Exception getAvailableDrivers: $ex");
      myResponse.message = "$ex";
      return myResponse;
    }
  }

  Future<MyResponse> rideSessionAvailable(String uid) async {
    MyResponse myResponse =
        MyResponse(success: false, message: "no data", data: null);
    try {
      var event = await FirebaseDatabase.instance
          .ref()
          .child('SaTtAaYz')
          .child("ride")
          .orderByChild("customerId")
          .equalTo(uid)
          .once()
          .timeout(Duration(seconds: 30));
      if (event.snapshot.exists) {
        final myUser = Map<dynamic, dynamic>.from(
            event.snapshot.value as Map<dynamic, dynamic>);

        RideModel model = RideModel.fromMap(myUser.values.first);

        myResponse.success = true;
        myResponse.data = "my data exit";
        myResponse.data = model;
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

  listenRideNode(String rideId) {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("SaTtAaYz").child('ride');
    rideSteam = ref.child(rideId).onValue.listen((event) {
      print("onValue listen call");
      if (event.snapshot.exists) {
        final myRide = Map<dynamic, dynamic>.from(
            event.snapshot.value as Map<dynamic, dynamic>);
        RideModel rideModel = RideModel.fromMap(myRide);
        Provider.of<RideProvider>(Constant.navState.currentContext!,
                listen: false)
            .setRideModel(rideModel);
        if (rideModel.status == Constant.rideAcceptStatus &&
            rideModel.acceptedBy != null) {
          rideSteam?.cancel();
          Constant.navState.currentState?.pushReplacement(
            MaterialPageRoute(
                builder: (context) => CustomerLiveTrackingPage(
                      rideModel: rideModel,
                    )),
          );
        }
      }
    });
  }

  updateRideStatus(String status, String rideId) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("SaTtAaYz").child('ride');
    await ref.child(rideId).update({
      "status": status,
    });
  }

  Future<MyResponse> getRideRequestAsync(String uid) async {
    List<RideRequestModel> dummyList = [];
    MyResponse myResponse =
        MyResponse(success: false, message: "no data", data: null);
    try {
      var event = await FirebaseDatabase.instance
          .ref()
          .child('SaTtAaYz')
          .child("rideRequest")
          .orderByChild("driverId")
          .equalTo(uid)
          .once()
          .timeout(Duration(seconds: 30));
      if (event.snapshot.exists) {
        final myUser = Map<dynamic, dynamic>.from(
            event.snapshot.value as Map<dynamic, dynamic>);


        for (var key in myUser.keys) {
          RideRequestModel model = RideRequestModel.fromMap(myUser[key]);
          dummyList.add(model);
        }

        myResponse.success = true;
        myResponse.data = "my data exists";
        myResponse.data = dummyList;
      }


      return myResponse;
    } on TimeoutException catch (ex) {
      myResponse.message = "TimeoutException";
      return myResponse;
    } catch (ex) {
      print("Exception getAvailableDrivers: $ex");
      myResponse.message = "$ex";
      return myResponse;
    }
  }

  Future<bool> checkRideRequestPending(String rideId) async {
    bool rideRequestPending = false;
    try {
      var event = await FirebaseDatabase.instance
          .ref()
          .child('SaTtAaYz')
          .child("ride")
          .child(rideId)
          .once();
      if (event.snapshot.exists) {
        final myRequest = Map<dynamic, dynamic>.from(
            event.snapshot.value as Map<dynamic, dynamic>);
        RideModel model = RideModel.fromMap(myRequest);
        if (model.status == Constant.ridePendingStatus) {
          rideRequestPending = true;
        } else {
          rideRequestPending = false;
        }
      }
      return rideRequestPending;
    } catch (ex) {
      print("Exception getRideRequestAsync: $ex");
      return false;
    }
  }

  updateRideRequestStatus(String status, String rideId, String uid,
      LocationModel? locationModel) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("SaTtAaYz").child('ride');
    await ref.child(rideId).update({
      "acceptedBy": uid,
      "status": status,
      "driverLocation": locationModel?.toMap(),
    });
  }

  removeRideRequest(String rideId) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("SaTtAaYz").child('rideRequest');
    var event = await ref.orderByChild("rideId").equalTo(rideId).once();
    if (event.snapshot.exists) {
      final myRide = Map<dynamic, dynamic>.from(event.snapshot.value as Map<dynamic, dynamic>);
      for (var entry in myRide.entries) {
        RideRequestModel model = RideRequestModel.fromMap(entry.value);
        await ref.child(model.id!).remove();
      }
    }
  }


  Future<MyResponse> rideDriverSessionAvailable(String uid) async {
    MyResponse myResponse =
        MyResponse(success: false, message: "no data", data: null);
    try {
      var event = await FirebaseDatabase.instance
          .ref()
          .child('SaTtAaYz')
          .child("ride")
          .orderByChild("acceptedBy")
          .equalTo(uid)
          .once()
          .timeout(Duration(seconds: 30));
      if (event.snapshot.exists) {
        final myUser = Map<dynamic, dynamic>.from(
            event.snapshot.value as Map<dynamic, dynamic>);

        RideModel model = RideModel.fromMap(myUser.values.first);

        myResponse.success = true;
        myResponse.data = "my data exit";
        myResponse.data = model;
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

  Future<MyResponse> getRideDetails(String rideId) async {
    MyResponse myResponse =
        MyResponse(success: false, message: "no data", data: null);
    try {
      var event = await FirebaseDatabase.instance
          .ref()
          .child('SaTtAaYz')
          .child("ride")
          .child(rideId)
          .once()
          .timeout(Duration(seconds: 30));
      if (event.snapshot.exists) {
        final myUser = Map<dynamic, dynamic>.from(
            event.snapshot.value as Map<dynamic, dynamic>);

        RideModel model = RideModel.fromMap(myUser);

        myResponse.success = true;
        myResponse.data = "my data exit";
        myResponse.data = model;
      }

      return myResponse;
    } on TimeoutException catch (ex) {
      myResponse.message = "TimeoutException";
      return myResponse;
    } catch (ex) {
      print("Exception getRideDetails: $ex");
      myResponse.message = "$ex";
      return myResponse;
    }
  }

  updateRideDriverLocationStatus(
      String rideId, LocationModel driverLocation) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("SaTtAaYz").child('ride');
    await ref.child(rideId).update({
      "driverLocation": driverLocation.toMap(),
    });
  }
}
