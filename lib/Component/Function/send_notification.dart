import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<http.Response> sendNotificationPostRequest(
    String title, String des, List<String> deviceToken) async {
  var url = 'http://rideoptions.pk/admin/PushNotification.php';

  Map data = {
    "title": title,
    "body": des,
    "tokens": deviceToken,
    "sound":'resource://raw/noti_tune'
  };
  //encode Map to JSON
  var body = json.encode(data);

  var response = await http.post(Uri.parse(url),
      headers: {"Content-Type": "application/json"}, body: body);
  print("${response.statusCode}");
  print("${response.body}");
  return response;
}

Future<void> scheduledNotification(
    {required int hour,
    required int minute,
    required String title,
    required String description,
    required int weekday}) async {
  String timezone = await AwesomeNotifications().getUtcTimeZoneIdentifier();
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 123,
      channelKey: 'basic_channel',

      title: title,
      body: description,
      color: Colors.amber,
      customSound: 'assets/noti_tune.mp3',
    ),
    schedule: NotificationCalendar(
      allowWhileIdle: true,
      repeats: false,
      preciseAlarm: true,
      hour: hour,
      minute: minute,
      weekday: weekday,
      second: 0,
    ),
  );
}
