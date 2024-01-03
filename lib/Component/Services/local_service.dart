import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../Model/Authentication/user_model.dart';

class LocalStorageService {
  static Future<void> setSignUpModel(UserModel data) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString("SignUpModel", jsonEncode(data.toMap()));
  }

  static Future<UserModel?> getSignUpModel() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    UserModel? model;
    String? userPref = pref.getString('SignUpModel');
    if (userPref != null) {
      Map<String, dynamic> userMap =
          jsonDecode(userPref) as Map<String, dynamic>;
      model = UserModel.fromMap(userMap);
    } else {
      print("sign up model pref is null");
    }
    return model;
  }

  static Future<void> deleteSignUpModel() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("SignUpModel");
  }
}
