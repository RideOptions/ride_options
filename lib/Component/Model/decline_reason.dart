class declineReason {
  String number;
  String otp;

//<editor-fold desc="Data Methods">
  declineReason({
    required this.number,
    required this.otp,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is declineReason &&
          runtimeType == other.runtimeType &&
          number == other.number &&
          otp == other.otp);

  @override
  int get hashCode => number.hashCode ^ otp.hashCode;

  @override
  String toString() {
    return 'declineReason{' + ' number: $number,' + ' otp: $otp,' + '}';
  }

  declineReason copyWith({
    String? number,
    String? otp,
  }) {
    return declineReason(
      number: number ?? this.number,
      otp: otp ?? this.otp,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'number': this.number,
      'otp': this.otp,
    };
  }

  factory declineReason.fromMap(Map<String, dynamic> map) {
    return declineReason(
      number: map['number'] as String,
      otp: map['otp'] as String,
    );
  }

//</editor-fold>
}
