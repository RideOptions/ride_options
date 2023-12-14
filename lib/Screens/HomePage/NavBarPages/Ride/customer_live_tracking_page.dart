import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import '../../../../Component/Common_Widget/button_widget.dart';
import '../../../../Component/Common_Widget/circular_network_Image.dart';
import '../../../../Component/Common_Widget/show_snack_bar.dart';
import '../../../../Component/Dialogue/acitivity_indicator_dialogue.dart';
import '../../../../Component/Dialogue/app_dialogue.dart';
import '../../../../Component/Dialogue/driver_review_dialogue.dart';
import '../../../../Component/Model/Authentication/driver_user_model.dart';
import '../../../../Component/Model/Authentication/user_model.dart';
import '../../../../Component/Model/Review/review_model.dart';
import '../../../../Component/Model/Ride/ride_model.dart';
import '../../../../Component/Provider/ride_provider.dart';
import '../../../../Component/Services/authenticate_service.dart';
import '../../../../Component/Services/global_service.dart';
import '../../../../Component/Services/local_service.dart';
import '../../../../Component/Services/ride_service.dart';
import '../../../../Component/common_function.dart';
import '../../../../Component/constant.dart';
import '../../../../Component/theme/app_theme.dart';
import '../../../../Component/theme/text_style_theme.dart';
import '../../BottomNavBar/customer_nav_bar_page.dart';
import '../../BottomNavBar/driver_nav_bar_page.dart';
import '../Chat/chat_page.dart';

class CustomerLiveTrackingPage extends StatefulWidget {
  RideModel rideModel;
  CustomerLiveTrackingPage({required this.rideModel});

  @override
  State<CustomerLiveTrackingPage> createState() =>
      _CustomerLiveTrackingPageState();
}

class _CustomerLiveTrackingPageState extends State<CustomerLiveTrackingPage> {
  LatLng? driverLocation;
  LatLng? destinationLocation;
  RideProvider? rideProvider;
  UserModel? userDetail;
  double? distance;
  List<LatLng> polylineCoordinates = [];
  UserModel? driverUserModel;
  BitmapDescriptor carDriverIcon = BitmapDescriptor.defaultMarker;
  bool dLock = false;
  StreamSubscription? locationSteam;
  StreamSubscription? rideSteam;
  final Completer<GoogleMapController> _controller = Completer();
  String? arrivalTime;
  @override
  void initState() {
    // TODO: implement initState
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
                child: (driverLocation != null)
                    ? GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(driverLocation!.latitude,
                              driverLocation!.longitude),
                          zoom: 15,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
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
                            markerId: MarkerId("driverLocation"),
                            icon: carDriverIcon,
                            position: LatLng(driverLocation!.latitude,
                                driverLocation!.longitude),
                          ),
                          Marker(
                            markerId: MarkerId("destinationLocation"),
                            position: destinationLocation ?? LatLng(0, 0),
                          ),
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
                                    target: LatLng(driverLocation!.latitude,
                                        driverLocation!.longitude),
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
                                    driverUserModel?.profilePicture ??
                                        "https://www.webxcreation.com/event-recruitment/images/profile-1.jpg",
                                    50,
                                    50,
                                    null),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      driverUserModel?.name ?? "",
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
                                      height: 5,
                                    ),
                                    Text(
                                      "${driverUserModel?.vehicleColor} ${driverUserModel?.vehicleType} ${driverUserModel?.vehicleNumber}",
                                      style: blackTextBoldIn18px(),
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
                                    SizedBox(
                                      height: 10,
                                    ),
                                    (widget.rideModel.status ==
                                            Constant.rideAcceptStatus)
                                        ? Row(
                                            children: [
                                              Image.asset(
                                                "assets/images/location_gif.gif",
                                                height: 60,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                (arrivalTime == "arrived")
                                                    ? "Driver Arrived"
                                                    : "$arrivalTime minutes later",
                                                style: blackTextBlodIn16px(),
                                              ),
                                            ],
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: buttonWidget(
                                  context: context,
                                  text: "Message",
                                  color: primaryColor,
                                  onPress: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatPage(
                                                userModel: driverUserModel!,
                                              )),
                                    );
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
    listenRideNode1(widget.rideModel.id!);
    if (widget.rideModel.status == Constant.rideAcceptStatus) {
      destinationLocation = LatLng(widget.rideModel.sourceLocation!.lat!,
          widget.rideModel.sourceLocation!.long!);
    } else {
      destinationLocation = LatLng(widget.rideModel.destinationLocation!.lat!,
          widget.rideModel.destinationLocation!.long!);
    }
    driverLocation = LatLng(widget.rideModel.driverLocation!.lat!,
        widget.rideModel.driverLocation!.long!);
    await setCustomMarkerIcon();
    await getPolyLinePoints();
    distance = CommonFunctions().calculateDistance(
        widget.rideModel.sourceLocation!.lat,
        widget.rideModel.sourceLocation!.long,
        widget.rideModel.destinationLocation!.lat,
        widget.rideModel.destinationLocation!.long);
    driverUserModel = await AuthenticateService()
        .getDriverUserDetails(widget.rideModel.acceptedBy);
    print("driver detail is: ${driverUserModel?.toMap()}");
    if (mounted) {
      setState(() {});
    }
  }

  listenRideNode(String rideId) {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("SaTtAaYz").child('ride');
    rideSteam = ref.child(rideId).onValue.listen((event) async {
      print("onValue listen call");
      if (event.snapshot.exists) {
        final myRide = Map<dynamic, dynamic>.from(
            event.snapshot.value as Map<dynamic, dynamic>);
        RideModel rideModel = RideModel.fromMap(myRide);
        await updateDriverLocation(rideModel);
      }
    });
  }

  listenRideNode1(String rideId) {
    DatabaseReference ref =
    FirebaseDatabase.instance.ref("SaTtAaYz").child('ride');
    rideSteam = ref.child(rideId).child("status").onValue.listen((event) async {
      print("onValue listen call");
      if (event.snapshot.exists) {
        final myRide = event.snapshot.value;
        print("my ride status is: $myRide");
        if (myRide == Constant.rideCancelStatus) {
          locationSteam?.cancel();
          // stopTimer();
          bool? result = await showDialog(
            context: context,
            builder: (ctx) => AppDialogue(
              title: "Alert",
              description: "Ride has been cancelled.\n سواری منسوخ کر دی گئی ہے۔",
              cancelBtnVisible: false,
              confirmBthText: "ok",
            ),
          );
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => CustomerNavBarPage()),
                  (Route<dynamic> route) => false);
        }
      }
    });
  }

  getPolyLinePoints() async {
    PolylinePoints polyLinePoints = PolylinePoints();
    PolylineResult result = await polyLinePoints.getRouteBetweenCoordinates(
        Constant.kGoogleMapKey,
        PointLatLng(driverLocation!.latitude, driverLocation!.longitude),
        PointLatLng(
            destinationLocation!.latitude, destinationLocation!.longitude));
    if (result.points.isNotEmpty) {
      polylineCoordinates = [];
      result.points.forEach((PointLatLng points) {
        polylineCoordinates.add(LatLng(points.latitude, points.longitude));
      });
    }
  }

  setCustomMarkerIcon() async {
    final Uint8List markerIcon = await getBytesFromAsset(() {
      if (widget.rideModel.vehicleType == "Rickshaw") {
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

  updateDriverLocation(RideModel rideModel) async {
    print("ride update model: ${rideModel.toMap()}");
    driverLocation =
        LatLng(rideModel.driverLocation!.lat!, rideModel.driverLocation!.long!);
    if (rideModel.status == Constant.rideAcceptStatus) {
      destinationLocation = LatLng(widget.rideModel.sourceLocation!.lat!,
          widget.rideModel.sourceLocation!.long!);
      double distanceInKm = CommonFunctions().calculateDistance(
          driverLocation!.latitude,
          driverLocation!.longitude,
          destinationLocation!.latitude,
          destinationLocation!.longitude);

      double distanceInMeters = distanceInKm * 1000;

      // Assuming speed is in meters per second
      int timeInMinutes = (distanceInMeters / 200).ceil();

      if (distanceInMeters < 50) {
        arrivalTime = "arrived";
      } else {
        arrivalTime = "${timeInMinutes}";
      }
    } else if (rideModel.status == Constant.ridePickedUpStatus) {
      widget.rideModel.status = Constant.ridePickedUpStatus;
      destinationLocation = LatLng(widget.rideModel.destinationLocation!.lat!,
          widget.rideModel.destinationLocation!.long!);
    } else if (rideModel.status == Constant.rideCompletedStatus) {
      widget.rideModel.status = Constant.rideCompletedStatus;
      int? numberOfStart = await showDialog(
        context: context,
        builder: (ctx) => DriverReviewDialogue(
          pictureUrl: driverUserModel?.profilePicture,
        ),
      );
      if (numberOfStart != null) {
        loadingAlertDialog(context: context);
        DatabaseReference ref =
            FirebaseDatabase.instance.ref("SaTtAaYz").child('review');
        int? currentTime = await GlobalService().getCurrentTime();
        String? nodeKey = ref.push().key;
        ReviewModel reviewModel = ReviewModel(
          id: nodeKey,
          customerId: widget.rideModel.customerId,
          driverId: widget.rideModel.acceptedBy,
          rideId: widget.rideModel.id,
          numberOfStar: numberOfStart,
          timeStamp: currentTime,
        );
        await ref.child(nodeKey!).set(reviewModel.toMap());
        Navigator.pop(context);
      }
      await FirebaseDatabase.instance
          .ref("SaTtAaYz")
          .child('ride')
          .child(widget.rideModel.id!)
          .remove();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => CustomerNavBarPage()),
          (Route<dynamic> route) => false);
      return;
    }
    await getPolyLinePoints();
    setState(() {

    });
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
}
