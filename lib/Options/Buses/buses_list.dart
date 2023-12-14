import 'package:flutter/material.dart';
import 'package:rideoptions/Component/theme/app_theme.dart';

import '../../Component/theme/text_style_theme.dart';

class BusesList extends StatefulWidget {
  const BusesList({Key? key}) : super(key: key);

  @override
  _BusesListState createState() => _BusesListState();
}

class _BusesListState extends State<BusesList> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Buses List',
          style: whiteAppBarTextStyle22px(),
        ),
      ),
      body: ListView.builder(
        itemCount: 15,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              height: 170,
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                  Container(
                    height: 50,
                    color: Color(0x59d9d9d9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '  Female',
                          style: blackTextLightIn14px(),
                        ),
                        Text(
                          'Vaccinated',
                          style: blackTextLightIn14px(),
                        ),
                        Text(
                          'Premium Cruise . 23 Seats Left   ',
                          style: greyTextRegularIn14px(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
