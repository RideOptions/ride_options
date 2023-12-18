import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rideoptions/helper/colors.dart';

import '../../../../Component/Common_Widget/button_widget.dart';
import '../../../../Component/Dialogue/acitivity_indicator_dialogue.dart';
import '../../../../Component/Dialogue/app_dialogue.dart';
import '../../../../Component/Model/Authentication/location.dart';
import '../../../../Component/Model/Authentication/user_model.dart';
import '../../../../Component/Model/Ride/ride_model.dart';
import '../../../../Component/Provider/ride_provider.dart';
import '../../../../Component/Services/local_service.dart';
import '../../../../Component/common_function.dart';
import '../../../../Component/constant.dart';
import '../../../../Component/theme/app_theme.dart';
import '../../../../Component/theme/text_style_theme.dart';
import '../../BottomNavBar/customer_nav_bar_page.dart';

// ignore: must_be_immutable
class RideCategoryPage extends StatefulWidget {
  LocationModel pickupLocation;
  LocationModel destinationLocation;
  bool? driverFinding;
  RideModel? rideModel;

  RideCategoryPage(
      {required this.pickupLocation,
      required this.destinationLocation,
      this.driverFinding = false,
      this.rideModel});

  @override
  State<RideCategoryPage> createState() => _RideCategoryPageState();
}

class _RideCategoryPageState extends State<RideCategoryPage> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  String? selectedVehicle;
  CameraPosition? _kGooglePlex;
  LatLng? sourceLocation;
  LatLng? destinationLocation;
  List<LatLng> polylineCoordinates = [];
  double? distance;
  int bikePrice = 0;
  int RickshawPrice = 0;
  int miniPrice = 0;
  int goPrice = 0;
  int rideXPrice = 0;
  RideProvider? rideProvider;
  bool selectVehicleErrorVisible = false;
  int? selectedPrice;
  UserModel? userDetail;
  bool findDriver = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      initializeComponent();
    });
  }

  @override
  Widget build(BuildContext context) {
    // this function for rideRequest Terminator
    (!findDriver)
        ? null
        : Future.delayed(Duration(seconds: 90)).then((value) {
            cancelButtonClicked();
          });

    AppLifecycleListener(
      onResume: () {
        cancelButtonClicked();
      },
      onHide: () {
        cancelButtonClicked();
      },
      onInactive: () {
        cancelButtonClicked();
      },
      onPause: () {
        cancelButtonClicked();
      },
      onDetach: () {
        cancelButtonClicked();
      },
      onRestart: () {
        cancelButtonClicked();
      },
    );

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: WillPopScope(
          onWillPop: onWillPop,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  child: (sourceLocation != null)
                      ? Stack(
                          children: [
                            GoogleMap(
                              mapType: MapType.normal,
                              initialCameraPosition: CameraPosition(
                                target: sourceLocation!,
                                zoom: 12,
                              ),
                              // onMapCreated: (GoogleMapController controller) {
                              //   _controller.complete(controller);
                              // },
                              polylines: {
                                Polyline(
                                  polylineId: PolylineId("ride"),
                                  points: polylineCoordinates,
                                  color: Colors.blue,
                                  width: 6,
                                ),
                              },
                              markers: {
                                Marker(
                                  markerId: MarkerId("sourceLocation"),
                                  position: sourceLocation!,
                                ),
                                Marker(
                                  markerId: MarkerId("destinationLocation"),
                                  position: destinationLocation!,
                                ),
                              },
                            ),
                            (findDriver)
                                ? Align(
                                    alignment: Alignment.center,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.5),
                                        image: new DecorationImage(
                                            fit: BoxFit.cover,
                                            colorFilter: ColorFilter.mode(
                                                Colors.black.withOpacity(0.7),
                                                BlendMode.dstATop),
                                            image: AssetImage(
                                                "assets/images/map_pin.gif")),
                                      ),
                                    )
                                    // Image.asset("assets/images/map_pin.gif",width: 80,),
                                    )
                                : Container(),
                          ],
                        )
                      : Center(
                          child: Text("Loading....."),
                        ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                      child: Text(
                    "",
                    style: blackTextRegularIn12px(),
                  ))),
              Expanded(
                flex: 6,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 0.0,
                          mainAxisSpacing: 0.0,
                          children: [
                            // this portion for motor bike
                            GestureDetector(
                              onTap: () {
                                if (bikePrice == 0) {
                                  return;
                                } else {
                                  if (selectedVehicle == "MotorBike") {
                                    selectedVehicle = null;
                                    selectedPrice = null;
                                  } else {
                                    selectedVehicle = "MotorBike";
                                    selectedPrice = bikePrice;
                                  }
                                  setState(() {});
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: (selectedVehicle != null &&
                                          selectedVehicle == "MotorBike")
                                      ? primaryColor
                                      : Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade500,
                                      offset: const Offset(
                                        0.0,
                                        1.0,
                                      ),
                                      blurRadius: 1.0,
                                      spreadRadius: 1.0,
                                    ), //BoxShadow
                                    BoxShadow(
                                      color: Colors.white,
                                      offset: const Offset(0.0, 0.0),
                                      blurRadius: 0.0,
                                      spreadRadius: 0.0,
                                    ), //BoxShadow
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/bike_icon.png",
                                      width: size.width * 0.27,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Motor Bike",
                                          style: (selectedVehicle != null &&
                                                  selectedVehicle ==
                                                      "MotorBike")
                                              ? whiteTextRegularIn16px()
                                              : blackTextBoldIn16px(),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Icon(
                                          Icons.person,
                                          color: (selectedVehicle != null &&
                                                  selectedVehicle ==
                                                      "MotorBike")
                                              ? Colors.white
                                              : primaryColor,
                                          size: 20,
                                        ),
                                        Text(
                                          "1",
                                          style: (selectedVehicle != null &&
                                                  selectedVehicle ==
                                                      "MotorBike")
                                              ? whiteTextRegularIn16px()
                                              : blackTextBoldIn16px(),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "PKR $bikePrice",
                                      style: (selectedVehicle != null &&
                                              selectedVehicle == "MotorBike")
                                          ? whiteTextRegularIn16px()
                                          : blackTextBoldIn16px(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // this portion for rickshaw
                            GestureDetector(
                              onTap: () {
                                if (RickshawPrice == 0) {
                                  return;
                                } else {
                                  if (selectedVehicle == "Rickshaw") {
                                    selectedVehicle = null;
                                    selectedPrice = null;
                                  } else {
                                    selectedVehicle = "Rickshaw";
                                    selectedPrice = RickshawPrice;
                                  }
                                  setState(() {});
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: (selectedVehicle != null &&
                                          selectedVehicle == "Rickshaw")
                                      ? primaryColor
                                      : Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade500,
                                      offset: const Offset(
                                        0.0,
                                        1.0,
                                      ),
                                      blurRadius: 1.0,
                                      spreadRadius: 1.0,
                                    ), //BoxShadow
                                    BoxShadow(
                                      color: Colors.white,
                                      offset: const Offset(0.0, 0.0),
                                      blurRadius: 0.0,
                                      spreadRadius: 0.0,
                                    ), //BoxShadow
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/rickshaw_icon.png",
                                      width: size.width * 0.20,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Rickshaw",
                                          style: (selectedVehicle != null &&
                                                  selectedVehicle == "Rickshaw")
                                              ? whiteTextRegularIn16px()
                                              : blackTextBoldIn16px(),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Icon(
                                          Icons.person,
                                          color: (selectedVehicle != null &&
                                                  selectedVehicle == "Rickshaw")
                                              ? Colors.white
                                              : primaryColor,
                                          size: 20,
                                        ),
                                        Text(
                                          "3",
                                          style: (selectedVehicle != null &&
                                                  selectedVehicle == "Rickshaw")
                                              ? whiteTextRegularIn16px()
                                              : blackTextBoldIn16px(),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "PKR $RickshawPrice",
                                      style: (selectedVehicle != null &&
                                              selectedVehicle == "Rickshaw")
                                          ? whiteTextRegularIn16px()
                                          : blackTextBoldIn16px(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            // this portion for mini car
                            GestureDetector(
                              onTap: () {
                                if (miniPrice == 0) {
                                  return;
                                } else {
                                  if (selectedVehicle == "Mini") {
                                    selectedVehicle = null;
                                    selectedPrice = null;
                                  } else {
                                    selectedVehicle = "Mini";
                                    selectedPrice = miniPrice;
                                  }
                                  setState(() {});
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: (selectedVehicle != null &&
                                          selectedVehicle == "Mini")
                                      ? primaryColor
                                      : Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade500,
                                      offset: const Offset(
                                        0.0,
                                        1.0,
                                      ),
                                      blurRadius: 1.0,
                                      spreadRadius: 1.0,
                                    ), //BoxShadow
                                    BoxShadow(
                                      color: Colors.white,
                                      offset: const Offset(0.0, 0.0),
                                      blurRadius: 0.0,
                                      spreadRadius: 0.0,
                                    ), //BoxShadow
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/mini_icon.png",
                                      width: size.width * 0.30,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Mini",
                                          style: (selectedVehicle != null &&
                                                  selectedVehicle == "Mini")
                                              ? whiteTextRegularIn16px()
                                              : blackTextBoldIn16px(),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Icon(
                                          Icons.person,
                                          color: (selectedVehicle != null &&
                                                  selectedVehicle == "Mini")
                                              ? Colors.white
                                              : primaryColor,
                                          size: 20,
                                        ),
                                        Text(
                                          "4",
                                          style: (selectedVehicle != null &&
                                                  selectedVehicle == "Mini")
                                              ? whiteTextRegularIn16px()
                                              : blackTextBoldIn16px(),
                                        )
                                      ],
                                    ),
                                    Text(
                                      "PKR $miniPrice",
                                      style: (selectedVehicle != null &&
                                              selectedVehicle == "Mini")
                                          ? whiteTextRegularIn16px()
                                          : blackTextBoldIn16px(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            // this portion for ride go
                            GestureDetector(
                              onTap: () {
                                if (goPrice == 0) {
                                  return;
                                } else {
                                  if (selectedVehicle == "RideGo") {
                                    selectedVehicle = null;
                                    selectedPrice = null;
                                  } else {
                                    selectedVehicle = "RideGo";
                                    selectedPrice = goPrice;
                                  }
                                  setState(() {});
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: (selectedVehicle != null &&
                                          selectedVehicle == "RideGo")
                                      ? primaryColor
                                      : Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade500,
                                      offset: const Offset(
                                        0.0,
                                        1.0,
                                      ),
                                      blurRadius: 1.0,
                                      spreadRadius: 1.0,
                                    ), //BoxShadow
                                    BoxShadow(
                                      color: Colors.white,
                                      offset: const Offset(0.0, 0.0),
                                      blurRadius: 0.0,
                                      spreadRadius: 0.0,
                                    ), //BoxShadow
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/wagnor.png",
                                      height: 70,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "RideGo",
                                          style: (selectedVehicle != null &&
                                                  selectedVehicle == "RideGo")
                                              ? whiteTextRegularIn16px()
                                              : blackTextBoldIn16px(),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Icon(
                                          Icons.person,
                                          color: (selectedVehicle != null &&
                                                  selectedVehicle == "RideGo")
                                              ? Colors.white
                                              : primaryColor,
                                          size: 20,
                                        ),
                                        Text(
                                          "4",
                                          style: (selectedVehicle != null &&
                                                  selectedVehicle == "RideGo")
                                              ? whiteTextRegularIn16px()
                                              : blackTextBoldIn16px(),
                                        )
                                      ],
                                    ),
                                    Text(
                                      "PKR $goPrice",
                                      style: (selectedVehicle != null &&
                                              selectedVehicle == "RideGo")
                                          ? whiteTextRegularIn16px()
                                          : blackTextBoldIn16px(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            // this portion for Ride X
                            GestureDetector(
                              onTap: () {
                                if (rideXPrice == 0) {
                                  return;
                                } else {
                                  if (selectedVehicle == "RideX") {
                                    selectedVehicle = null;
                                    selectedPrice = null;
                                  } else {
                                    selectedVehicle = "RideX";
                                    selectedPrice = rideXPrice;
                                  }
                                  setState(() {});
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: (selectedVehicle != null &&
                                          selectedVehicle == "RideX")
                                      ? primaryColor
                                      : Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade500,
                                      offset: const Offset(
                                        0.0,
                                        1.0,
                                      ),
                                      blurRadius: 1.0,
                                      spreadRadius: 1.0,
                                    ), //BoxShadow
                                    BoxShadow(
                                      color: Colors.white,
                                      offset: const Offset(0.0, 0.0),
                                      blurRadius: 0.0,
                                      spreadRadius: 0.0,
                                    ), //BoxShadow
                                  ],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                ),
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/rideGo_icon.png",
                                      height: 75,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Ride X",
                                          style: (selectedVehicle != null &&
                                                  selectedVehicle == "RideX")
                                              ? whiteTextRegularIn16px()
                                              : blackTextBoldIn16px(),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Icon(
                                          Icons.person,
                                          color: (selectedVehicle != null &&
                                                  selectedVehicle == "RideX")
                                              ? Colors.white
                                              : primaryColor,
                                          size: 20,
                                        ),
                                        Text(
                                          "4",
                                          style: (selectedVehicle != null &&
                                                  selectedVehicle == "RideX")
                                              ? whiteTextRegularIn16px()
                                              : blackTextBoldIn16px(),
                                        )
                                      ],
                                    ),
                                    Text(
                                      "PKR ${rideXPrice.toStringAsFixed(2)}",
                                      style: (selectedVehicle != null &&
                                              selectedVehicle == "RideX")
                                          ? whiteTextRegularIn16px()
                                          : blackTextBoldIn16px(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ]),
                    ),
                    // this is if findDriver is true then show Finding Driver otherwise show SizedBox
                    (findDriver)
                        ? Align(
                            alignment: Alignment.center,
                            child: Container(
                                color: Colors.grey.withOpacity(0.8),
                                width: size.width,
                                height: size.height,
                                child: Center(
                                    child: Text("Finding Driver....",
                                        style: blackTextRegularIn30px()))),
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Visibility(
                  visible: selectVehicleErrorVisible,
                  child: Text(
                    "please select vehicle",
                    style: errorMessageLightIn12px(),
                  ),
                ),
              ),
              // this portion for if findDriver is not false then show confirm button otherwise show cancel
              (!findDriver)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: buttonWidget(
                          context: context,
                          text: "Confirm",
                          color: primaryColor,
                          onPress: confirmButtonClicked,
                          height: 55),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: buttonWidget(
                          context: context,
                          text: "Cancel",
                          color: primaryColor,
                          onPress: cancelButtonClicked,
                          height: 55),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // initializeComponent() async {
  //   rideProvider = Provider.of<RideProvider>(context, listen: false);
  //   userDetail = await LocalStorageService.getSignUpModel();
  //   sourceLocation =
  //       LatLng(widget.pickupLocation.lat!, widget.pickupLocation.long!);
  //   destinationLocation = LatLng(
  //       widget.destinationLocation.lat!, widget.destinationLocation.long!);
  //   distance = CommonFunctions().calculateDistance(
  //       widget.pickupLocation.lat,
  //       widget.pickupLocation.long,
  //       widget.destinationLocation.lat,
  //       widget.destinationLocation.long);
  //   findDriver = widget.driverFinding ?? false;
  //   if (rideProvider!.getVehicleRateList.isEmpty) {
  //     await rideProvider!.getVehicleRateListMethod();
  //     print("length of ride rate ${rideProvider!.getVehicleRateList.length}");
  //   }
  //   if (rideProvider!.getVehicleRateList.isNotEmpty) {
  //     if (rideProvider!.getVehicleRateList
  //         .any((element) => element.vehicleName == "MotorBike")) {
  //       VehicleRateModel item = rideProvider!.getVehicleRateList
  //           .firstWhere((element) => element.vehicleName == "MotorBike");
  //       if(distance! > 1.5){
  //         bikePrice = item.ratePerKilometer! + (distance! * 12).toInt();
  //       }
  //       else{
  //         bikePrice=item.ratePerKilometer!;
  //       }
  //
  //     }
  //     if (rideProvider!.getVehicleRateList
  //         .any((element) => element.vehicleName == "Rickshaw")) {
  //       VehicleRateModel item = rideProvider!.getVehicleRateList
  //           .firstWhere((element) => element.vehicleName == "Rickshaw");
  //       if(distance! > 1.5){
  //         RickshawPrice =item.ratePerKilometer! + (distance! * 18).toInt();
  //       }
  //       else{
  //         RickshawPrice=item.ratePerKilometer!;
  //       }
  //     }
  //     if (rideProvider!.getVehicleRateList
  //         .any((element) => element.vehicleName == "Mini")) {
  //       VehicleRateModel item = rideProvider!.getVehicleRateList
  //           .firstWhere((element) => element.vehicleName == "Mini");
  //       if(distance! > 1.5){
  //         miniPrice =item.ratePerKilometer! + (distance! * 22).toInt();
  //       }
  //       else{
  //         miniPrice=item.ratePerKilometer!;
  //       }
  //
  //     }
  //     if (rideProvider!.getVehicleRateList
  //         .any((element) => element.vehicleName == "RideGo")) {
  //       VehicleRateModel item = rideProvider!.getVehicleRateList
  //           .firstWhere((element) => element.vehicleName == "RideGo");
  //       if(distance! > 1.5){
  //         goPrice =item.ratePerKilometer! + (distance! * 30).toInt();
  //       }
  //       else{
  //         goPrice=item.ratePerKilometer!;
  //       }
  //     }
  //     if (rideProvider!.getVehicleRateList
  //         .any((element) => element.vehicleName == "RideX")) {
  //       VehicleRateModel item = rideProvider!.getVehicleRateList
  //           .firstWhere((element) => element.vehicleName == "RideX");
  //       if(distance! > 1.5){
  //         rideXPrice =item.ratePerKilometer! + (distance! * 37).toInt();
  //       }
  //       else{
  //         rideXPrice=item.ratePerKilometer!;
  //       }
  //     }
  //   } else {
  //     if(distance! > 1.5){
  //       bikePrice =50 + (distance! * 12).toInt();
  //       RickshawPrice =110 + (distance! * 18).toInt();
  //       miniPrice =160 + (distance! * 22).toInt();
  //       goPrice =200 + (distance! * 30).toInt();
  //       rideXPrice =240 + (distance! * 37).toInt();
  //     }
  //     else{
  //       bikePrice =50;
  //       RickshawPrice =110 ;
  //       miniPrice =160 ;
  //       goPrice =200;
  //       rideXPrice =240;
  //     }
  //   }
  //
  //   if(findDriver){
  //     selectedVehicle=widget.rideModel?.vehicleType;
  //   }
  //
  //   await getPolyLinePoints();
  //
  //   setState(() {});
  // }
//  this fuction for calculate distance and finde drivers, also calculate price and show on screen
  initializeComponent() async {
    log("initialize function call when ride request generated");
    rideProvider = Provider.of<RideProvider>(context, listen: false);
    userDetail = await LocalStorageService.getSignUpModel();
    sourceLocation =
        LatLng(widget.pickupLocation.lat!, widget.pickupLocation.long!);
    destinationLocation = LatLng(
        widget.destinationLocation.lat!, widget.destinationLocation.long!);

    distance = CommonFunctions().calculateDistance(
        widget.pickupLocation.lat,
        widget.pickupLocation.long,
        widget.destinationLocation.lat,
        widget.destinationLocation.long);

    findDriver = widget.driverFinding ?? false;

    await _loadVehicleRates();

    if (findDriver) {
      selectedVehicle = widget.rideModel?.vehicleType;
    }

    await getPolyLinePoints();

    setState(() {});
  }

// this fuction for calculate fare
  _loadVehicleRates() async {
    if (rideProvider!.getVehicleRateList.isEmpty) {
      await rideProvider!.getVehicleRateListMethod();
    }

    var fareCalculator = FareCalculator({
      "MotorBike": VehicleRate(
        baseRate: 50,
        ratePerKilometer: 16,
        ratePerMint: 50,
      ),
      "Rickshaw":
          VehicleRate(baseRate: 100, ratePerKilometer: 35, ratePerMint: 80),
      "Mini":
          VehicleRate(baseRate: 170, ratePerKilometer: 43, ratePerMint: 120),
      "RideGo":
          VehicleRate(baseRate: 235, ratePerKilometer: 51, ratePerMint: 180),
      "RideX":
          VehicleRate(baseRate: 270, ratePerKilometer: 63, ratePerMint: 280),

      // ... add other vehicles here
    });

    bikePrice = fareCalculator.calculateFare("MotorBike", distance!);
    RickshawPrice = fareCalculator.calculateFare("Rickshaw", distance!);
    miniPrice = fareCalculator.calculateFare("Mini", distance!);
    goPrice = fareCalculator.calculateFare("RideGo", distance!);
    rideXPrice = fareCalculator.calculateFare("RideX", distance!);

    // ... do the same for other vehicles
  }

// this fuction getting polyLinePoints
  getPolyLinePoints() async {
    PolylinePoints polyLinePoints = PolylinePoints();
    PolylineResult result = await polyLinePoints.getRouteBetweenCoordinates(
        Constant.kGoogleMapKey,
        PointLatLng(sourceLocation!.latitude, sourceLocation!.longitude),
        PointLatLng(
            destinationLocation!.latitude, destinationLocation!.longitude));
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng points) {
        polylineCoordinates.add(LatLng(points.latitude, points.longitude));
      });
      setState(() {});
    }
  }

  // this function for creating ride request
  confirmButtonClicked() async {
    if (selectedVehicle != null && distance != null && selectedPrice != null) {
      setState(() {
        selectVehicleErrorVisible = false;
        findDriver = true;
      });
      loadingAlertDialog(context: context);
      await rideProvider?.createRideRequest(
          sourceLocation: widget.pickupLocation,
          destinationModel: widget.destinationLocation,
          price: selectedPrice!,
          vehicleType: selectedVehicle!,
          uid: userDetail!.uid!,
          context: context);
      Navigator.pop(context);
    } else {
      selectVehicleErrorVisible = true;
      setState(() {});
    }
  }

// this fucntion for ride request cancel or removel
  cancelButtonClicked() async {
    loadingAlertDialog(context: context);
    if (rideProvider?.rideId == null) {
      rideProvider?.rideId = widget.rideModel?.id;
    }
    rideProvider?.cancelRideRequest();
    Navigator.pop(context);
    setState(() {
      findDriver = false;
    });
  }

  // this fuction for Onwillpop

  Future<bool> onWillPop() async {
    if (findDriver) {
      bool? result = await showDialog(
        context: context,
        builder: (ctx) => AppDialogue(
          title: "Alert",
          description: "Do you want cancel ride?",
        ),
      );
      if (result == true) {
        await cancelButtonClicked();
        if (widget.rideModel != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CustomerNavBarPage()),
          );
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      }
      return Future.value(false);
    } else {
      if (widget.rideModel != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CustomerNavBarPage()),
        );
        return Future.value(false);
      } else {
        return Future.value(true);
      }
    }
  }
}
// this fuction for fare calculator class

class FareCalculator {
  final Map<String, VehicleRate> vehicleRates;

  FareCalculator(this.vehicleRates);

  int calculateFare(String vehicleName, double distance) {
    VehicleRate? rate = vehicleRates[vehicleName];
    if (rate != null) {
      if (distance > 1) {
        return rate.baseRate +
            (distance * rate.ratePerKilometer).toInt() +
            (distance / 50 * rate.ratePerMint).toInt();
      }
      return rate.baseRate;
    }
    return 0;
  }
}

class VehicleRate {
  final int baseRate;
  final int ratePerKilometer;
  final int ratePerMint;

  VehicleRate(
      {required this.baseRate,
      required this.ratePerKilometer,
      required this.ratePerMint});
}
