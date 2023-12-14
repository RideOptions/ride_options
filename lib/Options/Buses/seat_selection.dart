import 'package:flutter/material.dart';
import 'package:rideoptions/Component/theme/text_style_theme.dart';

class SeatSelection extends StatefulWidget {
  SeatSelection({Key? key}) : super(key: key);

  @override
  _SeatSelectionState createState() => _SeatSelectionState();
}

class _SeatSelectionState extends State<SeatSelection> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(8.0),
        height: height / 1.2,
        width: width,
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 65,
                        width: 65,
                        decoration: BoxDecoration(
                          color: Color(0xffF0F0F0),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                        ),
                      ),
                      Text(
                        'Available',
                        style: blackTextLightIn14px(),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: 65,
                        width: 65,
                        decoration: BoxDecoration(
                          color: Color(0xffEFBE00),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                        ),
                      ),
                      Text(
                        'Selected',
                        style: blackTextLightIn14px(),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: 65,
                        width: 65,
                        decoration: BoxDecoration(
                          color: Color(0xff290D4A),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                        ),
                      ),
                      Text(
                        'Male',
                        style: blackTextLightIn14px(),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: 65,
                        width: 65,
                        decoration: BoxDecoration(
                          color: Color(0xffFD02B7),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black),
                        ),
                      ),
                      Text(
                        'Female',
                        style: blackTextLightIn14px(),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10),
              margin: EdgeInsets.only(left: 15, right: 15),
              decoration: BoxDecoration(
                color: Color(0xffF0F0F0),
                borderRadius: BorderRadius.circular(10),
              ),
              height: height / 1.75,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 15),
                          width: 120,
                          height: height / 1.459,
                          child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5.0,
                              mainAxisSpacing: 5.0,
                            ),
                            itemCount: 20,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  if (!male.contains(index) &&
                                      !female.contains(index)) {
                                    if (!tapped.contains(index)) {
                                      tapped.add(index);
                                    } else {
                                      tapped.remove(index);
                                    }
                                    setState(() {});
                                    print(tapped);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: tapped.contains(index)
                                        ? Color(0xffEFBE00)
                                        : female.contains(index)
                                            ? Color(0xffFD20BF)
                                            : male.contains(index)
                                                ? Color(0xff290D4A)
                                                : Color(0xffF0F0F0),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    index.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(right: 15),
                          width: 120,
                          height: height / 1.459,
                          child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5.0,
                              mainAxisSpacing: 5.0,
                            ),
                            itemCount: 20,
                            itemBuilder: (BuildContext context, int index) {
                              return GestureDetector(
                                onTap: () {
                                  if (!male.contains(index) &&
                                      !female.contains(index)) {
                                    if (!tapped2.contains(index)) {
                                      tapped2.add(index);
                                    } else {
                                      tapped2.remove(index);
                                    }
                                    setState(() {});
                                    print(tapped2);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: tapped2.contains(index)
                                        ? Color(0xffEFBE00)
                                        : female.contains(index)
                                            ? Color(0xffFD20BF)
                                            : male.contains(index)
                                                ? Color(0xff290D4A)
                                                : Color(0xffF0F0F0),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    index.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 15,
                        right: 15,
                      ),
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: 5,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

List<int> tapped = [];
List<int> tapped2 = [];
List<int> male = [3, 7, 15, 18];
List<int> female = [2, 5, 6, 8];
