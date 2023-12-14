class LocationModel{
  String? location;
  double? lat;
  double? long;

  LocationModel({this.location, this.lat, this.long});

  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'lat': lat,
      'long': long,
    };
  }

  factory LocationModel.fromMap(Map map) {
    return LocationModel(
      location: map['location'] as String,
      lat: map['lat'] as double,
      long: map['long'] as double,
    );
  }
}