import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rideoptions/main.dart';
import 'package:upgrader/upgrader.dart';
import '../../../../Component/Common_Widget/button_widget.dart';
import '../../../../Component/Common_Widget/show_snack_bar.dart';
import '../../../../Component/Dialogue/acitivity_indicator_dialogue.dart';
import '../../../../Component/Model/Authentication/location.dart';
import '../../../../Component/Model/Authentication/user_model.dart';
import '../../../../Component/Model/Ride/ride_request_model.dart';
import '../../../../Component/Provider/ride_provider.dart';
import '../../../../Component/Services/global_service.dart';
import '../../../../Component/Services/local_service.dart';
import '../../../../Component/common_function.dart';
import '../../../../Component/theme/app_theme.dart';
import '../../../../Component/theme/text_style_theme.dart';
import '../Deposit/commision.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  UserModel? userDetail;
  bool activeStatus = false;
  RideProvider? rideProvider;

  late DatabaseReference _userRef;
  UserModel? _user;
  var uid =
      currentUid != null ? currentUid : FirebaseAuth.instance.currentUser?.uid;

  Completer<GoogleMapController> controllr = Completer();

  void _onMapCreated(GoogleMapController controller) {
    controllr.complete(controller);
  }

  @override
  void initState() {
    getUID();
    // TODO: implement initState
    super.initState();
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

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      initializeComponent();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return UpgradeAlert(
      child: Scaffold(
        body: SafeArea(
          child: Consumer<RideProvider>(
              builder: (context, consumerRideProvider, child) {
            Future.delayed(Duration(seconds: 2));
            return RefreshIndicator(
              onRefresh: pullToRefresh,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Ride Requests",
                          style: blackTextBoldIn35px(),
                        ),
                        FlutterSwitch(
                          showOnOff: false,
                          activeColor: purpleColor,
                          height: 25,
                          width: 50,
                          value: activeStatus,
                          onToggle: (val) async {
                            bool netConnect = await CommonFunctions()
                                .checkInternetConnection();
                            if (netConnect) {
                              loadingAlertDialog(context: context);
                              // activeStatus = !activeStatus;
                              await CommonFunctions().permissionServices().then(
                                (value) async {
                                  if (value.isNotEmpty) {
                                    print("status location: $value");
                                    if (value[Permission.location]?.isGranted ==
                                        true) {
                                      /* ========= New Screen Added  ============= */
                                      var status = await Permission
                                          .location.serviceStatus;
                                      if (status.isEnabled) {
                                        Position? currentPosition =
                                            await CommonFunctions()
                                                .getCurrentLocation();
                                        if (currentPosition != null) {
                                          String? address =
                                              await CommonFunctions()
                                                  .GetAddressFromLatLong(
                                                      currentPosition);
                                          LocationModel model = LocationModel(
                                              lat: currentPosition.latitude,
                                              long: currentPosition.longitude,
                                              location: address);
                                          activeStatus = !activeStatus;
                                          await updateLocationAndActiveStatus(
                                              model, userDetail!.uid!);
                                          userDetail?.active = activeStatus;
                                          userDetail?.location = model;
                                          await LocalStorageService
                                              .setSignUpModel(userDetail!);
                                        }
                                      } else {
                                        Position? currentPosition =
                                            await CommonFunctions()
                                                .getCurrentLocation();
                                        if (currentPosition != null) {
                                          String? address =
                                              await CommonFunctions()
                                                  .GetAddressFromLatLong(
                                                      currentPosition);
                                          LocationModel model = LocationModel(
                                              lat: currentPosition.latitude,
                                              long: currentPosition.longitude,
                                              location: address);
                                          activeStatus = !activeStatus;
                                          await updateLocationAndActiveStatus(
                                              model, userDetail!.uid!);
                                          userDetail?.active = activeStatus;
                                          userDetail?.location = model;
                                          await LocalStorageService
                                              .setSignUpModel(userDetail!);
                                        }
                                      }
                                    }
                                    if (value[Permission.location]?.isDenied ==
                                            true ||
                                        value[Permission.location]
                                                ?.isPermanentlyDenied ==
                                            true) {
                                      await openAppSettings();
                                    }
                                  }
                                },
                              );
                              Navigator.pop(context);
                              setState(() {});
                            } else {
                              showSnackBar(context,
                                  "please check your internet connection.");
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: (consumerRideProvider.getRideRequestList.isNotEmpty)
                        ? ListView.builder(
                            itemCount:
                                consumerRideProvider.rideRequestList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 10),
                                  width: size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade500,
                                        offset: const Offset(
                                          0.0,
                                          2.0,
                                        ),
                                        blurRadius: 2.0,
                                        spreadRadius: 2.0,
                                      ), //BoxShadow
                                      BoxShadow(
                                        color: Colors.white,
                                        offset: const Offset(0.0, 0.0),
                                        blurRadius: 0.0,
                                        spreadRadius: 0.0,
                                      ), //BoxShadow
                                    ],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Pickup:",
                                        style: blackTextRegularIn14px(),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        consumerRideProvider
                                                .rideRequestList[index]
                                                .sourceLocation
                                                ?.location ??
                                            "",
                                        style: blackTextLightIn14px(),
                                      ),
                                      SizedBox(
                                        height: 25,
                                      ),
                                      Text(
                                        "Destination:",
                                        style: blackTextRegularIn14px(),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        consumerRideProvider
                                                .rideRequestList[index]
                                                .destinationLocation
                                                ?.location ??
                                            "",
                                        style: blackTextLightIn14px(),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "Price:",
                                                style: blackTextRegularIn14px(),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "${consumerRideProvider.rideRequestList[index].price} PKR",
                                                style: blackTextLightIn14px(),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Request Type:",
                                                style: blackTextRegularIn14px(),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "${consumerRideProvider.rideRequestList[index].rideType}",
                                                style: blackTextLightIn14px(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            Jiffy(DateTime.fromMillisecondsSinceEpoch(
                                                            consumerRideProvider
                                                                .rideRequestList[
                                                                    index]
                                                                .timeStamp!)
                                                        .toLocal())
                                                    .fromNow() ??
                                                "",
                                            style: blackTextLightIn14px(),
                                          ),
                                          Container(
                                            width: 150,
                                            child: buttonWidget(
                                              context: context,
                                              text: "Accept",
                                              color: primaryColor,
                                              onPress: () async {
                                                loadingAlertDialog(
                                                    context: context);
                                                await acceptRideRequest(
                                                    consumerRideProvider
                                                            .rideRequestList[
                                                        index]);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ));
                            })
                        : Container(
                            height: size.height * 0.5,
                            child: Center(
                              child: Image.asset(
                                "assets/images/placeHolder.png",
                                width: size.width,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  initializeComponent() async {
    rideProvider = Provider.of<RideProvider>(context, listen: false);
    userDetail = await LocalStorageService.getSignUpModel();
    await rideProvider!.getRideRequestMethod(uid: userDetail!.uid!);
    activeStatus = userDetail?.active ?? false;
    setState(() {});
  }

  Future<void> pullToRefresh() async {
    bool netConnect = await GlobalService().checkInternetConnection();
    if (netConnect) {
      await rideProvider!.getRideRequestMethod(uid: userDetail!.uid!);
    } else {
      showSnackBar(context, "please check your internet connection");
    }
  }

  updateLocationAndActiveStatus(LocationModel model, String uid) async {
    await FirebaseDatabase.instance
        .ref()
        .child('SaTtAaYz')
        .child("driverUsers")
        .child(uid)
        .update({
      "active": activeStatus,
      "location": model.toMap(),
    });
  }

  acceptRideRequest(RideRequestModel requestModel) async {
    bool canAcceptRide = false;
    //
    // if (_user?.package != null) {
    //   int? remainingActiveTime;
    //   if (_user!.package?.activePackage == Constant.dailyPackageStatus) {
    //     remainingActiveTime = await CommonFunctions()
    //         .dailyPackageRemainingTime(_user!.package!.timeStamp!);
    //   } else if (_user!.package?.activePackage ==
    //       Constant.weeklyPackageStatus) {
    //     remainingActiveTime = await CommonFunctions()
    //         .weeklyPackageRemainingTime(_user!.package!.timeStamp!);
    //   }
    //
    //   if (remainingActiveTime != null && remainingActiveTime > 0) {
    //     canAcceptRide = true;
    //   }
    //   else if (_user!.deposit != null &&
    //       _user!.amount != null &&
    //       double.parse(_user!.amount!) >= 50.0) {
    //     canAcceptRide = true;
    //   }
    // } else if (_user!.deposit != null &&
    //     _user!.amount != null &&
    //     double.parse(_user!.amount!) >= 50.0) {
    //   canAcceptRide = true;
    // }

    if (_user!.amount != "" && double.parse(_user!.amount!) >= 50.0) {
      canAcceptRide = true;
    }

    if (canAcceptRide) {
      await rideProvider!.acceptRideRequestMethod(
          context: context, requestModel: requestModel, uid: userDetail!.uid!);
    } else {
      Navigator.pop(context);
      bool? result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CommissionPage(
              UModel:
              _user?.amount?.isNotEmpty ?? false
                  ? _user!.amount!
                  : '0', throughOrderPage: false),
        ),
      );

      if (result == true) {
        userDetail = await LocalStorageService.getSignUpModel();
      }
    }
  }

// acceptRideRequest(RideRequestModel requestModel) async {
//   if (_user?.package != null) {
//     if (_user!.package?.activePackage == Constant.dailyPackageStatus) {
//       int remainingActiveTime = await CommonFunctions()
//           .dailyPackageRemainingTime(_user!.package!.timeStamp!);
//       if (remainingActiveTime > 0) {
//         await rideProvider!.acceptRideRequestMethod(
//             context: context,
//             requestModel: requestModel,
//             uid: userDetail!.uid!);
//       } else {
//         Navigator.pop(context);
//         bool? result = await Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => deposit_page(
//                     throughOrderPage: true,
//                   )),
//         );
//         if (result == true) {
//           userDetail = await LocalStorageService.getSignUpModel();
//         }
//       }
//     }
//     else if (_user!.package?.activePackage ==
//         Constant.weeklyPackageStatus) {
//       int remainingActiveTime = await CommonFunctions()
//           .weeklyPackageRemainingTime(_user!.package!.timeStamp!);
//       if (remainingActiveTime > 0) {
//         await rideProvider!.acceptRideRequestMethod(
//             context: context,
//             requestModel: requestModel,
//             uid: userDetail!.uid!);
//       } else {
//         if (_user!.deposit != null) {
//
//           if (_user!.amount != null && double.parse(_user!.amount!) >= 50.0) {
//             await rideProvider!.acceptRideRequestMethod(
//                 context: context,
//                 requestModel: requestModel,
//                 uid: userDetail!.uid!);
//           } else {
//             Navigator.pop(context);
//             bool? result = await Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => deposit_page(
//                     throughOrderPage: true,
//                   )),
//             );
//             if (result == true) {
//               userDetail = await LocalStorageService.getSignUpModel();
//             }
//           }
//         } else {
//           Navigator.pop(context);
//           bool? result = await Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => deposit_page(
//                   throughOrderPage: true,
//                 )),
//           );
//           if (result == true) {
//             userDetail = await LocalStorageService.getSignUpModel();
//           }
//         }
//       }
//     }
//   } else {
//     if (_user!.deposit != null) {
//       if (_user!.amount != null && double.parse(_user!.amount!) >= 50.0) {
//         await rideProvider!.acceptRideRequestMethod(
//             context: context,
//             requestModel: requestModel,
//             uid: userDetail!.uid!);
//       } else {
//         Navigator.pop(context);
//         bool? result = await Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => deposit_page(
//                     throughOrderPage: true,
//                   )),
//         );
//         if (result == true) {
//           userDetail = await LocalStorageService.getSignUpModel();
//         }
//       }
//     } else {
//       Navigator.pop(context);
//       bool? result = await Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => deposit_page(
//                   throughOrderPage: true,
//                 )),
//       );
//       if (result == true) {
//         userDetail = await LocalStorageService.getSignUpModel();
//       }
//     }
//   }
// }
}
