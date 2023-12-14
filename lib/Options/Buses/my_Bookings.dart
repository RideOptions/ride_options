import 'package:flutter/material.dart';

class myBooking_page extends StatefulWidget {
  const myBooking_page({Key? key}) : super(key: key);

  @override
  State<myBooking_page> createState() => _myBooking_pageState();
}

class _myBooking_pageState extends State<myBooking_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue, // Replace with your primaryColor
        title: Text(
          "My Bookings",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(top: 20),
          height: 340,
          width: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: IconButton(
                    icon: Icon(Icons.bus_alert_rounded),
                    onPressed: (){

                    },
                  ), // Replace with your image
                ),
              ),
              Positioned(
                left: 100,
                top: 30,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Text 1'),
                    Text('Text 2'),
                    Text('Text 3'),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    // Add your action for the menu button here
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
