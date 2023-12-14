import 'package:flutter/cupertino.dart';

class AudioMessageController with ChangeNotifier {
  String? currentPlayedAudioId;
  String? get getCurrentPlayedAudioId=> currentPlayedAudioId;
  void setCurrentPlayedAudioId(String? value) {
    currentPlayedAudioId = value;
    notifyListeners();
  }

  bool callScreenVisible=false;
  bool get getCallScreenVisible=> callScreenVisible;
  void setCallScreenVisible(bool value) {
    callScreenVisible = value;
    notifyListeners();
  }

}