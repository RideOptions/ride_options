class VehicleRateModel{
  String? id;
  String? vehicleName;
  int? ratePerKilometer;

  VehicleRateModel({this.id, this.vehicleName, this.ratePerKilometer});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'vehicleName': vehicleName,
      'ratePerKilometer': ratePerKilometer,
    };
  }

  factory VehicleRateModel.fromMap(Map map) {
    return VehicleRateModel(
      id:  map['id'] == null ? "" : map['id'] as String,
      vehicleName: map['vehicleName'] == null ? "" : map['vehicleName'] as String,
      ratePerKilometer:map['ratePerKilometer'] == null ? 0 : map['ratePerKilometer'] as int,
    );
  }

}