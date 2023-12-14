class Withdraw{
  String amount;
  String accountNumber;
  String accountTitle;
  String walletName;
  String timestamp;
  String uid;

//<editor-fold desc="Data Methods">

  Withdraw({
    required this.amount,
    required this.accountNumber,
    required this.accountTitle,
    required this.walletName,
    required this.timestamp,
    required this.uid,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Withdraw &&
          runtimeType == other.runtimeType &&
          amount == other.amount &&
          accountNumber == other.accountNumber &&
          accountTitle == other.accountTitle &&
          walletName == other.walletName &&
          timestamp == other.timestamp &&
          uid == other.uid);

  @override
  int get hashCode =>
      amount.hashCode ^
      accountNumber.hashCode ^
      accountTitle.hashCode ^
      walletName.hashCode ^
      timestamp.hashCode ^
      uid.hashCode;

  @override
  String toString() {
    return 'Withdraw{' +
        ' amount: $amount,' +
        ' accountNumber: $accountNumber,' +
        ' accountTitle: $accountTitle,' +
        ' walletName: $walletName,' +
        ' timestamp: $timestamp,' +
        ' uid: $uid,' +
        '}';
  }

  Withdraw copyWith({
    String? amount,
    String? accountNumber,
    String? accountTitle,
    String? walletName,
    String? timestamp,
    String? uid,
  }) {
    return Withdraw(
      amount: amount ?? this.amount,
      accountNumber: accountNumber ?? this.accountNumber,
      accountTitle: accountTitle ?? this.accountTitle,
      walletName: walletName ?? this.walletName,
      timestamp: timestamp ?? this.timestamp,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': this.amount,
      'accountNumber': this.accountNumber,
      'accountTitle': this.accountTitle,
      'walletName': this.walletName,
      'timestamp': this.timestamp,
      'uid': this.uid,
    };
  }

  factory Withdraw.fromMap(Map<String, dynamic> map) {
    return Withdraw(
      amount: map['amount'] as String,
      accountNumber: map['accountNumber'] as String,
      accountTitle: map['accountTitle'] as String,
      walletName: map['walletName'] as String,
      timestamp: map['timestamp'] as String,
      uid: map['uid'] as String,
    );
  }

//</editor-fold>
}