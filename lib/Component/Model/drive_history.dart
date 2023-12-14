class DriveHistory {
  String amount;
  String id;

//<editor-fold desc="Data Methods">
  DriveHistory({
    required this.amount,
    required this.id,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriveHistory &&
          runtimeType == other.runtimeType &&
          amount == other.amount &&
          id == other.id);

  @override
  int get hashCode => amount.hashCode ^ id.hashCode;

  @override
  String toString() {
    return 'DriveHistory{' + ' amount: $amount,' + ' id: $id,' + '}';
  }

  DriveHistory copyWith({
    String? amount,
    String? id,
  }) {
    return DriveHistory(
      amount: amount ?? this.amount,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'amount': this.amount,
      'id': this.id,
    };
  }

  factory DriveHistory.fromMap(Map<String, dynamic> map) {
    return DriveHistory(
      amount: map['amount'] as String,
      id: map['id'] as String,
    );
  }

//</editor-fold>
}
