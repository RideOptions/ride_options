import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '../../../../Component/Bottom_Sheet/select_trips_range.dart';
import '../../../../Component/Dialogue/acitivity_indicator_dialogue.dart';
import '../../../../Component/Provider/activity_provider.dart';
import '../../../../Component/theme/app_theme.dart';
import '../../../../Component/theme/text_style_theme.dart';
import '../TripDetails/filter_trip_page.dart';
import '../Wallet/wallet_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  ActivityProvider? activityProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      initializeComponent();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Trip Details',style: whiteAppBarTextStyle22px(),),
      ),
      body: SingleChildScrollView(

        child: Column(
          children: [
            GestureDetector(
              onTap: () async{
                bool? result = await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => Container(
                      height: MediaQuery.of(context).size.height *
                          0.35,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(25.0),
                          topRight: const Radius.circular(25.0),
                        ),
                      ),
                      child: SelectTripRange()),
                );
                if(result==true){
                  loadingAlertDialog(context: context);
                  bool? data =  await  activityProvider?.filterActivityHistoryMethod();
                  Navigator.pop(context);
                  if(data==true){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  FilterTripPage()),
                    );
                  }

                }
              },
              child: Stack(
                children: [
                  Container(
                    height: 200,
                    padding: EdgeInsets.all(20),
                    margin: EdgeInsets.all(20),
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade500,
                          offset: const Offset(
                            0.0,
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
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      border:  Border.all(
                        color: primaryColor,
                        width: 2,
                      )
                    ),

                  ),
                  Positioned(
                      bottom: 30,
                      right: -40,
                      child: Image.asset("assets/images/car_trip.png",width: size.width*0.7,)),
                  Positioned(
                      left: 40,
                      top: 40,
                      child: Text("Trips",style: primaryTextBoldIn30px(),)),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }

  initializeComponent() async {
    activityProvider = Provider.of<ActivityProvider>(context, listen: false);
    setState(() {});
  }
}
