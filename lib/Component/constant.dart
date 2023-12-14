import 'package:flutter/material.dart';

class Constant{
  static final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
  static const String customerRole="customer";
  static const String driverRole="driver";

  static const String accountPendingStatus="pending";
  static const String accountApprovedStatus="approve";
  static const String accountCancelStatus="cancel";
  static const String accountBlockStatus="block";

  // static const String kGoogleMapKey="AIzaSyDreums8xvE7bQvT7ydFDG1WsZsC8VnaMI";
  static const String kGoogleMapKey="AIzaSyCjxRhtdw74nJ9YdYaGjvY5IZUEA5Ux0JA";

  static const String ridePendingStatus="pending";
  static const String updatePendingStatus="pending";
  static const String rideAcceptStatus="accept";
  static const String ridePickedUpStatus="pickUp";
  static const String rideCompletedStatus="completed";
  static const String rideCancelStatus="cancel";

  static const String bikeVehicleType="MotorBike";
  static const String RickshawVehicleType="Rickshaw";
  static const String miniVehicleType="Mini";
  static const String rideGoVehicleType="RideGo";
  static const String rideXVehicleType="RideX";

  static const String dailyPackageStatus="daily";
  static const String weeklyPackageStatus="weekly";
}

