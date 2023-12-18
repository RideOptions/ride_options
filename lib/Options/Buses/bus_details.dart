import 'package:flutter/material.dart';

import '../../Component/theme/text_style_theme.dart';
import 'controller/getxController.dart';

class BusDetails extends StatefulWidget {
  const BusDetails({Key? key}) : super(key: key);

  @override
  _BusDetailsState createState() => _BusDetailsState();
}

class _BusDetailsState extends State<BusDetails> {
  // var controller = Get.put(ctrl());

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
                height: 290,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x26000000),
                      blurRadius: 20,
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Image(
                            image: AssetImage('assets/images/road master.png'),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    'Lahore',
                                    style: blackTextBlodIn16px(),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    'Karachi',
                                    style: blackTextBlodIn16px(),
                                  ),
                                  SizedBox(),
                                  Text(
                                    '09:30 PM',
                                    style: greyTextRegularIn14px(),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(),
                                  Icon(
                                    Icons.chair,
                                    color: Colors.black,
                                  ),
                                  Icon(
                                    Icons.wifi,
                                    color: Colors.black,
                                  ),
                                  Icon(
                                    Icons.headphones,
                                    color: Colors.black,
                                  ),
                                  Icon(
                                    Icons.tv,
                                    color: Colors.black,
                                  ),
                                  Icon(
                                    Icons.power_outlined,
                                    color: Colors.black,
                                  ),
                                  Icon(
                                    Icons.restaurant_menu_rounded,
                                    color: Colors.black,
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Divider(
                      indent: 10,
                      endIndent: 10,
                      thickness: 0.8,
                    ),
                    Container(
                      height: 30,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            ' Luxury ',
                            style: blackTextRegularIn20px(),
                          ),
                          VerticalDivider(
                            indent: 2,
                            endIndent: 2,
                            thickness: 1.6,
                          ),
                          Text(
                            '22 Seats Left',
                            style: blackTextRegularIn20px(),
                          ),
                          VerticalDivider(
                            indent: 2,
                            endIndent: 2,
                            thickness: 1.6,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                              Text(
                                '  5.0',
                                style: blackTextRegularIn20px(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      endIndent: 10,
                      indent: 10,
                      thickness: 0.8,
                    ),
                    Container(
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '    02:30 AM',
                                style: greyTextRegularIn16px(),
                              ),
                              SizedBox(
                                height: 100,
                              ),
                              Text(
                                '    02:30 AM',
                                style: greyTextRegularIn16px(),
                              )
                            ],
                          ),
                          Container(
                            height: height / 6,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                CircleAvatar(
                                  radius: 7,
                                  backgroundColor: Colors.black,
                                ),
                                Container(
                                  height: height / 9,
                                  child: Row(
                                    children: [
                                      VerticalDivider(
                                        // height: 110,

                                        thickness: 2,
                                      ),
                                    ],
                                  ),
                                ),
                                CircleAvatar(
                                  radius: 7,
                                  backgroundColor: Colors.black,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Lahore',
                                style: blackTextBoldIn18px(),
                              ),
                              Text(
                                'Main Band Road, New Terminal',
                                style: greyTextRegularIn16px(),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5.0, bottom: 5),
                                child: Container(
                                  height: 40,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: Color(0x66d9d9d9),
                                    border: Border.all(
                                      color: Color(0xffB9B9B9),
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        Icons.access_time_rounded,
                                        color: Colors.grey,
                                      ),
                                      Text(
                                        '06h 40m  ',
                                        style: greyTextRegularIn14px(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Text(
                                'Multan',
                                style: blackTextBoldIn18px(),
                              ),
                              Text(
                                'Hassanabad Gate #1 Main Khan..',
                                style: greyTextRegularIn16px(),
                              ),
                            ],
                          ),
                          Column(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Container(
                padding: EdgeInsets.all(10.0),
                width: width,
                height: 320,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x26000000),
                      blurRadius: 20,
                      offset: Offset(0, 0),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How’s my bus',
                      style: blackTextBoldIn25px(),
                    ),
                    Text(
                      'Bus detail for my journey',
                      style: greyTextRegularIn16px(),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0x66d9d9d9),
                              border: Border.all(
                                color: Color(0xffB9B9B9),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.chair,
                                  color: Colors.black,
                                ),
                                Text(
                                  'Regular Seat',
                                  style: blackTextLightIn14px(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0x66d9d9d9),
                              border: Border.all(
                                color: Color(0xffB9B9B9),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.headphones,
                                  color: Colors.black,
                                ),
                                Text(
                                  'Headphones',
                                  style: blackTextLightIn14px(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0x66d9d9d9),
                              border: Border.all(
                                color: Color(0xffB9B9B9),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.tv,
                                  color: Colors.black,
                                ),
                                Text(
                                  'Individual Entertainment System',
                                  style: blackTextLightIn14px(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0x66d9d9d9),
                            border: Border.all(
                              color: Color(0xffB9B9B9),
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.wifi,
                                color: Colors.black,
                              ),
                              Text(
                                'WIFI',
                                style: blackTextLightIn14px(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0x66d9d9d9),
                              border: Border.all(
                                color: Color(0xffB9B9B9),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.power,
                                  color: Colors.black,
                                ),
                                Text(
                                  'Mobile Charging',
                                  style: blackTextLightIn14px(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0x66d9d9d9),
                              border: Border.all(
                                color: Color(0xffB9B9B9),
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(
                                  Icons.restaurant_menu_rounded,
                                  color: Colors.black,
                                ),
                                Text(
                                  'Meal is Served',
                                  style: blackTextLightIn14px(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'How’s my bus',
                      style: blackTextBoldIn25px(),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 4,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: EdgeInsets.only(left: 8.0, right: 8),
                            child: Container(
                              height: 60,
                              width: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/faisal movers1.png'),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
