class ReviewModel{
  String? id;
  String? customerId;
  String? driverId;
  String? rideId;
  int? numberOfStar;
  int? timeStamp;

  ReviewModel({this.id,this.customerId, this.driverId, this.rideId, this.numberOfStar,
      this.timeStamp});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customerId': customerId,
      'driverId': driverId,
      'rideId': rideId,
      'numberOfStar': numberOfStar,
      'timeStamp': timeStamp,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id']==null?"":map['id'] as String,
      customerId: map['customerId']==null?"":map['customerId'] as String,
      driverId: map['driverId']==null?"":map['driverId'] as String,
      rideId:map['rideId']==null?"":map['rideId'] as String,
      numberOfStar:map['numberOfStar']==null?0:map['numberOfStar'] as int,
      timeStamp: map['timeStamp']==null?0:map['timeStamp'] as int,
    );
  }
}