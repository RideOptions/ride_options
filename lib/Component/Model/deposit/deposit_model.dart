class DepositModel {
  String? depositAmount;
  int? timeStamp;
  // int? amount;

  DepositModel({
    this.depositAmount,
    this.timeStamp,
    // required amount
  });

  Map<String, dynamic> toMap() {
    return {
      'depositAmount': depositAmount,
      'timeStamp': timeStamp,
      // 'depositAmount' : amount,
    };
  }

  factory DepositModel.fromMap(Map<String, dynamic> map) {
    return DepositModel(
      depositAmount:
          map['depositAmount'] == null ? "" : map['depositAmount'] as String,
      timeStamp: map['timeStamp'] == null ? 0 : map['timeStamp'] as int,
      // amount :  map['depositAmount'] == null ? 0 : map['depositAmount'] as int,
    );
  }
}
