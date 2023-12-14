import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Dialogue/application_alert_dialogue.dart';
import '../theme/text_style_theme.dart';

class ConnectivityProvider with ChangeNotifier{
  StreamSubscription? internetSubscription;
  Connectivity connectivity = Connectivity();
  bool checkInternet = false;


  bool get getCheckInternet=> checkInternet;
  void setCheckInternet(bool value) {
    checkInternet = value;
    notifyListeners();
  }
  checkInternetConnectionsLost(context)async{
    print("internet checker function");
    // _connectivity.checkConnectivity();
    internetSubscription = connectivity.onConnectivityChanged.listen((event) {
      if(event == ConnectivityResult.wifi){
        print("you are connected with Wifi");

        // checkBtn.value = false;
        if(getCheckInternet){
          Navigator.pop(context);
        }
        setCheckInternet(false);


        // update();
      }else if(event == ConnectivityResult.mobile){
        print("you are connected with Mobile data");
        if(getCheckInternet){
          Navigator.pop(context);
        }
        setCheckInternet(false);
      }else{
        print('you have lost your internet connection');
        setCheckInternet(true);
        showDialog(
            context: context,
            barrierDismissible: false,

            builder: (BuildContext context) {
              return ApplicationAlertDialogue(
                dialogueHeight: 230,
                imageWidth: 100,
                imageHeight: 100,
                buttonText: "Try Again",
                imagePath: "assets/images/error_icon.png",
                title: "Internet Connection!",
                titleStyle: blackTextRegularIn16px(),
                description: "please check your internet connection.",
                descriptionStyle: greyTextRegularIn14px(),
                richTextFlag: false,
                cancelBtnVisible: false,
                crossBtnVisible: false,
                onTap: () async {
                  // if(Platform.isIOS){
                  //   exit(0);
                  // }else{
                  //   SystemNavigator.pop();
                  // }

                },
              );
            });


      }
      // setState(() {
      // });
    });
  }

}