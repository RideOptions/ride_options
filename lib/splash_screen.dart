import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rideoptions/Component/theme/app_theme.dart';
import 'package:rideoptions/role_screen.dart';

import 'Component/Dialogue/application_alert_dialogue.dart';
import 'Component/Model/Authentication/user_model.dart';
import 'Component/Model/Ride/ride_model.dart';
import 'Component/Model/response_model.dart';
import 'Component/Services/global_service.dart';
import 'Component/Services/local_service.dart';
import 'Component/Services/ride_service.dart';
import 'Component/constant.dart';
import 'Component/theme/text_style_theme.dart';
import 'Screens/HomePage/BottomNavBar/customer_nav_bar_page.dart';
import 'Screens/HomePage/BottomNavBar/driver_nav_bar_page.dart';
import 'Screens/HomePage/NavBarPages/Ride/customer_live_tracking_page.dart';
import 'Screens/HomePage/NavBarPages/Ride/driver_live_tracking_page.dart';
import 'Screens/HomePage/NavBarPages/Ride/ride_category_page.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash-screen';

  SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splashlogo.png',
              height: MediaQuery.of(context).size.height * 0.5,
            ),
            SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }

  initializeComponent() async {
    print("kaakkah");
    bool netConnected = await GlobalService().checkInternetConnection();
    if (netConnected) {
      await Permission.location.request();
      UserModel? signupData = await LocalStorageService.getSignUpModel();
      if (signupData != null) {
        MyResponse response = MyResponse(success: false, data: null);
        if (signupData.userType == Constant.customerRole) {
          response = await RideService().rideSessionAvailable(signupData.uid!);
        } else {
          response =
              await RideService().rideDriverSessionAvailable(signupData.uid!);
        }

        if (response.success) {
          RideModel data = response.data as RideModel;
          if (signupData.userType == Constant.customerRole) {
            print("ride model: ${data.toMap()}");
            if (data.acceptedBy != null && data.acceptedBy != "") {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomerLiveTrackingPage(
                          rideModel: data,
                        )),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => RideCategoryPage(
                          pickupLocation: data.sourceLocation!,
                          destinationLocation: data.destinationLocation!,
                          driverFinding: true,
                          rideModel: data,
                        )),
              );
            }
          } else {
            if (response.success) {
              RideModel data = response.data as RideModel;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => DriverLiveTrackingPage(
                          rideModel: data,
                        )),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => DriverNavBarPage()),
              );
            }
          }
        } else {
          if (signupData.userType == Constant.customerRole) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CustomerNavBarPage()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DriverNavBarPage()),
            );
          }
        }
      } else {
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => RolePage()),
          );
        });
      }
    } else {
      bool result = await showDialog(
          context: context,
          //barrierDismissible: false,

          builder: (BuildContext context) {
            return ApplicationAlertDialogue(
              dialogueHeight: 270,
              imageWidth: 100,
              imageHeight: 100,
              buttonText: "Try Again",
              imagePath: "assets/images/error_icon.png",
              title: "Internet Connection!",
              titleStyle: blackTextBoldIn25px(),
              description: "please check your internet connection.",
              descriptionStyle: greyTextRegularIn16px(),
              richTextFlag: false,
              cancelBtnVisible: false,
              crossBtnVisible: false,
              onTap: () async {
                Navigator.pop(context, true);
              },
            );
          });
      if (result) {
        initializeComponent();
      }
    }
  }
}
