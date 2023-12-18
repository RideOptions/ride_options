import 'package:flutter/material.dart';

import 'package:rideoptions/Options/Buses/bus_details.dart';

import '../../Component/theme/app_theme.dart';
import '../../Component/theme/text_style_theme.dart';
import 'controller/getxController.dart';
import 'seat_selection.dart';

class BusBooking extends StatefulWidget {
  BusBooking({Key? key}) : super(key: key);

  @override
  _BusBookingState createState() => _BusBookingState();
}

class _BusBookingState extends State<BusBooking> {
  // var controller = Get.put(ctrl());
  var backed = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          currentIndex == 1 ? backed = true : backed = false;
          currentIndex > 0
              ? currentIndex = (currentIndex - 1) % screens.length
              : Navigator.pop(context);
        });
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              // setState(() {
              //   currentIndex != 0
              //       ? currentIndex = (currentIndex - 1) % screens.length
              //       : Navigator.pop(context);
              //   currentIndex == 0
              //       ? controller.text.value = 'Bus Details'
              //       : controller.text.value = 'Seat Selection';
              // });
            },
            icon: Icon(
              Icons.arrow_back_outlined,
            ),
          ),
          elevation: 0,
          title: TextFormField(
            controller: TextEditingController(),
            style: whiteAppBarTextStyle22px(),
          ),
        ),
        body: Column(
          children: [
            Container(
              height: 70,
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5.0, top: 8),
                    child: Row(
                      children: [
                        Text(
                          'Step ${currentIndex + 1}',
                          style: greyTextRegularIn14px(),
                        ),
                        Text(
                          ': ${textList[currentIndex]}',
                          style: TextStyle(
                              color: Color(0xff290D4A),
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Row(
                            children: [
                              Container(
                                height: 9,
                                width: width / 6,
                                decoration: BoxDecoration(
                                  color: currentIndex == index
                                      ? Color(0x99290d4a)
                                      : currentIndex > index
                                          ? Color(0xff290D4A)
                                          : Colors.grey,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: screens[currentIndex]),
          ],
        ),
        bottomNavigationBar: GestureDetector(
          onTap: () {
            // setState(() {
            //   currentIndex = (currentIndex + 1) % screens.length;
            //   print(currentIndex);
            //   print(controller.text.value);
            //   Get.put(ctrl());
            //   currentIndex == 0
            //       ? controller.text.value = 'Bus Details'
            //       : controller.text.value = 'Seat Selection';
            // });
            if (currentIndex == 2) {
              showModalBottomSheet(
                isDismissible: false,
                enableDrag: false,
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 220,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Select Seat Type',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 60,
                                width: 120,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xffD9D9D9),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Color(0xff290D4A),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.black),
                                      ),
                                    ),
                                    Text(
                                      'Male',
                                      style: blackTextLightIn14px(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 60,
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xffD9D9D9),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: Color(0xffFC1FBE),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.black),
                                    ),
                                  ),
                                  Text(
                                    'Female',
                                    style: blackTextLightIn14px(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ).whenComplete(() {
                setState(() {
                  backed != true
                      ? currentIndex = (currentIndex - 1) % screens.length
                      : Navigator.pop(context);
                });
              });
            }
          },
          child: Container(
            alignment: Alignment.center,
            height: 100,
            color: Color(0xffeaeaea),
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              height: 60,
              width: width / 1.3,
              decoration: BoxDecoration(
                  color: Color(0xff290D4A),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: currentIndex == 0
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  Text(
                    'Confirm',
                    style: whiteAppBarTextStyle22px(),
                  ),
                  Visibility(
                    visible: currentIndex == 0 ? true : false,
                    child: Text(
                      'PKR 3470',
                      style: whiteAppBarTextStyle22px(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

int currentIndex = 0;
var screens = [
  BusDetails(),
  SeatSelection(),
  SeatSelection(),
  SeatSelection(),
  BusDetails(),
];
var textList = [
  'Confirm Bus  Detail',
  'Select Your Seat From Lahore to Multan',
  'Select Your Seat From Lahore to Multan',
  'Add Passenger Details',
  'Review Bookings Details'
];
