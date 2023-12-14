import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../Screens/HomePage/NavBarPages/TripDetails/filter_trip_page.dart';
import '../Common_Widget/button_widget.dart';
import '../Provider/activity_provider.dart';
import '../common_function.dart';
import '../theme/app_theme.dart';
import '../theme/text_style_theme.dart';

class SelectTripRange extends StatefulWidget {
  const SelectTripRange({Key? key}) : super(key: key);

  @override
  State<SelectTripRange> createState() => _SelectTripRangeState();
}

class _SelectTripRangeState extends State<SelectTripRange> {
  DateTime nowDate = DateTime.now();
  ActivityProvider? activityProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      initializeComponent();
    });
  }


  Future<void> _selectDate(BuildContext context,bool startDateCheck) async {

    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: startDateCheck?DateTime.now(): activityProvider!.startDate,
      firstDate: startDateCheck?DateTime(2022): activityProvider!.startDate,
      lastDate:DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor, // <-- SEE HERE
              onPrimary: Colors.black, // <-- SEE HERE
              onSurface: Colors.black, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.black, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selected != null && selected != nowDate) {
      if(startDateCheck){
        activityProvider?.startDate=selected;
      }
      else{
        activityProvider?.endDate=selected;

      }
      setState(() {
        nowDate = selected;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            right: 0,
            top: 0,
            child: IconButton(onPressed: () {
              Navigator.pop(context);
            },
              icon: Icon(Icons.cancel,color: primaryColor,size: 30,),
            )),
        Container(
          height: 350,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap:() async{
                    await _selectDate(context,true);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade500,
                          offset: const Offset(
                            1.0,
                            1.0,
                          ),
                          blurRadius: 1.0,
                          spreadRadius: 1.0,
                        ), //BoxShadow
                        BoxShadow(
                          color: Colors.white,
                          offset: const Offset(0.0, 0.0),
                          blurRadius: 0.0,
                          spreadRadius: 0.0,
                        ), //BoxShadow
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Start Date",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        (activityProvider!=null)? Text(CommonFunctions().getDateTimeByTimeStamp(activityProvider?.startDate.millisecondsSinceEpoch, 'dd MMM yyyy'),style: greyTextRegularIn16px(),):Container()
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () async {
                    await _selectDate(context,false);


                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade500,
                          offset: const Offset(
                            1.0,
                            1.0,
                          ),
                          blurRadius: 1.0,
                          spreadRadius: 1.0,
                        ), //BoxShadow
                        BoxShadow(
                          color: Colors.white,
                          offset: const Offset(0.0, 0.0),
                          blurRadius: 0.0,
                          spreadRadius: 0.0,
                        ), //BoxShadow
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "End Date",
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        (activityProvider!=null)? Text(CommonFunctions().getDateTimeByTimeStamp(activityProvider?.endDate.millisecondsSinceEpoch, 'dd MMM yyyy'),style: greyTextRegularIn16px(),):Container(),

                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20.0,20.0,20.0,10.0),
                  child: buttonWidget(context: context, text: 'Search', color: primaryColor, onPress: () {
                    Navigator.pop(context,true);
                  }),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  initializeComponent() async {
    activityProvider = Provider.of<ActivityProvider>(context, listen: false);
    setState(() {});
  }
}
