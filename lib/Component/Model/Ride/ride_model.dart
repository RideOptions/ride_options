
import '../Authentication/location.dart';

class RideModel{
  String? id;
  String? acceptedBy;
  String? customerId;
  LocationModel? sourceLocation;
  LocationModel? destinationLocation;
  LocationModel? driverLocation;
  String? status;
  String? vehicleType;
  int? price;
  int? timeStamp;

  RideModel({
      this.id,
      this.acceptedBy,
      this.customerId,
      this.sourceLocation,
      this.destinationLocation,
      this.driverLocation,
      this.status,
      this.vehicleType,
      this.price,
      this.timeStamp});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'acceptedBy': acceptedBy,
      'customerId': customerId,
      'sourceLocation': sourceLocation?.toMap(),
      'destinationLocation': destinationLocation?.toMap(),
      'driverLocation': driverLocation?.toMap(),
      'status': status,
      'vehicleType': vehicleType,
      'price': price,
      'timeStamp': timeStamp,
    };
  }

  factory RideModel.fromMap(Map map) {
    return RideModel(
      id: map['id'] == null ? "" : map['id'] as String,
      acceptedBy: map['acceptedBy'] == null ? "" : map['acceptedBy'] as String,
      customerId: map['customerId'] == null ? "" : map['customerId'] as String,
      status: map['status'] == null ? "" : map['status'] as String,
      vehicleType: map['vehicleType'] == null ? "" : map['vehicleType'] as String,
      price: map['price'] == null ? 0 : map['price'] as int,
      sourceLocation: map['sourceLocation'] == null ? null : toConvertyLocation(map['sourceLocation']),
      destinationLocation: map['destinationLocation'] == null ? null : toConvertyLocation(map['destinationLocation']),
      driverLocation: map['driverLocation'] == null ? null : toConvertyLocation(map['driverLocation']),
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