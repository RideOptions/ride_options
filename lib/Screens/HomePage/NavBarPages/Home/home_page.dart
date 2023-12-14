import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
import '../../../../Component/Bottom_Sheet/schedular_ride.dart';
import '../../../../Component/Dialogue/acitivity_indicator_dialogue.dart';
import '../../../../Component/Function/send_notification.dart';
import '../../../../Component/Model/Authentication/location.dart';
import '../../../../Component/Model/Authentication/user_model.dart';
import '../../../../Component/Provider/home_provider.dart';
import '../../../../Component/Services/local_service.dart';
import '../../../../Component/ad_mob/banner_ads.dart';
import '../../../../Component/common_function.dart';
import '../../../../Component/theme/app_theme.dart';
import '../../../../Component/theme/text_style_theme.dart';
import '../Deposit/package.dart';
import '../Ride/ride_category_page.dart';
import '../Ride/ride_location_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _current = 0;
  UserModel? userDetail;

  final CarouselController _controller = CarouselController();
  Position? currentLocation;
  final Completer<GoogleMapController> _controllerMap =
      Completer<GoogleMapController>();
  HomeProvider? homeProvider;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      initializeComponent();
    });
  }

  final List<String> imgList = [
    'assets/images/slider1.jpeg',
    'assets/images/slider2.jpeg',
    'assets/images/slider3.jpeg',
    'assets/images/slider4.jpeg',
    //  'assets/images/slider5.jpeg',
    //  'assets/images/slider6.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return UpgradeAlert(
      // upgrader: Upgrader(shouldPopScope: () => false),
      child: Scaffold(
        body: SafeArea(
          child: Consumer<HomeProvider>(
              builder: (context, consumerhomeProvider, child) {
            return SingleChildScrollView(
              padding:  EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 180,
                    child: Stack(
                      children: [
                        CarouselSlider(
                          //Slider Container properties
                          options: CarouselOptions(
                            height: 180.0,
                            enlargeCenterPage: true,
                            autoPlay: true,
                            aspectRatio: 16 / 9,
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enableInfiniteScroll: true,
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            viewportFraction: 1.0,
                            initialPage: 0,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            },
                          ),
                          items: imgList
                              .map((item) => ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.asset(
                                    item,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  )))
                              .toList(),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: imgList.asMap().entries.map((entry) {
                              return GestureDetector(
                                onTap: () =>
                                    _controller.animateToPage(entry.key),
                                child: Container(
                                  width: 12.0,
                                  height: 12.0,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 4.0),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: (_current == entry.key)
                                          ? Colors.white
                                          : Colors.grey),
                                ),
                              );
                            }).toList(),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RideLocationPage()),
                          );
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: size.width * 0.4,
                              decoration: BoxDecoration(
                                color: lightGreyColor,
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
                                    offset: Offset(0.0, 0.0),
                                    blurRadius: 0.0,
                                    spreadRadius: 0.0,
                                  ), //BoxShadow
                                ],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              height: 80,
                            ),
                            Positioned(
                                top: 10,
                                right: 10,
                                child: Image.asset(
                                    "assets/images/mini_icon.png",
                                    width: size.width * 0.20)
                            ),
                            Positioned(
                              bottom: 10,
                              left: 10,
                              child: Text(
                                "Ride",
                                style: blackTextBoldIn16px(),
                              ),
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PackagePage()),
                          );
                        },
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PackagePage()),
                            );
                          },
                          child: Stack(
                            children: [
                              Container(
                                width: size.width * 0.4,
                                decoration: BoxDecoration(
                                  color: lightGreyColor,
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                ),
                                height: 80,
                              ),
                              Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Image.asset(
                                      "assets/images/package.png",
                                      width: size.width * 0.10)),
                              Positioned(
                                bottom: 10,
                                left: 10,
                                child: Text(
                                  "Options",
                                  style: blackTextBoldIn16px(),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      color: lightGreyColor,
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
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                    height: 60,
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.search,
                          size: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RideLocationPage()),
                            );
                          },
                          child: Text(
                            "Where to?",
                            style: greyTextBoldIn18px(),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        Container(
                          color: placeholderColor,
                          height: 40,
                          width: 2,
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () async {
                            TimeOfDay? time = await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) => Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  decoration: new BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: new BorderRadius.only(
                                      topLeft: const Radius.circular(25.0),
                                      topRight: const Radius.circular(25.0),
                                    ),
                                  ),
                                  child: SchedularRide()),
                            );
                            if (time != null && time != TimeOfDay.now()) {
                              print("time is: ${time.hour} ${time.minute}");
                              scheduledNotification(
                                  title: "App Usage Reminder",
                                  description: "It is reminder of your time",
                                  hour: time.hour,
                                  minute: time.minute,
                                  weekday: DateTime.now().weekday);
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            width: 110,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.punch_clock_sharp,
                                  size: 20,
                                ),
                                Text("Now"),
                                Icon(
                                  Icons.arrow_drop_down_sharp,
                                  size: 15,
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  consumerhomeProvider.getSuggestionList.isNotEmpty
                      ? ListView.builder(
                          itemCount:
                              consumerhomeProvider.getSuggestionList.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            // return index ==
                            //         consumerhomeProvider
                            //                 .getSuggestionList.length -
                            //             1
                            //     ? Container(
                            //         height: 80,
                            //         width: MediaQuery.of(context).size.width,
                            //         child: AdWidget(
                            //           ad: banner,
                            //         ),
                            //       )
                            //     :
                           return GestureDetector(
                                    onTap: () async {
                                      await suggestionMethodAsync(
                                          consumerhomeProvider
                                              .getSuggestionList[index]);
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: lightGreyColor,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20.0)),
                                              ),
                                              child: Icon(
                                                Icons.location_pin,
                                                size: 20,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    consumerhomeProvider
                                                            .getSuggestionList[
                                                                index]
                                                            .location ??
                                                        "",
                                                    style:
                                                        blackTextBoldIn16px(),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  Text(
                                                    consumerhomeProvider
                                                            .getSuggestionList[
                                                                index]
                                                            .location ??
                                                        "",
                                                    style:
                                                        greyTextRegularIn14px(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 2,
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
                                        Container(
                                          margin: EdgeInsets.all(15),
                                          width: size.width,
                                          height: 1,
                                          color: Colors.black.withOpacity(0.5),
                                        )
                                      ],
                                    ),
                                  );
                          })
                      : Container(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Around you",
                    style: blackTextBoldIn16px(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  (currentLocation != null)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Container(
                            height: 150,
                            width: size.width,
                            child: GoogleMap(
                                mapType: MapType.normal,
                                initialCameraPosition: CameraPosition(
                                  target: LatLng(currentLocation!.latitude,
                                      currentLocation!.longitude),
                                  zoom: 16,
                                ),
                                onMapCreated: (GoogleMapController controller) {
                                  _controllerMap.complete(controller);
                                },
                                markers: {
                                  Marker(
                                    markerId: MarkerId("pickedUpLocation"),
                                    position: LatLng(currentLocation!.latitude,
                                        currentLocation!.latitude),
                                  ),
                                }),
                          ),
                        )
                      : Container()
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  initializeComponent() async {
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    userDetail = await LocalStorageService.getSignUpModel();
    currentLocation = await CommonFunctions().getCurrentLocation();
    print("current location is: $currentLocation");
    await homeProvider?.getSuggestionMethod(uid: userDetail!.uid!);
    setState(() {});
  }

  suggestionMethodAsync(LocationModel destinationLocation) async {
    loadingAlertDialog(context: context);
    LocationModel? pickUpLocation = await getCurrentLocation();
    if (pickUpLocation != null) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RideCategoryPage(
                  pickupLocation: pickUpLocation,
                  destinationLocation: destinationLocation,
                )),
      );
    } else {
      Navigator.pop(context);
    }
  }

  Future<LocationModel?> getCurrentLocation() async {
    Position? currentPosition;
    LocationModel pickupAddress = LocationModel();
    await CommonFunctions().permissionServices().then(
      (value) async {
        if (value.isNotEmpty) {
          print("status location: $value");
          if (value[Permission.location]?.isGranted == true) {
            /* ========= New Screen Added  ============= */
            var status = await Permission.location.serviceStatus;
            if (status.isEnabled) {
              currentPosition = await CommonFunctions().getCurrentLocation();
              String? address = await CommonFunctions()
                  .GetAddressFromLatLong(currentPosition!);
              pickupAddress = LocationModel(
                  lat: currentPosition?.latitude,
                  location: address,
                  long: currentPosition?.longitude);
            } else {
              currentPosition = await CommonFunctions().getCurrentLocation();
              if (currentPosition != null) {
                String? address = await CommonFunctions()
                    .GetAddressFromLatLong(currentPosition!);
                pickupAddress = LocationModel(
                    lat: currentPosition?.latitude,
                    location: address,
                    long: currentPosition?.longitude);
              }
            }
          }
          if (value[Permission.location]?.isDenied == true ||
              value[Permission.location]?.isPermanentlyDenied == true) {
            await openAppSettings();
          }
        }
      },
    );
    return pickupAddress;
  }
}
