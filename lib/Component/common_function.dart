import 'dart:io';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../role_screen.dart';
import 'Model/Authentication/user_model.dart';
import 'Services/authenticate_service.dart';
import 'Services/global_service.dart';
import 'Services/local_service.dart';

class CommonFunctions {
  static List<String> phoneCodeList = [
    "+92",
  ];
  static bool chatScreen = false;

  Future<String> submitSubscription(
      {required File file,
      String? filename,
      String? token,
      String? type,
      String? extension}) async {
    ///MultiPart request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("https://rideoptions.pk/admin/upload.php"),
    );
    Map<String, String> headers = {"Content-type": "multipart/form-data"};
    request.files.add(
      http.MultipartFile(
        'file',
        file.readAsBytes().asStream(),
        file.lengthSync(),
        filename: filename,
        // contentType: MediaType(type, extension),
      ),
    );
    request.headers.addAll(headers);
    request.fields
        .addAll({"name": "test", "email": "test@gmail.com", "id": "12345"});
    print("request: " + request.url.toString());

    var res = await request.send();
    print("This is response:" + res.toString());
    final respStr = await res.stream.bytesToString();
    // List<String> values = [];
    // print(respStr);
    // Map<String, dynamic> map = jsonDecode(respStr);
    // print(map["fileUrl"]);
    // print(res.statusCode);
    return respStr;
  }

  void unFocus(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.focusedChild?.unfocus();
    }
  }

  Future<File?> getFromGallery() async {
    File? imageFile;

    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      print("imageUrl: ${imageFile.path}");
    }
    return imageFile;
  }

  Future<File?> getFromCamera() async {
    File? imageFile;
    PermissionStatus permissionStatus = await Permission.camera.request();
    print("camera permissionStatus:$permissionStatus");
    if (permissionStatus.isPermanentlyDenied || permissionStatus.isDenied) {
      await openAppSettings();
    } else {
      PickedFile? pickedFile = await ImagePicker().getImage(
        source: ImageSource.camera,
        maxWidth: 1800,
        maxHeight: 1800,
      );

      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        imageFile = await FlutterExifRotation.rotateImage(path: imageFile.path);
        print("imageUrl: ${imageFile.path}");
      }
    }

    return imageFile;
  }

  bool emailValidation(String? email) {
    bool isValid = false;
    isValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email!);
    return isValid;
  }

  addCustomerDeviceToken(UserModel? userModel) async {
    try {
      print("device token user: ${userModel?.toMap()}");
      List<String>? list = [];
      bool isAlreadyExit = false;
      String? token = await FirebaseMessaging.instance.getToken();
      if (userModel!.deviceToken != null) {
        list = userModel.deviceToken;
        list?.forEach((element) {
          if (element == token) {
            isAlreadyExit = true;
          }
        });
        if (isAlreadyExit == false) {
          list?.add(token!);
          print("if click update");
          await FirebaseDatabase.instance
              .ref()
              .child('SaTtAaYz')
              .child("users")
              .child(userModel.uid!)
              .update({
            "deviceToken": list,
          });
        }
      } else {
        list.add(token!);
        print("else click update");
        await FirebaseDatabase.instance
            .ref()
            .child('SaTtAaYz')
            .child("users")
            .child(userModel.uid!)
            .update({
          "deviceToken": list,
        });
      }
    } catch (ex) {
      print("Exception set device token: ${ex}");
    }
  }

  removeCustomerDeviceToken(String? uid) async {
    try {
      print("removeDeviceToken");
      List<String>? list = [];
      String? token = await FirebaseMessaging.instance.getToken();
      UserModel? userModel =
          await AuthenticateService().getCustomerUserDetails(uid);
      print(token);
      print(userModel?.toMap());
      if (userModel!.deviceToken!.isNotEmpty) {
        list = userModel.deviceToken;
        print("device token list count:${list}");
        list?.removeWhere((element) => element == token);
        print("count: ${list}");
        await FirebaseDatabase.instance
            .ref()
            .child('SaTtAaYz')
            .child("users")
            .child(userModel.uid!)
            .update({
          "deviceToken": list,
        });
      }
    } catch (ex) {
      print("Exception remove device token: ${ex}");
    }
  }

  static deleteCustomerSessionAndLogout(
      {required String uid, required BuildContext context}) async {
    try {
      await CommonFunctions().removeCustomerDeviceToken(uid);
      await LocalStorageService.deleteSignUpModel();

      print("logout");
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => RolePage()),
          (Route<dynamic> route) => false);
    } catch (ex) {
      print("Exception deleteSessionAndLogout $ex");
    }
  }

  static deleteDriverSessionAndLogout(
      {required String uid, required BuildContext context}) async {
    try {
      await CommonFunctions().removeDriverDeviceToken(uid);
      await LocalStorageService.deleteSignUpModel();
      print("logout");
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => RolePage()),
          (Route<dynamic> route) => false);
    } catch (ex) {
      print("Exception deleteSessionAndLogout $ex");
    }
  }

  addDriverDeviceToken(UserModel? userModel) async {
    try {
      print("device token user: ${userModel?.toMap()}");
      List<String>? list = [];
      bool isAlreadyExit = false;
      String? token = await FirebaseMessaging.instance.getToken();
      if (userModel!.deviceToken != null) {
        list = userModel.deviceToken;
        list?.forEach((element) {
          if (element == token) {
            isAlreadyExit = true;
          }
        });
        if (isAlreadyExit == false) {
          list?.add(token!);
          print("if click update");
          await FirebaseDatabase.instance
              .ref()
              .child('SaTtAaYz')
              .child("driverUsers")
              .child(userModel.uid!)
              .update({
            "deviceToken": list,
          });
        }
      } else {
        list.add(token!);
        print("else click update");
        await FirebaseDatabase.instance
            .ref()
            .child('SaTtAaYz')
            .child("driverUsers")
            .child(userModel.uid!)
            .update({
          "deviceToken": list,
        });
      }
    } catch (ex) {
      print("Exception set device token: ${ex}");
    }
  }

  removeDriverDeviceToken(String? uid) async {
    try {
      print("removeDeviceToken");
      List<String>? list = [];
      String? token = await FirebaseMessaging.instance.getToken();
      UserModel? userModel =
          await AuthenticateService().getDriverUserDetails(uid);
      print(token);
      print(userModel?.toMap());
      if (userModel!.deviceToken!.isNotEmpty) {
        list = userModel.deviceToken;
        print("device token list count:${list}");
        list?.removeWhere((element) => element == token);
        print("count: ${list}");
        await FirebaseDatabase.instance
            .ref()
            .child('SaTtAaYz')
            .child("driverUsers")
            .child(userModel.uid!)
            .update({
          "deviceToken": list,
        });
      }
    } catch (ex) {
      print("Exception remove device token: ${ex}");
    }
  }

  Future<Map<Permission, PermissionStatus>> permissionServices() async {
    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      //add more permission to request here.
    ].request();

    return statuses;
  }

  Future<Position?> getCurrentLocation() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print("current location: ${position}");
      return position;
    } catch (ex) {
      print("====Ex in location get: $ex");
      //Navigator.pop(context);
    }
  }

  Future<String?> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    String? address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    return address;
  }

  Future<String?> getAddressFromLatLongs(double lat, double long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    print(placemarks);
    Placemark place = placemarks[0];
    String? address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    return address;
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    const double radiusOfEarth = 6371; // Radius of the Earth in kilometers
    double latDistance = _toRadians(lat2 - lat1);
    double lonDistance = _toRadians(lon2 - lon1);

    // Haversine formula
    double a = sin(latDistance / 2) * sin(latDistance / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(lonDistance / 2) *
            sin(lonDistance / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return radiusOfEarth * c; // Distance in kilometers
  }

  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  // double calculateDistance(lat1, lon1, lat2, lon2) {
  //   // var p = 0.017453292519943295;
  //   // var a = 0.5 -
  //   //     cos((lat2 - lat1) * p) / 2 +
  //   //     cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  //   // return 12742 * asin(sqrt(a));
  //   // Radius of the Earth in kilometers
  //   const double radiusOfEarth = 6371;
  //   double latDistance = _toRadians(lat2 - lat1);
  //   double lonDistance = _toRadians(lon2 - lon1);
  //
  //   // Haversine formula
  //   double a = sin(latDistance / 2) * sin(latDistance / 2)
  //       + cos(_toRadians(lat1)) * cos(_toRadians(lat2))
  //           * sin(lonDistance / 2) * sin(lonDistance / 2);
  //   double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  //
  //   return radiusOfEarth * c;
  //
  // }

  String getDateTimeByTimeStamp(int? timestamp, String format) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp!);
    final DateFormat formatter = DateFormat(format);
    String formatted = formatter.format(date);
    // print("date formatted: $formatted");
    return formatted;
  }

  Future<String> uploadMp3(File file) async {
    List<String> imageNameList = file.toString().split('/');
    String url = await submitSubscription(
        file: file,
        filename: imageNameList[imageNameList.length - 1].toString().substring(
            0, imageNameList[imageNameList.length - 1].toString().length - 1),
        token: "notoken",
        type: 'mp3',
        extension: 'mp3');
    return url;
  }

  Future<void> makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  launchEmailSubmission() async {
    final Uri params = Uri(
        scheme: 'mailtob ',
        path: 'rideoptions.pk@gmail.com',
        queryParameters: {'subject': '', 'body': ''});
    String url = params.toString();
    if (await canLaunchUrl(params)) {
      await launchUrl(params);
    } else {
      print('Could not launch $url');
    }
  }

  Future<int> dailyPackageRemainingTime(int time) async {
    int currentTime = await GlobalService().getCurrentTime();
    DateTime fromTime = DateTime.fromMillisecondsSinceEpoch(currentTime);
    DateTime toTime = DateTime.fromMillisecondsSinceEpoch(time);
    int diff = fromTime.difference(toTime).inSeconds;
    int remainingTime = 86400 - diff;

    return remainingTime;
  }

  Future<int> weeklyPackageRemainingTime(int time) async {
    int currentTime = await GlobalService().getCurrentTime();
    DateTime fromTime = DateTime.fromMillisecondsSinceEpoch(currentTime);
    DateTime toTime = DateTime.fromMillisecondsSinceEpoch(time);
    int diff = fromTime.difference(toTime).inSeconds;
    int remainingTime = 604800 - diff;
    return remainingTime;
  }

  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      print('not connected');
      return false;
    }
  }
}
