import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../Screens/HomePage/NavBarPages/Ride/driver_live_tracking_page.dart';
import '../Dialogue/app_dialogue.dart';
import '../Model/Authentication/driver_user_model.dart';
import '../Model/Authentication/location.dart';
import '../Model/Authentication/user_model.dart';
import '../Model/Earning/earning_model.dart';
import '../Model/Ride/ride_model.dart';
import '../Model/Ride/ride_request_model.dart';
import '../Model/Vehicle/vehicle_rate.dart';
import '../Model/response_model.dart';
import '../Services/global_service.dart';
import '../Services/ride_service.dart';
import '../common_function.dart';
import '../constant.dart';

class RideProvider with ChangeNotifier {
  List<VehicleRateModel> vehicleRateList = [];

  List<VehicleRateModel> get getVehicleRateList => vehicleRateList;

  void setVehicleRateList(List<VehicleRateModel> value) {
    vehicleRateList = value;
    notifyListeners();
  }

  List<RideRequestModel> rideRequestList = [];

  List<RideRequestModel> get getRideRequestList => rideRequestList;

  void setRideRequestList(List<RideRequestModel> value) {
    rideRequestList = value;
    notifyListeners();
  }

  RideModel? rideModel;

  RideModel? get getRideModel => rideModel;

  void setRideModel(RideModel? value) {
    rideModel = value;
    notifyListeners();
  }

  String? rideId;

  String? get getRideId => rideId;

  void setRideId(String? value) {
    rideId = value;
    notifyListeners();
  }

  getVehicleRateListMethod() async {
    MyResponse response = await RideService().getVehiclesRate();
    if (response.success) {
      List<VehicleRateModel> dummyList = [];
      dummyList = response.data as List<VehicleRateModel>;
      if (dummyList.isNotEmpty) {
        setVehicleRateList(dummyList);
      }
    }
  }

  // this function for creating ride request

  createRideRequest(
      {required LocationModel sourceLocation,
      required LocationModel destinationModel,
      required int price,
      required String vehicleType,
      required String uid,
      required BuildContext context}) async {
    MyResponse result =
        MyResponse(success: false, message: "no data", data: null);
    // showSnackBar(context,
    //     "vehicleType "+vehicleType);

    if (vehicleType == Constant.bikeVehicleType ||
        vehicleType == Constant.RickshawVehicleType ||
        vehicleType == Constant.miniVehicleType ||
        vehicleType == Constant.rideGoVehicleType ||
        vehicleType == Constant.rideXVehicleType) {
      result = await RideService().getAvailableDrivers(vehicleType, context);
    } else {
      result = await RideService().getAvailableCarDrivers(vehicleType);
    }

    // showSnackBar(context,
    //     "result is: ${result.success}");

    print("result is: ${result.success}");
    if (result.success) {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("SaTtAaYz").child('rideRequest');
      DatabaseReference ref2 =
          FirebaseDatabase.instance.ref("SaTtAaYz").child('ride');
      String? rideId = ref2.push().key;
      List<DriverUserModel> dummyList = result.data as List<DriverUserModel>;
      print("driver request list ${dummyList.length}");
      if (dummyList.isNotEmpty) {
        int currentTimeStamp = await GlobalService().getCurrentTime();
        for (int i = 0; i < dummyList.length; i++) {
          String? nodeKey = ref.push().key;
          RideRequestModel requestModel = RideRequestModel(
              id: nodeKey,
              driverId: dummyList[i].uid,
              rideId: rideId,
              rideType: vehicleType,
              sourceLocation: sourceLocation,
              destinationLocation: destinationModel,
              price: price,
              timeStamp: currentTimeStamp);
          await ref.child(nodeKey!).set(requestModel.toMap());
        }

        RideModel rideModel = RideModel(
            id: rideId,
            acceptedBy: null,
            vehicleType: vehicleType,
            customerId: uid,
            sourceLocation: sourceLocation,
            destinationLocation: destinationModel,
            driverLocation: null,
            status: Constant.ridePendingStatus,
            price: price,
            timeStamp: currentTimeStamp);
        await ref2.child(rideId!).set(rideModel.toMap());
        setRideId(rideId);
        RideService().listenRideNode(rideId);
      }
    }
  }

// this fuction for cancel Ride Request
  cancelRideRequest() async {
    if (rideId != null) {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("SaTtAaYz").child('rideRequest');
      DatabaseReference ref2 =
          FirebaseDatabase.instance.ref("SaTtAaYz").child('ride');

      await ref2.child(rideId!).remove();

      var event = await ref.orderByChild("rideId").equalTo(rideId!).once();

      if (event.snapshot.exists) {
        final myRide = Map<dynamic, dynamic>.from(
            event.snapshot.value as Map<dynamic, dynamic>);

        for (var entry in myRide.entries) {
          dynamic value = entry.value;

          RideRequestModel model = RideRequestModel.fromMap(value);
          await ref.child(model.id!).remove();
        }
      }
    }
  }

// this fuction for get Ride Request
  getRideRequestMethod({required String uid}) async {
    MyResponse response = await RideService().getRideRequestAsync(uid);
    if (response.success) {
      List<RideRequestModel> dummyList =
          response.data as List<RideRequestModel>;
      if (dummyList.isNotEmpty) {
        setRideRequestList(dummyList);
        print("ride list length: ${rideRequestList.length}");
      } else {
        rideRequestList = [];
      }
    } else {
      rideRequestList = [];
    }
    notifyListeners();
  }

  acceptRideRequestMethod(
      {required BuildContext context,
      required RideRequestModel requestModel,
      required String uid}) async {
    try {
      LocationModel? location;
      bool isPending =
          await RideService().checkRideRequestPending(requestModel.rideId!);
      Position? currentLocation = await CommonFunctions().getCurrentLocation();
      if (currentLocation != null) {
        String? address =
            await CommonFunctions().GetAddressFromLatLong(currentLocation);
        location = LocationModel(
            lat: currentLocation.latitude,
            long: currentLocation.longitude,
            location: address);
      }
      print("pending status: $isPending");
      if (isPending) {
        await RideService().updateRideRequestStatus(
            Constant.rideAcceptStatus, requestModel.rideId!, uid, location);
        await RideService().removeRideRequest(requestModel.rideId!);
        MyResponse response =
            await RideService().getRideDetails(requestModel.rideId!);
        if (response.success) {
          RideModel rideModel = response.data as RideModel;
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    DriverLiveTrackingPage(rideModel: rideModel)),
          );
        }

        // rideRequestList.remove(requestModel);
      } else {
        await getRideRequestMethod(uid: uid);
        notifyListeners();
        Navigator.pop(context);
        await showDialog(
          context: context,
          builder: (ctx) => AppDialogue(
            title: "Attention",
            description:
                "This request has already been accepted by another driver. Please await the next ride opportunity.",
            cancelBtnVisible: false,
            confirmBthText: "OK",
          ),
        );
      }
    } catch (ex) {}
  }

  rideCompletedMethod(
      {required RideModel rideModel, required UserModel userDetail}) async {
    try {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("SaTtAaYz").child('earning');
      DatabaseReference ref2 =
          FirebaseDatabase.instance.ref("SaTtAaYz").child('activities');
      DatabaseReference ref3 =
          FirebaseDatabase.instance.ref("SaTtAaYz").child('ride');
      DatabaseReference ref4 =
          FirebaseDatabase.instance.ref("SaTtAaYz").child('messages');
      String? nodeKey = ref.push().key;
      await RideService()
          .updateRideStatus(Constant.rideCompletedStatus, rideModel.id!);
      int? currentTime = await GlobalService().getCurrentTime();
      String chatId = await GlobalService()
          .getChatId(rideModel.customerId!, rideModel.acceptedBy!);
      EarningModel earningModel = EarningModel(
          id: nodeKey,
          driverId: userDetail.uid,
          rideId: rideModel.id,
          customerId: rideModel.customerId,
          price: rideModel.price,
          status: Constant.rideCompletedStatus,
          vehicleType: userDetail.vehicleType,
          pickedUpLocation: rideModel.sourceLocation,
          destinationLocation: rideModel.destinationLocation,
          startTime: rideModel.timeStamp,
          endTime: currentTime);
      await ref.child(nodeKey!).set(earningModel.toMap());
      await ref.child(nodeKey!).set(earningModel.toMap());
      await ref2
          .child(userDetail.uid!)
          .child(nodeKey)
          .set(earningModel.toMap());
      await ref2
          .child(rideModel.customerId!)
          .child(nodeKey)
          .set(earningModel.toMap());
      await ref3.child(rideModel.id!).remove();
      await ref4.child(chatId).remove();
    } catch (ex) {
      print("Exception rideCompletedMethod:$ex");
    }
  }
}
