
import '../Authentication/location.dart';

class RideRequestModel{
  String? id;
  String? rideId;
  String? driverId;
  String? rideType;
  LocationModel? sourceLocation;
  LocationModel? destinationLocation;
  int? price;
  int? timeStamp;

  RideRequestModel({this.id, this.rideId, this.driverId, this.sourceLocation,this.rideType,
      this.destinationLocation, this.price, this.timeStamp});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rideId': rideId,
      'driverId': driverId,
      'rideType': rideType,
      'sourceLocation': sourceLocation?.toMap(),
      'destinationLocation': destinationLocation?.toMap(),
      'price': price,
      'timeStamp': timeStamp,
    };
  }

  factory RideRequestModel.fromMap(Map map) {
    return RideRequestModel(
      id: map['id'] == null ? "" : map['id'] as String,
      rideId: map['rideId'] == null ? "" : map['rideId'] as String,
      driverId: map['driverId'] == null ? "" : map['driverId'] as String,
      rideType: map['rideType'] == null ? "" : map['rideType'] as String,
      price: map['price'] == null ? 0 : map['price'] as int,
      sourceLocation: map['sourceLocation'] == null ? null : toConvertyLocation(map['sourceLocation']),
      destinationLocation: map['destinationLocation'] == null ? null : toConvertyLocation(map['destinationLocation']),
      timeStamp: map['timeStamp']==null?0:map['timeStamp'] as int,
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