import 'package:flutter/cupertino.dart';

import '../Model/Authentication/user_model.dart';
import '../Model/Earning/earning_model.dart';
import '../Model/response_model.dart';
import '../Services/earning_service.dart';
import '../constant.dart';
class EarningProvider with ChangeNotifier{

  List<EarningModel>  earningList=[];
  bool earningListEmpty=false;
  double total=0.0;

  double get getTotal=> total;
  void setTotal(double value) {
    total = value;
    notifyListeners();
  }

  List<EarningModel> get getEarningList=> earningList;
  void setEarningList(List<EarningModel> value) {
    earningList = value;
    notifyListeners();
  }

  bool get getEarningListEmpty=> earningListEmpty;
  void setEarningListEmpty(bool value) {
    earningListEmpty = value;
    notifyListeners();
  }

  getEarningMethod({required UserModel user}) async{
    try{

      String path="";
     if(user.userType==Constant.customerRole){
       path="customerId";
     }else{
       path="driverId";
     }

      MyResponse response= await EarningService().getUserEarning(user.uid!,path);
      if(response.success){
        List<EarningModel> dummyList= response.data as List<EarningModel>;
        if(dummyList.isNotEmpty){
          setEarningList(dummyList);
          setEarningListEmpty(false);
          calculateTotal();
        }
      }else{
        earningList=[];
        setEarningListEmpty(true);
      }
    }catch(ex){
      print("Exception getActivitiesMethod:$ex");
    }
  }
  calculateTotal(){
    if(earningList.isNotEmpty){
      total=0.0;
      earningList.forEach((element) {
        total=total+element.price!;
      });
      notifyListeners();
    }
  }
}