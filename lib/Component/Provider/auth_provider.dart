import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rideoptions/main.dart';
import '../../Screens/HomePage/BottomNavBar/customer_nav_bar_page.dart';
import '../../role_screen.dart';
import '../Dialogue/app_dialogue.dart';
import '../Model/Authentication/user_model.dart';
import '../Services/local_service.dart';
import '../common_function.dart';
import '../constant.dart';

class AuthProvider with ChangeNotifier {
  File? profilePicture;
  File? get getProfilePicture => profilePicture;
  void setProfilePicture(File? value) {
    profilePicture = value;
    notifyListeners();
  }

  File? vehiclePicture;
  File? get getVehiclePicture => vehiclePicture;
  void setVehiclePicture(File? value) {
    vehiclePicture = value;
    notifyListeners();
  }

  File? frontCNICPicture;
  File? get getFrontCNICPicture => frontCNICPicture;
  void setFrontCNICPicture(File? value) {
    frontCNICPicture = value;
    notifyListeners();
  }

  File? backCNICPicture;
  File? get getBackCNICPicture => backCNICPicture;
  void setBackCNICPicture(File? value) {
    backCNICPicture = value;
    notifyListeners();
  }

  File? vehicleDocuments;
  File? get getVehicleDocuments => vehicleDocuments;
  void setVehicleDocuments(File? value) {
    vehicleDocuments = value;
    notifyListeners();
  }

  File? licencePicture;
  File? get getLicencePicture => licencePicture;
  void setLicencePicture(File? value) {
    licencePicture = value;
    notifyListeners();
  }

  submitUserDetailsMethod(
      {required BuildContext context, required UserModel model}) async {
    try {
      List<String> deviceToken = [];
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("SaTtAaYz").child('users');
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        deviceToken.add(token);
        model.deviceToken = deviceToken;
      }
      await ref.child(model.uid!).set(model.toMap());
      if (model.userType == Constant.customerRole) {
        await CommonFunctions().addCustomerDeviceToken(model);
      } else {
        await CommonFunctions().addDriverDeviceToken(model);
      }

      await LocalStorageService.setSignUpModel(model);
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CustomerNavBarPage()),
      );
    } catch (ex) {
      Navigator.pop(context);
      print("Exception by submitUserDetailsMethod $ex");
    }
  }

  submitDriverUserDetailsMethod(
      {required BuildContext context, required UserModel model}) async {
    try {
      List<String> deviceToken = [];
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("SaTtAaYz").child('driverUsers');
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        deviceToken.add(token);
        model.deviceToken = deviceToken;
      }
      await ref.child(model.uid!).set(model.toMap());
      if (model.userType == Constant.customerRole) {
        await CommonFunctions().addCustomerDeviceToken(model);
      } else {
        await CommonFunctions().addDriverDeviceToken(model);
      }
      // await LocalStorageService.setSignUpModel(model);
      Navigator.pop(context);
      await showDialog(
        context: context,
        builder: (ctx) => AppDialogue(
          title: "Alert",
          description: "Your account will be approved by the admin soon.",
          cancelBtnVisible: false,
          confirmBthText: "ok",
        ),
      );
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => RolePage()),
          (Route<dynamic> route) => false);
    } catch (ex) {
      Navigator.pop(context);
      print("Exception by submitUserDetailsMethod $ex");
    }
  }

  updateDriverUserDetailsMethod(
      {required BuildContext context, required UserModel model}) async {
    try {
      List<String> deviceToken = [];
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("SaTtAaYz").child('driverUsers');
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        deviceToken.add(token);
        model.deviceToken = deviceToken;
      }
      await ref.child(model.uid!).update(model.toMap());
      if (model.userType == Constant.customerRole) {
        await CommonFunctions().addCustomerDeviceToken(model);
      } else {
        await CommonFunctions().addDriverDeviceToken(model);
      }
      // await LocalStorageService.setSignUpModel(model);
      Navigator.pop(context);
      await showDialog(
        context: context,
        builder: (ctx) => AppDialogue(
          title: "Alert",
          description:
              "Your updated documents will be submitted to the admin. Kindly await approval.",
          cancelBtnVisible: false,
          confirmBthText: "ok",
        ),
      );
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => RolePage()),
          (Route<dynamic> route) => false);
    } catch (ex) {
      Navigator.pop(context);
      print("Exception by submitUserDetailsMethod $ex");
    }
  }

  TextEditingController phoneNoController = TextEditingController();
  // this fucntion for otp
  Future<void> sendOTP(String number) async {
    var rndm = Random().nextInt(9000) + 1000;
    String phoneNumber = "92" + "$number";
    random = rndm;
    print("otp: $rndm");
    String apiUrl = 'https://secure.h3techs.com/sms/api/send';
    String email = "hacktonow@gmail.com"; // Replace with your email
    String key =
        "12309f744b93034a80e6f61353ec098372"; // Replace with your API key

    // Get phone number from the user input

    // Construct the request payload
    Map<String, String> payload = {
      'email': email,
      'key': key,
      'mask': '81478', // Replace with your desired mask
      'to': phoneNumber,
      'message':
          'Your OTP code for Ride Options is $random. Contact us at +923299558899 or rideoptions.pk ', // Customize your OTP message
    };

    try {
      // Send POST request to the API

      final http.Response response = await http.post(
        Uri.parse(apiUrl),
        body: payload,
      );

      if (response.statusCode == 200) {
        // Request was successful, you can handle the response here
        print('OTP Sent Successfully');
        print('Response: ${response.body}');
      } else {
        // Request failed, handle the error
        print('Failed to send OTP');
        print('Error: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      // Handle exceptions
      print('Exception during OTP sending: $e');
    }
  }
}
