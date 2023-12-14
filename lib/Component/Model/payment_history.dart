class paymentHistory {
  String profielPic;
  String name;
  String type;
  String amount;
  String id;

//<editor-fold desc="Data Methods">
  paymentHistory({
    required this.profielPic,
    required this.name,
    required this.type,
    required this.amount,
    required this.id,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is paymentHistory &&
          runtimeType == other.runtimeType &&
          profielPic == other.profielPic &&
          name == other.name &&
          type == other.type &&
          amount == other.amount &&
          id == other.id);

  @override
  int get hashCode =>
      profielPic.hashCode ^
      name.hashCode ^
      type.hashCode ^
      amount.hashCode ^
      id.hashCode;

  @override
  String toString() {
    return 'paymentHistory{' +
        ' profielPic: $profielPic,' +
        ' name: $name,' +
        ' type: $type,' +
        ' amount: $amount,' +
        ' id: $id,' +
        '}';
  }

  paymentHistory copyWith({
    String? profielPic,
    String? name,
    String? type,
    String? amount,
    String? id,
  }) {
    return paymentHistory(
      profielPic: profielPic ?? this.profielPic,
      name: name ?? this.name,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'profielPic': this.profielPic,
      'name': this.name,
      'type': this.type,
      'amount': this.amount,
      'id': this.id,
    };
  }

  factory paymentHistory.fromMap(Map<String, dynamic> map) {
    return paymentHistory(
      profielPic: map['profielPic'] as String,
      name: map['name'] as String,
      type: map['type'] as String,
      amount: map['amount'] as String,
      id: map['id'] as String,
    );
  }

//</editor-fold>
}
