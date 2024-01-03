import 'dart:async';
import 'dart:developer';

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
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
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

// this fuction for fetching drivers from firebase base on vihicleType
  Future<MyResponse> getAvailableDrivers(
      String vehicleType, BuildContext context) async {
    // log("vehicleType: $vehicleType");
    List<DriverUserModel> dummyList = [];
    MyResponse myResponse =
        MyResponse(success: false, message: "no data", data: null);

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
          // print("my users ${myUser[myUser.keys.toList()[i]]}");
          final driverDetail = myUser[myUser.keys.toList()[i]];
          DriverUserModel driverUserModel =
              DriverUserModel.fromMap(driverDetail);

          if (driverUserModel.active == true) {
            if (driverUserModel.location != null) {
              if (driverUserModel.location?.lat != "" &&
                  driverUserModel.location?.long != "") {
                double distance = CommonFunctions().calculateDistance(
                    currentPosition!.latitude,
                    currentPosition.longitude,
                    driverUserModel.location!.lat,
                    driverUserModel.location!.long);

                // log("customer lat: ${currentPosition.latitude}");
                // log("customer long: ${currentPosition.longitude}");
                // log("driver lat: ${driverUserModel.location!.lat}");

                // log("active user model data ${driverUserModel.phoneNumber}");
                if (driverUserModel.status == Constant.accountApprovedStatus &&
                    distance < 5) {
                  dummyList.add(driverUserModel);
                  log("driver long: $distance");
                  // log("calling funtion under distance");
                }
              }
            }
          }
        }

        myResponse.success = true;
        myResponse.data = "my data exit";
        myResponse.data = dummyList;
      }

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

// this fuction for fetching drivers from firebase base on vihicleType
  Future<MyResponse> getAvailableCarDrivers(String vehicleType) async {
    List<DriverUserModel> dummyList = [];
    MyResponse myResponse =
        MyResponse(success: false, message: "no data", data: null);

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
          log("getAvailableCarDrivers fuction call ");
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

  // this function for getting ride request

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
        // log("Get Ride Request function calling${myUser}");
        for (var key in myUser.keys) {
          RideRequestModel model = RideRequestModel.fromMap(myUser[key]);
          dummyList.add(model);
          log("getRideRequestAsync function use ${model.price}");
        }

        myResponse.success = true;
        myResponse.data = "my data exists";
        myResponse.data = dummyList;
        log("myResponse:${myResponse.data}");
      }

      return myResponse;
    } on TimeoutException catch (ex) {
      myResponse.message = "TimeoutException $ex";
      return myResponse;
    } catch (ex) {
      print("Exception getAvailableDrivers: $ex");
      myResponse.message = "$ex";
      return myResponse;
    }
  }

// this is my fuction fetching rideRequest from firebase using stream
  StreamController<List<RideRequestModel>> _rideRequestsController =
      StreamController<List<RideRequestModel>>.broadcast();

  Stream<List<RideRequestModel>> get rideRequestsStream =>
      _rideRequestsController.stream;

  void disposeRideRequestsStream() {
    _rideRequestsController.close();
  }

  void listenToRideRequests(String uid) {
    log("listenToRide request call and uid $uid");
    DatabaseReference databaseReference = FirebaseDatabase.instance.ref();

    databaseReference
        .child('SaTtAaYz')
        .child('rideRequest')
        .orderByChild('driverId')
        .equalTo(uid)
        .onValue
        .listen(
      (DatabaseEvent event) {
        try {
          if (event.snapshot.value != null) {
            final dynamic snapshotValue = event.snapshot.value;

            if (snapshotValue is Map<Object?, Object?>) {
              // If the snapshot value is a map, convert it to Map<String, dynamic>
              Map<String, dynamic> data =
                  Map<String, dynamic>.from(snapshotValue);

              List<RideRequestModel> rideRequests = [];
              // log("listenToRide request call and uid ${data}");
              data.forEach((key, value) {
                if (value is Map<String, dynamic>) {
                  RideRequestModel rideRequest =
                      RideRequestModel.fromMap(value);
                  rideRequests.add(rideRequest);
                  log("driver ID: ${rideRequest.driverId}, Price: ${rideRequest.price}");
                }
              });

              // Send the updated list to the stream
              _rideRequestsController.add(rideRequests);
            } else {
              log("Unexpected data format for UID: $uid. Snapshot value: $snapshotValue");
            }
          } else {
            log("Snapshot value is null for UID: $uid");
          }
        } catch (e, stackTrace) {
          log("Error in listenToRideRequests: $e\n$stackTrace");
        }
      },
      onError: (Object? error) {
        log("Error in listenToRideRequests: $error");
      },
      onDone: () {
        log("listenToRideRequests: Done");
      },
      cancelOnError: true,
    );
  }

  // this is my another function to fetching data from
  Stream<List<RideRequestModel>> getRidesRequest(String uid) async* {
    final rideStream = databaseRef
        .child('SaTtAaYz')
        .child('rideRequest')
        .orderByChild('driverId')
        .equalTo(uid)
        .onValue;

    await for (var event in rideStream) {
      if (event.snapshot.value != null) {
        final orderMap = Map<dynamic, dynamic>.from(
            event.snapshot.value as Map<dynamic, dynamic>);

        final orderList = orderMap.entries.map((e) {
          return RideRequestModel.fromMap(Map<dynamic, dynamic>.from(e.value));
        }).toList();

        yield orderList;
      } else {
        yield [];
        log("data not Found");
      }
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
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("SaTtAaYz").child('rideRequest');
    var event = await ref.orderByChild("rideId").equalTo(rideId).once();
    if (event.snapshot.exists) {
      final myRide = Map<dynamic, dynamic>.from(
          event.snapshot.value as Map<dynamic, dynamic>);
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
