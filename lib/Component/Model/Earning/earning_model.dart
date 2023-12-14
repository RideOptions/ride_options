
import '../Authentication/location.dart';

class EarningModel{
  String? id;
  String? driverId;
  String? customerId;
  String? rideId;
  int? price;
  String? status;
  String? vehicleType;
  LocationModel? pickedUpLocation;
  LocationModel? destinationLocation;
  int? startTime;
  int? endTime;

  EarningModel({
      this.id,
      this.driverId,
      this.customerId,
      this.rideId,
      this.price,
      this.status,
      this.vehicleType,
      this.pickedUpLocation,
      this.destinationLocation,
      this.startTime,
      this.endTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'driverId': driverId,
      'customerId': customerId,
      'rideId': rideId,
      'price': price,
      'status': status,
      'vehicleType': vehicleType,
      'pickedUpLocation': pickedUpLocation?.toMap(),
      'destinationLocation': destinationLocation?.toMap(),
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  factory EarningModel.fromMap(Map map) {
    return EarningModel(
      id: map['id'] == null ? "" : map['id'] as String,
      driverId: map['driverId'] == null ? "" : map['driverId'] as String,
      customerId: map['customerId'] == null ? "" : map['customerId'] as String,
      rideId: map['rideId'] == null ? "" : map['rideId'] as String,
      price: map['price'] == null ? 0 : map['price'] as int,
      status: map['status']==null?"":map['status'] as String,
      vehicleType: map['vehicleType']==null?"":map['vehicleType'] as String,
      pickedUpLocation: map['pickedUpLocation'] == null ? null : toConvertyLocation(map['pickedUpLocation']),
      destinationLocation: map['destinationLocation'] == null ? null : toConvertyLocation(map['destinationLocation']),
      startTime: map['startTime']==null?0:map['startTime'] as int,
      endTime: map['endTime']==null?0:map['endTime'] as int,
    );
  }

  static LocationModel toConvertyLocation(Map map) {
    return LocationModel(
      location: map['location'] == null ? "" : map['location'] as String,
      lat: map['lat'] == null ? 0.0 : map['lat'] as double,
      long: map['long'] == null ? 0.0 : map['long'] as double,
    );
  }

}