import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:rideoptions/Screens/HomePage/BottomNavBar/driver_nav_bar_page.dart';
import '../../../../Component/Common_Widget/button_widget.dart';
import '../../../../Component/Common_Widget/circular_network_Image.dart';
import '../../../../Component/Dialogue/acitivity_indicator_dialogue.dart';
import '../../../../Component/Dialogue/app_dialogue.dart';
import '../../../../Component/Model/Authentication/location.dart';
import '../../../../Component/Model/Authentication/user_model.dart';
import '../../../../Component/Model/Ride/ride_model.dart';
import '../../../../Component/Model/drive_history.dart';
import '../../../../Component/Provider/ride_provider.dart';
import '../../../../Component/Services/authenticate_service.dart';
import '../../../../Component/Services/local_service.dart';
import '../../../../Component/Services/ride_service.dart';
import '../../../../Component/common_function.dart';
import '../../../../Component/constant.dart';
import '../../../../Component/theme/app_theme.dart';
import '../../../../Component/theme/text_style_theme.dart';
import '../../../../main.dart';
import '../../BottomNavBar/customer_nav_bar_page.dart';
import '../Chat/chat_page.dart';
import 'dart:ui' as ui;

import '../Deposit/packages.dart';

class DriverLiveTrackingPage extends StatefulWidget {
  RideModel rideModel;

  DriverLiveTrackingPage({required this.rideModel});

  @override
  State<DriverLiveTrackingPage> createState() => _DriverLiveTrackingPageState();
}

class _DriverLiveTrackingPageState extends State<DriverLiveTrackingPage> {
  LatLng? sourceLocation;
  LatLng? destinationLocation;
  RideProvider? rideProvider;
  UserModel? userDetail;
  double? distance;
  List<LatLng> polylineCoordinates = [];
  UserModel? customerUserModel;
  Timer? _timer;
  int _start = 0;
  LocationData? currentLocation;
  final Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor carDriverIcon = BitmapDescriptor.defaultMarker;
  StreamSubscription? locationSteam;
  StreamSubscription? rideSteam;

  getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((location) {
      currentLocation = location;
      getPolyLinePoints();
    });

    locationSteam = location.onLocationChanged.listen((newLocation) async {
      currentLocation = newLocation;
      print("call here");
      await getPolyLinePoints();
    });
  }

  late DatabaseReference _userRef;
  UserModel? _user;
  var uid =  currentUid != null ? currentUid : FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    // TODO: implement initState

    _userRef = FirebaseDatabase.instance
        .ref()
        .child('SaTtAaYz')
        .child('driverUsers')
        .child(uid);

    _userRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          _user =
              UserModel.fromMap(event.snapshot.value as Map<dynamic, dynamic>);
        });
      }
    });

    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      initializeComponent();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    locationSteam?.cancel();
    rideSteam?.cancel();
    stopTimer();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: WillPopScope(
          onWillPop: onWillPop,
          child: Stack(
            children: [
              Container(
                height: size.height * 0.71,
                child: (currentLocation != null)
                    ? GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(currentLocation!.latitude!,
                              currentLocation!.longitude!),
                          zoom: 16,
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
                            markerId: MarkerId("currentLocation"),
                            icon: carDriverIcon,
                            position: LatLng(currentLocation!.latitude!,
                                currentLocation!.longitude!),
                          ),
                          Marker(
                            markerId: MarkerId("destinationLocation"),
                            position: destinationLocation!,
                          ),
                        },
                        onMapCreated: (mapController) {
                          _controller.complete(mapController);
                        },
                      )
                    : Center(
                        child: Text("Loading....."),
                      ),
              ),
              (widget.rideModel.status == Constant.rideAcceptStatus)
                  ? Positioned(
                      right: 10,
                      top: 10,
                      child: GestureDetector(
                        onTap: () async {
                          bool? result = await showDialog(
                            context: context,
                            builder: (ctx) => AppDialogue(
                              title: "Alert",
                              description: "Are you sure to cancel this ride.",
                            ),
                          );
                          if (result == true) {
                            loadingAlertDialog(context: context);
                            await RideService().updateRideStatus(
                                Constant.rideCancelStatus,
                                widget.rideModel.id!);
                            FirebaseDatabase.instance
                                .ref("SaTtAaYz")
                                .child('ride')
                                .child(widget.rideModel.id!)
                                .remove();
                            print(
                                '''\n helloo\nhello\n\n${widget.rideModel.id!}''');
                            await rideProvider?.cancelRideRequest();
                            Navigator.pop(context);
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => CustomerNavBarPage()),
                                (Route<dynamic> route) => false);
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                          ),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ))
                  : Container(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        GoogleMapController? mapController =
                            await _controller.future;
                        mapController.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                                    target: LatLng(currentLocation!.latitude!,
                                        currentLocation!.longitude!),
                                    zoom: 17)
                                //17 is new zoom level
                                ));
                      },
                      child: Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade500,
                              offset: const Offset(
                                1.0,
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
                          borderRadius: BorderRadius.all(
                            Radius.circular(30.0),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/images/direction_icon.png",
                              width: 20,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Re-Center",
                              style: primaryTextBoldIn16px(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: size.height * 0.3,
                      width: size.width,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          //new Color.fromRGBO(255, 0, 0, 0.0),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40.0),
                              topRight: Radius.circular(40.0))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.0)),
                                ),
                                child: CircleNetworkImageFrame(
                                    customerUserModel?.profilePicture ??
                                        "https://www.webxcreation.com/event-recruitment/images/profile-1.jpg",
                                    50,
                                    50,
                                    "assets/images/user_white_icon.png"),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      customerUserModel?.name ?? "",
                                      style: blackTextBoldIn16px(),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      widget.rideModel.destinationLocation
                                              ?.location ??
                                          "",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: blackTextLightIn14px(),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Price:",
                                          style: blackTextBoldIn14px(),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "${widget.rideModel.price} PKR",
                                          style: blackTextLightIn14px(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: buttonWidget(
                                  context: context,
                                  text: "Message",
                                  color: primaryColor,
                                  onPress: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatPage(
                                                userModel: customerUserModel!,
                                              )),
                                    );
                                  })),
                          (widget.rideModel.status == Constant.rideAcceptStatus)
                              ? Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  child: buttonWidget(
                                      context: context,
                                      text: "Pick Up",
                                      color: primaryColor,
                                      onPress: () async {
                                        final DatabaseReference
                                            databaseReference = FirebaseDatabase
                                                .instance
                                                .ref()
                                                .child('SaTtAaYz')
                                                .child('driveHistory');

                                        DriveHistory drive = DriveHistory(
                                            amount: widget.rideModel.price
                                                .toString(),
                                            id: DateTime.now()
                                                .millisecondsSinceEpoch
                                                .toString());

                                        databaseReference
                                            .child(drive.id)
                                            .set(drive.toMap());
                                        loadingAlertDialog(context: context);
                                        await RideService().updateRideStatus(
                                            Constant.ridePickedUpStatus,
                                            widget.rideModel.id!);
                                        destinationLocation = LatLng(
                                            widget.rideModel
                                                .destinationLocation!.lat!,
                                            widget.rideModel
                                                .destinationLocation!.long!);
                                        widget.rideModel.status =
                                            Constant.ridePickedUpStatus;
                                        await getPolyLinePoints();
                                        Navigator.pop(context);
                                        setState(() {});
                                      }))
                              : Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  child: buttonWidget(
                                      context: context,
                                      text: "Drop off",
                                      color: primaryColor,
                                      onPress: () async {
                                        loadingAlertDialog(context: context);
                                        await rideProvider?.rideCompletedMethod(
                                            rideModel: widget.rideModel,
                                            userDetail: userDetail!);
                                        Navigator.pop(context);
                                        ;

                                        updateBalance(userDetail!.vehicleType ==
                                                'MotorBike'
                                            ? (double.parse(_user!.amount!) -
                                                    (8 /
                                                        100 *
                                                        widget.rideModel.price!
                                                            .toDouble()))
                                                .toString()
                                            : userDetail!.vehicleType == 'Car'
                                                ? (double.parse(
                                                            _user!.amount!) -
                                                        (12 /
                                                            100 *
                                                            widget.rideModel
                                                                .price!
                                                                .toDouble()))
                                                    .toString()
                                                : (double.parse(
                                                            _user!.amount!) -
                                                        (10 /
                                                            100 *
                                                            widget.rideModel
                                                                .price!
                                                                .toDouble()))
                                                    .toString());

                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            DriverNavBarPage()),
                                                (Route<dynamic> route) =>
                                                    false);
                                      })),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  initializeComponent() async {
    rideProvider = Provider.of<RideProvider>(context, listen: false);
    userDetail = await LocalStorageService.getSignUpModel();
    listenRideNode(widget.rideModel.id!);
    if (widget.rideModel.status == Constant.ridePickedUpStatus) {
      destinationLocation = LatLng(widget.rideModel.destinationLocation!.lat!,
          widget.rideModel.destinationLocation!.long!);
    } else {
      destinationLocation = LatLng(widget.rideModel.sourceLocation!.lat!,
          widget.rideModel.sourceLocation!.long!);
    }
    distance = CommonFunctions().calculateDistance(
        widget.rideModel.sourceLocation!.lat,
        widget.rideModel.sourceLocation!.long,
        widget.rideModel.destinationLocation!.lat,
        widget.rideModel.destinationLocation!.long);
    customerUserModel = await AuthenticateService()
        .getCustomerUserDetails(widget.rideModel.customerId);
    print("driver detail is: ${customerUserModel?.toMap()}");
    await setCustomMarkerIcon();
    await getCurrentLocation();
    setState(() {});
    startTimer();
  }

  listenRideNode(String rideId) {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("SaTtAaYz").child('ride');
    rideSteam = ref.child(rideId).child("status").onValue.listen((event) async {
      print("onValue listen call");
      if (event.snapshot.exists) {
        final myRide = event.snapshot.value;
        print("my ride status is: $myRide");
        if (myRide == Constant.rideCancelStatus) {
          locationSteam?.cancel();
          stopTimer();
          bool? result = await showDialog(
            context: context,
            builder: (ctx) => AppDialogue(
              title: "Alert",
              description:
                  "Ride has been cancelled.\n سواری منسوخ کر دی گئی ہے۔",
              cancelBtnVisible: false,
              confirmBthText: "ok",
            ),
          );

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => DriverNavBarPage()),
              (Route<dynamic> route) => false);
        }
      }
    });
  }

  getPolyLinePoints() async {
    print("polyLine");
    PolylinePoints polyLinePoints = PolylinePoints();
    PolylineResult result = await polyLinePoints.getRouteBetweenCoordinates(
        Constant.kGoogleMapKey,
        PointLatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        PointLatLng(
            destinationLocation!.latitude, destinationLocation!.longitude));
    if (result.points.isNotEmpty) {
      polylineCoordinates = [];
      result.points.forEach((PointLatLng points) {
        polylineCoordinates.add(LatLng(points.latitude, points.longitude));
      });
      if (mounted) {
        setState(() {});
      }
    }
  }

  setCustomMarkerIcon() async {
    final Uint8List markerIcon = await getBytesFromAsset(() {
      if (userDetail?.vehicleType == "Rickshaw") {
        return 'assets/images/rikshaw.png';
      } else if (widget.rideModel.vehicleType == "MotorBike") {
        return 'assets/images/bike.png';
      } else {
        return 'assets/images/car1.png';
      }
    }(), 100);
    carDriverIcon = BitmapDescriptor.fromBytes(markerIcon);
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  updateDriverLocation() async {
    LocationModel locationModel = LocationModel(
        lat: currentLocation?.latitude, long: currentLocation?.longitude);
    await RideService()
        .updateRideDriverLocationStatus(widget.rideModel.id!, locationModel);
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (mounted) {
          if (_start == 5) {
            updateDriverLocation();
            _start = 0;
          } else {
            _start++;
          }
        }
      },
    );
  }

  stopTimer() {
    _start = 0;
    _timer?.cancel();
  }

  Future<bool> onWillPop() async {
    bool? result = await showDialog(
      context: context,
      builder: (ctx) => AppDialogue(
        title: "Alert",
        description: "Do you want exit app?",
      ),
    );
    if (result == true) {
      SystemNavigator.pop();
      return Future.value(false);
    }
    return Future.value(false);
  }

  Future<void> updateBalance(String updatedAmount) async {
    if (userDetail?.package != null) {
      if (userDetail!.package?.activePackage == Constant.dailyPackageStatus ||
          userDetail!.package?.activePackage == Constant.weeklyPackageStatus) {
        int remainingActiveTimed = await CommonFunctions()
            .dailyPackageRemainingTime(userDetail!.package!.timeStamp!);
        int remainingActiveTimew = await CommonFunctions()
            .weeklyPackageRemainingTime(userDetail!.package!.timeStamp!);
        if (remainingActiveTimed < 0 || remainingActiveTimew < 0) {
        } else {
          final String currentUserUID =  currentUid != null ? currentUid : FirebaseAuth.instance.currentUser?.uid;
          final DatabaseReference databaseReference = FirebaseDatabase.instance
              .ref()
              .child('SaTtAaYz')
              .child('driverUsers')
              .child(currentUserUID);

          databaseReference.update({'amount': updatedAmount}).then((_) {
            print('Deposit updated successfully');
          }).catchError((error) {
            print('Error updating deposit: $error');
          });
        }
      }
    } else {
      final String currentUserUID =  currentUid != null ? currentUid : FirebaseAuth.instance.currentUser?.uid;
      final DatabaseReference databaseReference = FirebaseDatabase.instance
          .ref()
          .child('SaTtAaYz')
          .child('driverUsers')
          .child(currentUserUID);

      databaseReference.update({'amount': updatedAmount}).then((_) {
        print('Deposit updated successfully');
      }).catchError((error) {
        print('Error updating deposit: $error');
      });
    }
  }
}
