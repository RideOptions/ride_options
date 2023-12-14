import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rideoptions/Component/theme/app_theme.dart';
import 'package:rideoptions/Component/theme/text_style_theme.dart';
import 'package:rideoptions/Options/Buses/buses_list.dart';

import '../../Component/Common_Widget/button_widget.dart';

class searchBusesScreen extends StatefulWidget {
  @override
  State<searchBusesScreen> createState() => _searchBusesScreenState();
}

class _searchBusesScreenState extends State<searchBusesScreen> {
  int radioValue = 0;
  String selectedOption = 'ONE - WAY';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          'Search Bus',
          style: whiteAppBarTextStyle22px(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {});
                      selectedOption = 'ONE - WAY';
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 19,
                          width: 19,
                          margin: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // Use a circular shape for a typical radio button
                            border: Border.all(
                              color: Colors.white,
                              // Set the border color to white
                              width: 2, // Set the border width
                            ),
                          ),
                          child: Radio(
                            activeColor: Colors.white,
                            value: 'ONE - WAY',
                            groupValue: selectedOption,
                            onChanged: (value) {
                              setState(() {
                                selectedOption = value.toString();
                              });
                            },
                          ),
                        ),
                        Text(
                          'ONE - WAY',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {});
                      selectedOption = 'ROUND - TRIP';
                    },
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 19,
                          width: 19,
                          margin: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                          child: Radio(
                            activeColor: Colors.white,
                            focusColor: Colors.white,
                            value: 'ROUND - TRIP',
                            groupValue: selectedOption,
                            onChanged: (value) {
                              setState(() {
                                selectedOption = value.toString();
                              });
                            },
                          ),
                        ),
                        Text(
                          'ROUND - TRIP',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                      labelText: 'From',
                      prefixIcon: Icon(Icons.location_on),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                      labelText: 'To',
                      prefixIcon: Icon(Icons.location_on),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: selectedOption == 'ROUND - TRIP'
                            ? MediaQuery.of(context).size.width / 2 - 22
                            : MediaQuery.of(context).size.width - 32,
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            fillColor: Colors.white,
                            filled: true,
                            labelText: 'Departure Date',
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                      ),
                      Visibility(
                        visible:
                            selectedOption == 'ROUND - TRIP' ? true : false,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2 - 22,
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              fillColor: Colors.white,
                              filled: true,
                              labelText: 'Return Date',
                              prefixIcon: Icon(Icons.calendar_today),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                      labelText: 'All Bus services',
                      prefixIcon: Icon(Icons.directions_bus_filled),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            buttonWidget(
              context: context,
              width: 200,
              text: 'Search',
              color: lightGreyColor,
              onPress: () async {
                Get.to(BusesList());
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
