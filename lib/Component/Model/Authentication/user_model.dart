import 'package:rideoptions/Component/Model/deposit/deposit_model.dart';

import '../Package/package_model.dart';
import 'location.dart';

class UserModel {
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
  String? documentPhoto;
  LocationModel? location;
  bool? active;
  PackageModel? package;
  bool? Mini;
  bool? RideGo;
  bool? RideX;
  int? timeStamp;
  String? amount;
  DepositModel? deposit;
  String? referralId;
  String? referralBalance;
  String? totalReferral;
  String? referredBy;

  UserModel(
      {this.uid,
      this.username,
      this.name,
      this.userType,
      this.phoneNumber,
      this.Mini,
      this.RideGo,
      this.RideX,
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
      this.documentPhoto,
      this.vehicleType,
      this.location,
      this.active,
      this.package,
      this.timeStamp,
      this.deposit,
      this.amount,
      this.referralId,
      this.referredBy,
      this.referralBalance,
      this.totalReferral,
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
      'documentPhoto': documentPhoto,
      'active': active,
      'Mini': Mini,
      'RideGo': RideGo,
      'RideX': RideX,
      'location': location?.toMap(),
      'package': package?.toMap(),
      'deposit': deposit?.toMap(),
      'timeStamp': timeStamp,
      'amount': amount,
      'referralId': referralId,
      'referredBy': referredBy,
      'totalReferral': totalReferral,
      'referralBalance': referralBalance,
    };
  }

  factory UserModel.fromMap(Map map) {
    return UserModel(
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
      documentPhoto:
          map['documentPhoto'] == null ? "" : map['documentPhoto'] as String,
      active: map['active'] == null ? false : map['active'] as bool,
      Mini: map['Mini'] == null ? false : map['Mini'] as bool,
      RideGo: map['RideGo'] == null ? false : map['RideGo'] as bool,
      RideX: map['RideX'] == null ? false : map['RideX'] as bool,
      deviceToken: toConvertyDeviceToken(map['deviceToken']),
      nationalIdCardPhotos:
          toConvertyNationalIdCardPhotos(map['nationalIdCardPhotos']),
      location:
          map['location'] == null ? null : toConvertyLocation(map['location']),
      package:
          map['package'] == null ? null : toConvertyPackage(map['package']),
      deposit:
          map['deposit'] == null ? null : toConvertyDeposit(map['deposit']),
      timeStamp: map['timeStamp'] == null ? 0 : map['timeStamp'] as int,
      amount: map['amount'] == null ? "" : map['amount'] as String,
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

  static PackageModel toConvertyPackage(Map map) {
    return PackageModel(
      activePackage:
          map['activePackage'] == null ? "" : map['activePackage'] as String,
      timeStamp: map['timeStamp'] == null ? 0 : map['timeStamp'] as int,
      // amount :  map['depositAmount'] == null ? 0 : map['depositAmount'] as int,
    );
  }

  static DepositModel toConvertyDeposit(Map map) {
    return DepositModel(
      depositAmount:
          map['depositAmount'] == null ? "" : map['depositAmount'] as String,
      timeStamp: map['timeStamp'] == null ? 0 : map['timeStamp'] as int,
      // amount :  map['depositAmount'] == null ? 0 : map['depositAmount'] as int,
    );
  }
}
