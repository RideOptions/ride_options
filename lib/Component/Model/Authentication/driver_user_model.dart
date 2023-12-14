import '../deposit/deposit_model.dart';
import 'location.dart';

class DriverUserModel {
  String? uid;
  String? username;
  String? name;
  String? userType;
  String? phoneNumber;
  String? profilePicture;
  String? email;
  String? status;
  List<String>? deviceToken;
  String? vehiclePicture;
  int? nationalIdCardNumber;
  String? vehicleNumber;
  String? vehicleType;
  String? vehicleColor;
  List<String>? nationalIdCardPhotos;
  String? licencePhoto;
  LocationModel? location;
  bool? active;
  int? timeStamp;
  String? referralId;
  String? referralBalance;
  String? totalReferral;
  String? referredBy;

  DriverUserModel({
    this.uid,
    this.username,
    this.name,
    this.userType,
    this.phoneNumber,
    this.profilePicture,
    this.email,
    this.status,
    this.deviceToken,
    this.vehiclePicture,
    this.licencePhoto,
    this.nationalIdCardNumber,
    this.nationalIdCardPhotos,
    this.vehicleColor,
    this.vehicleNumber,
    this.vehicleType,
    this.location,
    this.active,
    this.timeStamp,
    this.referralId,
    this.referredBy,
    this.referralBalance,
    this.totalReferral,
    // this.depositAmount
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'name': name,
      'userType': userType,
      'phoneNumber': phoneNumber,
      'profilePicture': profilePicture,
      'deviceToken': deviceToken,
      'email': email,
      'status': status,
      'vehiclePicture': vehiclePicture,
      'nationalIdCardNumber': nationalIdCardNumber,
      'vehicleNumber': vehicleNumber,
      'vehicleType': vehicleType,
      'vehicleColor': vehicleColor,
      'nationalIdCardPhotos': nationalIdCardPhotos,
      'licencePhoto': licencePhoto,
      'active': active,
      'location': location?.toMap(),
      'timeStamp': timeStamp,
      // 'depositAmount': depositAmount,
      'referralId': referralId,
      'referredBy': referredBy,
      'totalReferral': totalReferral,
      'referralBalance': referralBalance,
    };
  }

  factory DriverUserModel.fromMap(Map map) {
    return DriverUserModel(
      uid: map['uid'] == null ? "" : map['uid'] as String,
      username: map['username'] == null ? "" : map['username'] as String,
      name: map['name'] == null ? "" : map['name'] as String,
      userType: map['userType'] == null ? "" : map['userType'] as String,
      phoneNumber:
          map['phoneNumber'] == null ? "" : map['phoneNumber'] as String,
      profilePicture:
          map['profilePicture'] == null ? "" : map['profilePicture'] as String,
      email: map['email'] == null ? "" : map['email'] as String,
      status: map['status'] == null ? "" : map['status'] as String,
      vehiclePicture:
          map['vehiclePicture'] == null ? "" : map['vehiclePicture'] as String,
      nationalIdCardNumber: map['nationalIdCardNumber'] == null
          ? 0
          : map['nationalIdCardNumber'] as int,
      vehicleNumber:
          map['vehicleNumber'] == null ? "" : map['vehicleNumber'] as String,
      vehicleType:
          map['vehicleType'] == null ? "" : map['vehicleType'] as String,
      vehicleColor:
          map['vehicleColor'] == null ? "" : map['vehicleColor'] as String,
      licencePhoto:
          map['licencePhoto'] == null ? "" : map['licencePhoto'] as String,
      active: map['active'] == null ? false : map['active'] as bool,
      deviceToken: toConvertyDeviceToken(map['deviceToken']),
      nationalIdCardPhotos:
          toConvertyNationalIdCardPhotos(map['nationalIdCardPhotos']),
      location:
          map['location'] == null ? null : toConvertyLocation(map['location']),
      timeStamp: map['timeStamp'] == null ? 0 : map['timeStamp'] as int,
      // depositAmount: map['depositAmount'] == null ? 0 : map['depositAmount'],
      referralId: map['referralId'] == null ? "" : map['referralId'] as String,
      referredBy: map['referredBy'] == null ? "" : map['referredBy'] as String,
      referralBalance: map['referralBalance'] == null ? "" : map['referralBalance'] as String,
      totalReferral: map['totalReferral'] == null ? "" : map['totalReferral'] as String,
    );
  }

  static List<String>? toConvertyDeviceToken(map) {
    if (map == null) {
      return [];
    }

    List<String> list = [];
    for (int i = 0; i < map.length; i++) {
      list.add(map[i]);
    }

    return list;
  }

  static List<String>? toConvertyNationalIdCardPhotos(map) {
    if (map == null) {
      return [];
    }

    List<String> list = [];
    for (int i = 0; i < map.length; i++) {
      list.add(map[i]);
    }

    return list;
  }

  static LocationModel toConvertyLocation(Map map) {
    return LocationModel(
      location: map['location'] == null ? "" : map['location'] as String,
      lat: map['lat'] == null ? 0.0 : map['lat'] as double,
      long: map['long'] == null ? 0.0 : map['long'] as double,
    );
  }

  static DepositModel toConveryDeposit(Map map) {
    return DepositModel(
      depositAmount:
          map['depositAmount'] == null ? "" : map['depositAmount'] as String,
      timeStamp: map['timeStamp'] == null ? 0 : map['timeStamp'] as int,
    );
  }
}
