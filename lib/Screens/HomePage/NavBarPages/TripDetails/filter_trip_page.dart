import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rideoptions/Screens/HomePage/NavBarPages/TripDetails/trip_detail_page.dart';
import '../../../../Component/Provider/activity_provider.dart';
import '../../../../Component/common_function.dart';
import '../../../../Component/theme/app_theme.dart';
import '../../../../Component/theme/text_style_theme.dart';

class FilterTripPage extends StatefulWidget {
  const FilterTripPage({Key? key}) : super(key: key);

  @override
  State<FilterTripPage> createState() => _FilterTripPageState();
}

class _FilterTripPageState extends State<FilterTripPage> {

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
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Choose a trip',style: whiteAppBarTextStyle22px(),),
      ),
      body: (activityProvider!=null)? (activityProvider!.getActivitiesFilterList.isNotEmpty)? ListView.builder(
          itemCount: activityProvider!.activitiesFilterList.length,
          cacheExtent: double.infinity,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(CommonFunctions().getDateTimeByTimeStamp( activityProvider!.activitiesFilterList[index].endTime, 'dd/MM/yyyy h:mm a'),style: blackTextRegularIn14px(),),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>  TripDetailsPage(earningModel: activityProvider!.activitiesFilterList[index],)),
                          );
                        },
                        child: Container(
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Text("PKR${activityProvider!.activitiesFilterList[index].price}",style: blackTextRegularIn14px(),),
                                  Text("Cash",style: greyTextRegularIn14px(),),

                                ],


                              ),
                              IconButton(onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>  TripDetailsPage(earningModel: activityProvider!.activitiesFilterList[index],)),
                                );
                              },
                                  icon: Icon(Icons.arrow_forward_ios_outlined,size: 20, color: primaryColor,))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  height: 200,
                  width: size.width,
                  child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(activityProvider!.activitiesFilterList[index].pickedUpLocation!.lat!,activityProvider!.activitiesFilterList[index].pickedUpLocation!.long!),
                        zoom: 16,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
                        _controller.complete(controller);
                      },
                      markers: {
                        Marker(
                          markerId: MarkerId("pickedUpLocation"),
                          position: LatLng(
                              activityProvider!.activitiesFilterList[index].pickedUpLocation!.lat!,activityProvider!.activitiesFilterList[index].pickedUpLocation!.long!),
                        ),
                      }),
                )
              ],
            );
          }):Container(): Center(child: CircularProgressIndicator(color: primaryColor,),),
    );
  }

  initializeComponent() async {
    activityProvider = Provider.of<ActivityProvider>(context, listen: false);
    setState(() {});
  }
}
