class ReportUser{
  String? id;
  String? rideId;
  String? reportTo;
  String? reportBy;
  String? report;
  int? timeStamp;
  ReportUser({this.id, this.rideId, this.reportTo, this.reportBy, this.report,this.timeStamp});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'rideId': rideId,
      'reportTo': reportTo,
      'reportBy': reportBy,
      'report': report,
      'timeStamp': timeStamp,
    };
  }

  factory ReportUser.fromMap(Map<String, dynamic> map) {
    return ReportUser(
      id: map['id']==null?"":map['id'] as String,
      rideId: map['rideId']==null?"":map['rideId'] as String,
      reportTo: map['reportTo']==null?"":map['reportTo'] as String,
      reportBy:map['reportBy']==null?"":map['reportBy'] as String,
      report:map['report']==null?"":map['report'] as String,
      timeStamp: map['timeStamp']==null?0:map['timeStamp'] as int,
    );
  }
}