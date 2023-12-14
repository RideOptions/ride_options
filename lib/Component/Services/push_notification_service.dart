import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import '../../Screens/HomePage/BottomNavBar/customer_nav_bar_page.dart';
import '../../Screens/HomePage/BottomNavBar/driver_nav_bar_page.dart';
import '../Model/Authentication/user_model.dart';
import '../Provider/ride_provider.dart';
import '../common_function.dart';
import '../constant.dart';
import 'local_service.dart';

class PushNotificationService {
  final BuildContext context;

  PushNotificationService(this.context);

  initFirebaseMessaging() async {
    if (Platform.isIOS) {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      // if()
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
    }
    print("Notification message initiated");
    try {
      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? message) {
        if (message != null) {
          showInAppScreenNotification(message, context);
          // PerformNotificationNavigation(message);
          return;
        }
      });
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (message.data.isEmpty) return;
        //f PerformNotificationNavigation(message);
        showInAppScreenNotification(message, context);
        print("message background ----56-----------------");
        return;
      });
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("message initiated ----------09-----------------");
        if (message == null) {
          return;
        }
        print("message foreground ---------------------------");

        if(!CommonFunctions.chatScreen){
          performAndManageLocalNotification(message);
        }

      });
    } catch (e, stackTrack) {
      print('_MyAppState.initState: e: $e: stackTrack: $stackTrack');
    }
  }

  Future<void> subscribeToATopic(String topicName) async {
    await FirebaseMessaging.instance.subscribeToTopic(topicName);
  }

  Future<void> unSubscribeFromATopic(String topicName) async {
    await FirebaseMessaging.instance.unsubscribeFromTopic(topicName);
  }

  showInAppScreenNotification(
      RemoteMessage notification, BuildContext context) async {
    print("==============Background Notification============");
    String? senderID = notification.toMap()['data']['message'];
    String? notificationType = notification.toMap()['data']['type'];
    String? notificationId= notification.toMap()['data']['notificationId'];



    SchedulerBinding.instance.addPostFrameCallback((_) async {
     UserModel? user= await LocalStorageService.getSignUpModel();
      if(user!=null && user.userType==Constant.customerRole){
        Navigator.of(Constant.navState.currentContext!)
            .push(MaterialPageRoute(
            builder: (context) => CustomerNavBarPage()));
      }else{
        Navigator.of(Constant.navState.currentContext!)
            .push(MaterialPageRoute(
            builder: (context) => DriverNavBarPage()));
      }


    });
  }

  performAndManageLocalNotification(RemoteMessage message) async {
    print("==============Local Notification============");
    if(message.notification?.title=="Ride Request"){
      UserModel? userDetail = await LocalStorageService.getSignUpModel();
      Provider.of<RideProvider>(context,listen: false).getRideRequestMethod(uid: userDetail!.uid!);
    }

    showSimpleNotification(
      InkWell(
          onTap: () {
            //  PerformNotificationNavigation(notification);

          },
          child: Text(
            message.notification?.title ?? "",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          )),
      // leading: Text("leading"),
      // trailing: Text("trailing"),
      leading: Image.asset(
        "assets/images/applogoN.png",
        width: 40,
        height: 40,
      ),
      duration: const Duration(seconds: 5),
      subtitle: InkWell(
          onTap: () {

            // OverlaySupportEntry.of(context)!.dismiss();
            // PerformNotificationNavigation(notification);
          },
          child: Text(
            message.notification!.body ?? "",
            style:  TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w100,
              fontSize: 14.0,
            ),
          )),
      slideDismiss: true,
      background: Colors.white,
      // autoDismiss: true
    );
  }
}
