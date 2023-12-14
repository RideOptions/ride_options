import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rideoptions/Component/Model/payment_history.dart';
import 'package:rideoptions/Screens/HomePage/BottomNavBar/driver_nav_bar_page.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../../../../Component/Dialogue/acitivity_indicator_dialogue.dart';
import '../../../../Component/Dialogue/app_dialogue.dart';
import '../../../../Component/Model/Authentication/user_model.dart';
import '../../../../Component/Model/Package/package_model.dart';
import '../../../../Component/Model/payment_response_model.dart';
import '../../../../Component/Provider/package_provider.dart';
import '../../../../Component/Services/authenticate_service.dart';
import '../../../../Component/Services/global_service.dart';
import '../../../../Component/Services/local_service.dart';
import '../../../../Component/common_function.dart';
import '../../../../Component/constant.dart';
import '../../../../Component/theme/app_theme.dart';
import '../../../../Component/theme/text_style_theme.dart';
import '../../../../main.dart';

class PackagesPage extends StatefulWidget {
  bool throughOrderPage;
  PackagesPage({Key? key, required this.throughOrderPage}) : super(key: key);

  @override
  State<PackagesPage> createState() => _PackagesPageState();
}

class _PackagesPageState extends State<PackagesPage> {
  UserModel? userDetail;
  String? activePackage;
  String? displayTime;
  int? spendDays;
  int weeklyPackagePrice = 0;
  int dailyPackagePrice = 0;
  String? res;
  late PackageProvider packageProvider;
  static const platform = const MethodChannel('com.flutter.khurramdev');

  late DatabaseReference _userRef;
  UserModel? _user;
  var uid = currentUid != null ? currentUid : FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
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
    packageProvider = Provider.of<PackageProvider>(context, listen: false);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // initializeComponent();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    packageProvider.stopWatchTimer?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Packages',
          style: whiteAppBarTextStyle22px(),
        ),
      ),
      body: SafeArea(
        child: Consumer<PackageProvider>(
            builder: (context, packageProvider, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Active Package",
                        style: blackTextBoldIn18px(),
                      ),
                      Text(
                        () {
                          if (activePackage != null &&
                              activePackage == Constant.dailyPackageStatus) {
                            return "Daily Basic";
                          } else if (activePackage != null &&
                              activePackage == Constant.weeklyPackageStatus) {
                            return "Weekly Basic";
                          } else {
                            return "No Active Package";
                          }
                        }(),
                        style: blackTextRegularIn16px(),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Remaining Time",
                        style: blackTextBoldIn18px(),
                      ),
                      Text(
                        displayTime ?? "00:00:00",
                        style: blackTextRegularIn16px(),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  width: size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
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
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      border: Border.all(
                        color: primaryColor,
                        width: 2,
                      )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Daily Basic",
                        style: blackTextBoldIn16px(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Enjoy app ride for just $dailyPackagePrice PKR a day.",
                        style: blackTextRegularIn16px(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              if (activePackage != null) {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AppDialogue(
                                    title: "Alert",
                                    description:
                                        "you have already active package.",
                                    cancelBtnVisible: false,
                                    confirmBthText: "ok",
                                  ),
                                );
                              } else {
                                bool? result = await showDialog(
                                  context: context,
                                  builder: (ctx) => AppDialogue(
                                    title: "Alert",
                                    description:
                                        "Do you want active daily package?",
                                  ),
                                );
                                if (result == true) {
                                  await jazzCashPaymentMethod(
                                      Constant.dailyPackageStatus,
                                      dailyPackagePrice);
                                }
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(primaryColor),
                            ),
                            child: Text(
                              "Buy Now",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            "Rs. $dailyPackagePrice/day",
                            style: blackTextBoldIn16px(),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  width: size.width,
                  decoration: BoxDecoration(
                      color: Colors.white,
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
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      border: Border.all(
                        color: primaryColor,
                        width: 2,
                      )),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Monthly Basic",
                        style: blackTextBoldIn16px(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Enjoy app ride for just $weeklyPackagePrice PKR a day.",
                        style: blackTextRegularIn16px(),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              if (activePackage != null) {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AppDialogue(
                                    title: "Alert",
                                    description:
                                        "you have already active package.",
                                    cancelBtnVisible: false,
                                    confirmBthText: "ok",
                                  ),
                                );
                              } else {
                                bool? result = await showDialog(
                                  context: context,
                                  builder: (ctx) => AppDialogue(
                                    title: "Alert",
                                    description:
                                        "Do you want active weekly package?",
                                  ),
                                );
                                if (result == true) {
                                  await jazzCashPaymentMethod(
                                      Constant.weeklyPackageStatus,
                                      weeklyPackagePrice);
                                }
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(primaryColor),
                            ),
                            child: Text(
                              "Buy Now",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            "Rs. $weeklyPackagePrice/week",
                            style: blackTextBoldIn16px(),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  initializeComponent() async {
    userDetail = await LocalStorageService.getSignUpModel();
    if (userDetail?.vehicleType == Constant.bikeVehicleType) {
      dailyPackagePrice = 100;
      weeklyPackagePrice = 500;
    } else if (userDetail?.vehicleType == Constant.RickshawVehicleType) {
      dailyPackagePrice = 150;
      weeklyPackagePrice = 700;
    } else if (userDetail!.RideX == true || userDetail!.RideGo == true) {
      dailyPackagePrice = 250;
      weeklyPackagePrice = 1200;
    } else {
      dailyPackagePrice = 200;
      weeklyPackagePrice = 1000;
    }
    checkPackageModel();
  }

  jazzCashPaymentMethod(String package, int price) async {
    Map<String, String> data = {
      "price": "${price}00",
      "Jazz_MerchantID": "51213142",
      "Jazz_Password": "713129h04u",
      "Jazz_IntegritySalt": "8v03c9fx9y",
      "paymentReturnUrl": "https://rideoptions.pk/"
    };
    String value = "";

    try {
      value = await platform.invokeMethod("Print", data);
      print("my result response: $value");
      if (value.isNotEmpty) {
        List<PaymentResponseModel> responseList = [];
        List<String> values = value.split("&");
        for (String item in values) {
          List<String> nameValue = item.split("=");
          if (nameValue.length == 2) {
            PaymentResponseModel model =
                PaymentResponseModel(key: nameValue[0], value: nameValue[1]);
            print("my model is: ${nameValue[0]} ~  ${nameValue[1]}");
            responseList.add(model);
          }
        }
        if (responseList.any((element) => element.key == "pp_ResponseCode")) {
          PaymentResponseModel responseCode = responseList
              .firstWhere((element) => element.key == "pp_ResponseCode");
          PaymentResponseModel responseMessage = responseList
              .firstWhere((element) => element.key == "pp_ResponseMessage");

          if (responseCode.value == "000" || responseCode.value == "121") {
            final DatabaseReference databaseReference = FirebaseDatabase
                .instance
                .ref()
                .child('SaTtAaYz')
                .child('paymentHistory');

            paymentHistory payment = paymentHistory(
                profielPic: _user!.profilePicture!,
                name: _user!.name!,
                type: 'Subscribe Plan',
                amount: price.toString(),
                id: DateTime.now().millisecondsSinceEpoch.toString());
            databaseReference.child(payment.id).set(payment.toMap());
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Payment Response Success!"),
                  content: Text(responseMessage.value ??
                      "Thank you for Using JazzCash, your transaction was successful"),
                  actions: [
                    ElevatedButton(
                      child: Text(
                        "OK",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: primaryColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
            loadingAlertDialog(context: context);
            int currentTime = await GlobalService().getCurrentTime();
            PackageModel model =
                PackageModel(activePackage: package, timeStamp: currentTime);
            await AuthenticateService()
                .updateDriverPackageStatus(userDetail!.uid!, model);
            userDetail?.package = model;
            await LocalStorageService.setSignUpModel(userDetail!);
            print("pioooooiio: ${userDetail?.package?.toMap()}");
            await checkPackageModel();
            Navigator.pop(context);
            if (widget.throughOrderPage) {
              // Navigator.pop(context, true);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => DriverNavBarPage()),
                  (Route<dynamic> route) => false);
            }

            print("====================== Success =========================");
          } else if (responseCode.value == "124" ||
              responseCode.value == "157") {
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Payment Pending!"),
                  content: Text(responseMessage.value ??
                      "Something went wrong, please try again later."),
                  actions: [
                    ElevatedButton(
                      child: Text(
                        "OK",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: primaryColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              },
            );
            print("====================== Pending =========================");
          } else {
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Payment Response Failed!"),
                  content: Text(responseMessage.value ??
                      "Something went wrong, please try again later."),
                  actions: [
                    ElevatedButton(
                      child: Text(
                        "OK",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: primaryColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
            print("====================== Failed =========================");
          }
        }
      }
    } catch (e) {
      print("jgjgss");
      print(e);
    }
  }

  checkPackageModel() async {
    print("my package details: ${userDetail?.package?.toMap()}");
    if (userDetail?.package != null &&
        userDetail?.package?.activePackage == Constant.dailyPackageStatus) {
      int remainingTime = await CommonFunctions()
          .dailyPackageRemainingTime(userDetail!.package!.timeStamp!);
      if (remainingTime > 0) {
        packageProvider.stopWatchTimer = StopWatchTimer(
          mode: StopWatchMode.countDown,
          presetMillisecond:
              StopWatchTimer.getMilliSecFromSecond(remainingTime),
          onChange: (value) async {
            displayTime = StopWatchTimer.getDisplayTime(value,
                milliSecond: false, secondRightBreak: '');
            setState(() {});
          },

          // onStopped: () {
          //   _stopWatchTimer?.onStopTimer();
          // }
        );
        // _stopWatchTimer?.onStartTimer();
        packageProvider.stopWatchTimer?.onExecute.add(StopWatchExecute.start);
        activePackage = userDetail!.package!.activePackage!;
      }
    } else if (userDetail?.package != null &&
        userDetail?.package?.activePackage == Constant.weeklyPackageStatus) {
      int currentTime = await GlobalService().getCurrentTime();
      DateTime fromTime = DateTime.fromMillisecondsSinceEpoch(currentTime);
      DateTime toTime =
          DateTime.fromMillisecondsSinceEpoch(userDetail!.package!.timeStamp!);
      int diff = fromTime.difference(toTime).inDays;
      print("days diff $diff");
      if (diff < 7) {
        displayTime = "${7 - diff} days remaining";
      } else if (diff == 7) {
        int diff = fromTime.difference(toTime).inSeconds;
        int remainingTime = 604800 - diff;
        if (remainingTime > 0) {
          packageProvider.stopWatchTimer = StopWatchTimer(
            mode: StopWatchMode.countDown,
            presetMillisecond:
                StopWatchTimer.getMilliSecFromSecond(remainingTime),
            onChange: (value) async {
              displayTime = StopWatchTimer.getDisplayTime(value,
                  milliSecond: false, secondRightBreak: '');
              setState(() {});
            },
          );
          packageProvider.stopWatchTimer?.onExecute.add(StopWatchExecute.start);
          activePackage = userDetail!.package!.activePackage!;
        }
      }
      activePackage = userDetail!.package!.activePackage!;
    }
    setState(() {});
  }
}
