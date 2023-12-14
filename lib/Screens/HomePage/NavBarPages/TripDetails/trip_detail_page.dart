import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../Component/Bottom_Sheet/image_frame.dart';
import '../../../../Component/Bottom_Sheet/report_ride.dart';
import '../../../../Component/Common_Widget/trip_details_item_template.dart';
import '../../../../Component/Dialogue/acitivity_indicator_dialogue.dart';
import '../../../../Component/Dialogue/receipt_dialogue.dart';
import '../../../../Component/Model/Authentication/user_model.dart';
import '../../../../Component/Model/Earning/earning_model.dart';
import '../../../../Component/Model/Review/report_model.dart';
import '../../../../Component/Services/global_service.dart';
import '../../../../Component/Services/local_service.dart';
import '../../../../Component/common_function.dart';
import '../../../../Component/constant.dart';
import '../../../../Component/theme/app_theme.dart';
import '../../../../Component/theme/text_style_theme.dart';
import '../Receipt/receipt_page.dart';

class TripDetailsPage extends StatefulWidget {
  EarningModel earningModel;
  bool reportTrip;

  TripDetailsPage({required this.earningModel, this.reportTrip = false});

  @override
  State<TripDetailsPage> createState() => _TripDetailsPageState();
}

class _TripDetailsPageState extends State<TripDetailsPage> {
  List<LatLng> polylineCoordinates = [];
  UserModel? userDetail;

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
          title: Text(
            'Trip Details',
            style: whiteAppBarTextStyle22px(),
          ),
          actions: [
            (widget.reportTrip)
                ? IconButton(
                    onPressed: () async {
                      String? result = await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => AnimatedPadding(
                          duration: Duration(milliseconds: 150),
                          curve: Curves.easeOut,
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Container(
                              height: MediaQuery.of(context).size.height * 0.5,
                              decoration: new BoxDecoration(
                                color: Colors.white,
                                borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(25.0),
                                  topRight: const Radius.circular(25.0),
                                ),
                              ),
                              child: ReportRide()),
                        ),
                      );

                      if (result != null) {
                        loadingAlertDialog(context: context);
                        DatabaseReference ref = FirebaseDatabase.instance
                            .ref("SaTtAaYz")
                            .child('report');
                        String? nodeKey = ref.push().key;
                        int? currentTime =
                            await GlobalService().getCurrentTime();
                        ReportUser reportModel = ReportUser(
                            id: nodeKey,
                            rideId: widget.earningModel.rideId,
                            reportTo: userDetail?.uid,
                            reportBy: widget.earningModel.driverId,
                            report: result,
                            timeStamp: currentTime);
                        await ref.child(nodeKey!).set(reportModel.toMap());
                        Navigator.pop(context);
                      }
                    },
                    icon: Icon(
                      Icons.flag,
                      color: Colors.white,
                      size: 30,
                    ))
                : Container(),
          ],
        ),
        body: Column(
          children: [
            Container(
              width: size.width,
              height: 200,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(widget.earningModel.pickedUpLocation!.lat!,
                      widget.earningModel.pickedUpLocation!.long!),
                  zoom: 12,
                ),
                // onMapCreated: (GoogleMapController controller) {
                //   _controller.complete(controller);
                // },
                polylines: {
                  Polyline(
                    polylineId: PolylineId("ride"),
                    points: polylineCoordinates,
                    color: Colors.blue,
                    width: 6,
                  ),
                },
                markers: {
                  Marker(
                    markerId: MarkerId("sourceLocation"),
                    position: LatLng(widget.earningModel.pickedUpLocation!.lat!,
                        widget.earningModel.pickedUpLocation!.long!),
                  ),
                  Marker(
                    markerId: MarkerId("destinationLocation"),
                    position: LatLng(
                        widget.earningModel.destinationLocation!.lat!,
                        widget.earningModel.destinationLocation!.long!),
                  ),
                },
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  color: lightGreyColor,
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        CommonFunctions()
                                            .getDateTimeByTimeStamp(
                                                widget.earningModel.endTime,
                                                'dd/MM/yy h:mm a'),
                                        style: blackTextLightIn14px(),
                                      ),
                                      Text(
                                        "PKR${widget.earningModel.price}",
                                        style: blackTextLightIn14px(),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "",
                                        style: blackTextLightIn14px(),
                                      ),
                                      Text(
                                        "Cash",
                                        style: blackTextLightIn14px(),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 7,
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 5,
                                                    height: 5,
                                                    color: Colors.black,
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Expanded(
                                                      child: Text(widget
                                                              .earningModel
                                                              .destinationLocation
                                                              ?.location ??
                                                          "")),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    width: 5,
                                                    height: 5,
                                                    color: Colors.black,
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Expanded(
                                                      child: Text(widget
                                                              .earningModel
                                                              .pickedUpLocation
                                                              ?.location ??
                                                          "")),
                                                ],
                                              ),
                                            ],
                                          )),
                                      (widget.earningModel.status ==
                                              Constant.rideCompletedStatus)
                                          ? Expanded(
                                              flex: 3,
                                              child: Center(
                                                  child: GestureDetector(
                                                onTap: () {
                                                  // Navigator.push(
                                                  //   context,
                                                  //   MaterialPageRoute(builder: (context) =>  ReceiptPage(earningModel: widget.earningModel,)),
                                                  // );
                                                  showDialog(
                                                    context: context,
                                                    builder: (ctx) =>
                                                        ReceiptDialogue(
                                                      earningModel:
                                                          widget.earningModel,
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                    padding: EdgeInsets.all(8),
                                                    width: 110,
                                                    decoration: BoxDecoration(
                                                      color: lightGreyColor,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20.0)),
                                                    ),
                                                    child: Center(
                                                        child:
                                                            Text("Receipt"))),
                                              )))
                                          : Expanded(
                                              flex: 3,
                                              child: Center(
                                                  child: Container(
                                                      padding:
                                                          EdgeInsets.all(8),
                                                      width: 110,
                                                      decoration: BoxDecoration(
                                                        color: lightGreyColor,
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    20.0)),
                                                      ),
                                                      child: Center(
                                                          child: Text(
                                                              "${Constant.rideCompletedStatus}"))))),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      TripDetailItemTemplate(
                        title: "Find Lost item",
                        description:
                            "We can help you get in touch with your driver",
                      ),
                      TripDetailItemTemplate(
                        title: "Report Safety Issues",
                        description:
                            "We can help you get in touch with your driver",
                      ),
                      TripDetailItemTemplate(
                        title: "Provide Drive Feedback",
                        description:
                            "We can help you get in touch with your driver",
                      ),
                      TripDetailItemTemplate(
                        title: "Get Trip Help",
                        description:
                            "We can help you get in touch with your driver",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  getPolyLinePoints() async {
    PolylinePoints polyLinePoints = PolylinePoints();
    PolylineResult result = await polyLinePoints.getRouteBetweenCoordinates(
        Constant.kGoogleMapKey,
        PointLatLng(widget.earningModel.pickedUpLocation!.lat!,
            widget.earningModel.pickedUpLocation!.long!),
        PointLatLng(widget.earningModel.destinationLocation!.lat!,
            widget.earningModel.destinationLocation!.long!));
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng points) {
        polylineCoordinates.add(LatLng(points.latitude, points.longitude));
      });
      setState(() {});
    }
  }

  initializeComponent() async {
    userDetail = await LocalStorageService.getSignUpModel();
    await getPolyLinePoints();
  }
}
