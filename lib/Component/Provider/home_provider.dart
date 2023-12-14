import 'package:flutter/cupertino.dart';
import '../Model/Authentication/location.dart';
import '../Model/response_model.dart';
import '../Services/home_service.dart';

class HomeProvider with ChangeNotifier{
  List<LocationModel>  suggestionList=[];
  bool suggestionListEmpty=false;
  List<LocationModel> get getSuggestionList=> suggestionList;
  void setSuggestionList(List<LocationModel> value) {
    suggestionList = value;
    notifyListeners();
  }

  bool get getSuggestionListEmpty=> suggestionListEmpty;
  void setSuggestionListEmpty(bool value) {
    suggestionListEmpty = value;
    notifyListeners();
  }
  getSuggestionMethod({required String uid}) async{
    try{
      MyResponse response= await HomeService().getUserSuggestions(uid);
      if(response.success){
        List<LocationModel> dummyList= response.data as List<LocationModel>;
        if(dummyList.isNotEmpty){
          dummyList=dummyList.reversed.toList();
          setSuggestionList(dummyList);
          setSuggestionListEmpty(false);
        }
      }else{
        suggestionList=[];
        setSuggestionListEmpty(true);
      }
    }catch(ex){
      print("Exception getActivitiesMethod:$ex");
    }
  }
}