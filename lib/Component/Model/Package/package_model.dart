class PackageModel{
  String? activePackage;
  int? timeStamp;
  // int? amount;

  PackageModel({this.activePackage, this.timeStamp,
    // required amount
  });

  Map<String, dynamic> toMap() {
    return {
      'activePackage': activePackage,
      'timeStamp': timeStamp,
      // 'depositAmount' : amount,
    };
  }


  factory PackageModel.fromMap(Map<String, dynamic> map) {
    return PackageModel(
      activePackage: map['activePackage'] == null ? "" : map['activePackage'] as String,
      timeStamp : map['timeStamp'] == null ? 0 : map['timeStamp'] as int,
      // amount :  map['depositAmount'] == null ? 0 : map['depositAmount'] as int,
    );
  }
}