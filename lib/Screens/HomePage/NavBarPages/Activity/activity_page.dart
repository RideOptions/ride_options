import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../../Component/Model/Authentication/user_model.dart';
import '../../../../Component/Provider/activity_provider.dart';
import '../../../../Component/Services/local_service.dart';
import '../../../../Component/common_function.dart';
import '../../../../Component/theme/app_theme.dart';
import '../../../../Component/theme/text_style_theme.dart';
import '../TripDetails/trip_detail_page.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  UserModel? userDetail;
  ActivityProvider? activityProvider;
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();

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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Consumer<ActivityProvider>(
              builder: (context, consumerActivityProvider, child) {

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Activity",
                    style: blackTextBoldIn40px(),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                (consumerActivityProvider.activitiesList.isNotEmpty)? Text(
                  "Past",
                  style: blackTextBoldIn16px(),
                ):Container(),
                SizedBox(
                  height: 20,
                ),
                (consumerActivityProvider.activitiesList.isNotEmpty)?
                Container(
                  padding: EdgeInsets.all(15),
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade500,
                        offset: const Offset(
                          0.0,
                          0.0,
                        ),
                        blurRadius: 2.0,
                        spreadRadius: 1.0,
                      ), //BoxShadow
                      BoxShadow(
                        color: Colors.white,
                        offset: const Offset(0.0, 0.0),
                        blurRadius: 0.0,
                        spreadRadius: 0.0,
                      ), //BoxShadow
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child:Container(
                            height: 150,
                            width: size.width,
                            child: GoogleMap(
                              mapType: MapType.normal,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(consumerActivityProvider.activitiesList[0].pickedUpLocation!.lat!,consumerActivityProvider.activitiesList[0].pickedUpLocation!.long!),
                                zoom: 16,
                              ),
                              onMapCreated: (GoogleMapController controller) {
                                _controller.complete(controller);
                              },
                              markers: {
                                Marker(
                                  markerId: MarkerId("pickedUpLocation"),
                                  position: LatLng(
                                      consumerActivityProvider.activitiesList[0].pickedUpLocation!.lat!,consumerActivityProvider.activitiesList[0].pickedUpLocation!.long!),
                                ),
                                    }),
                          ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        consumerActivityProvider.activitiesList[0].destinationLocation?.location??"",
                        maxLines:2,
                        overflow:TextOverflow.ellipsis,
                        style: blackTextBoldIn18px(),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        CommonFunctions().getDateTimeByTimeStamp( consumerActivityProvider.activitiesList[0].endTime, 'MMM dd -h:mm a') ,
                        style: greyTextRegularIn14px(),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "PKR ${consumerActivityProvider.activitiesList[0].price}",
                        style: greyTextRegularIn14px(),
                      ),
                    ],
                  ),
                ):Container(),
                SizedBox(
                  height: 20,
                ),
                (){
                if(consumerActivityProvider.activitiesListEmpty){
                  return Container(
                      height: size.height*0.5,
                      child: Center(child: Image.asset("assets/images/placeHolder.png",width:size.width)));
                }
                else if(consumerActivityProvider.activitiesList.isNotEmpty){
                  return ListView.builder(
                      itemCount: consumerActivityProvider.activitiesList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TripDetailsPage(earningModel: consumerActivityProvider.activitiesList[index],
                                      reportTrip: true,
                                      )),
                                );
                              },
                              child: Container(
                                child: Row(
                                  children: [
                                    Container(
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: lightGreyColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        child: Image.asset(
                                          (){
                                            if(consumerActivityProvider.activitiesList[index].vehicleType=="Rickshaw"){
                                              return "assets/images/rickshaw_icon.png";
                                            }
                                           else if(consumerActivityProvider.activitiesList[index].vehicleType=="MotorBike"){
                                              return "assets/images/bike_icon.png";
                                            }
                                           else if(consumerActivityProvider.activitiesList[index].vehicleType=="Mini"){
                                              return "assets/images/mini_icon.png";
                                            }
                                           else if(consumerActivityProvider.activitiesList[index].vehicleType=="RideGo"){
                                              return "assets/images/rideGo_icon.png";
                                            }
                                            else if(consumerActivityProvider.activitiesList[index].vehicleType=="RideX"){
                                              return "assets/images/rideGo_icon.png";
                                            }
                                            else{
                                              return "assets/images/rideGo_icon.png";
                                            }
                                          }(),
                                          width: 70,
                                          height: 70,
                                        )),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            consumerActivityProvider.activitiesList[index].destinationLocation?.location??"",
                                           maxLines:2,
                                            overflow:TextOverflow.ellipsis,
                                            style: blackTextBoldIn16px(),
                                          ),
                                          SizedBox(height: 5,),
                                          Text(
                                            CommonFunctions().getDateTimeByTimeStamp(consumerActivityProvider.activitiesList[index].endTime, 'MMM dd yyyy') ,
                                            style: greyTextRegularIn14px(),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 5,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "PKR ${consumerActivityProvider.activitiesList[index].price}",
                                                style: greyTextRegularIn14px(),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              Text(
                                                "PKR ${'18.3'}",
                                                style: greyTextRegularIn14px(),
                                                overflow: TextOverflow.ellipsis,
                                              ),


                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 20,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(15),
                              width: size.width,
                              height: 1,
                              color: Colors.black.withOpacity(0.5),
                            )
                          ],
                        );
                      });
                }
                else{
                  return Column(
                    children: [
                      SizedBox(height: size.height*0.25,),
                      Center(child: CircularProgressIndicator(),),
                    ],
                  );
                }

                }(),
              ],
            );
          }),
        ),
      ),
    );
  }

  initializeComponent() async {
    activityProvider = Provider.of<ActivityProvider>(context, listen: false);
    userDetail = await LocalStorageService.getSignUpModel();
    activityProvider?.activitiesListEmpty=true;
    await activityProvider?.getActivitiesMethod(uid: userDetail!.uid!);
    setState(() {});
  }
}
