import 'package:flutter/foundation.dart';
import '../Model/Earning/earning_model.dart';
import '../Model/response_model.dart';
import '../Services/activity_service.dart';
import '../common_function.dart';

class ActivityProvider with ChangeNotifier{

  List<EarningModel>  activitiesList=[];
  List<EarningModel>  activitiesHistoryList=[];
  List<EarningModel>  activitiesFilterList=[];
  DateTime  startDate=DateTime.now();
  DateTime  endDate=DateTime.now();
  bool activitiesListEmpty=false;

  List<EarningModel> get getActivitiesFilterList=> activitiesFilterList;
  void setActivitiesFilterList(List<EarningModel> value) {
    activitiesFilterList = value;
    notifyListeners();
  }

  List<EarningModel> get getActivitiesHistoryList=> activitiesHistoryList;
  void setActivitiesHistoryList(List<EarningModel> value) {
    activitiesHistoryList = value;
    notifyListeners();
  }


  List<EarningModel> get getActivitiesList=> activitiesList;
  void setActivitiesList(List<EarningModel> value) {
    activitiesList = value;
    notifyListeners();
  }

  bool get getActivitiesListEmpty=> activitiesListEmpty;
  void setActivitiesListEmpty(bool value) {
    activitiesListEmpty = value;
    notifyListeners();
  }

  getActivitiesMethod({required String uid}) async{
    try{
      MyResponse response= await ActivityService().getUserActivities(uid);
      if(response.success){
        List<EarningModel> dummyList= response.data as List<EarningModel>;
        if(dummyList.isNotEmpty){
          setActivitiesHistoryList(dummyList);
          dummyList= dummyList.take(10).toList();
          setActivitiesList(dummyList);
          setActivitiesListEmpty(false);
        }
      }else{
        activitiesList=[];
        setActivitiesListEmpty(true);
      }
    }catch(ex){
      print("Exception getActivitiesMethod:$ex");
    }
  }

 Future<bool> filterActivityHistoryMethod()async{
    try{
        List<EarningModel> dummyList=[];
        activitiesHistoryList.forEach((element){
        String day=  CommonFunctions().getDateTimeByTimeStamp(element.startTime, 'dd');
        String month=  CommonFunctions().getDateTimeByTimeStamp(element.startTime, 'MM');
        String year=  CommonFunctions().getDateTimeByTimeStamp(element.startTime, 'yyyy');
       DateTime date= DateTime(int.parse(year),int.parse(month),int.parse(day));
         print("Start date: $startDate");
         print("end date $endDate");
         if((date.isAfter(startDate) || date.isAtSameMomentAs(startDate) ) &&  (date.isBefore(endDate)||date.isAtSameMomentAs(endDate))){
           print("date matched $date");
           dummyList.add(element);

         }

        });
        if(dummyList.isNotEmpty){
          setActivitiesFilterList(dummyList);
          print("dummyList Count is: ${activitiesFilterList.length}");
          return true;
        }
        else{
          return false;
        }


    }catch(ex){
      print("Exception filterActivityHistoryMethod: $ex");
      return false;
    }
  }

}