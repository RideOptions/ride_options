import 'package:flutter/material.dart';

class PassengerDetailScreen extends StatefulWidget {
  @override
  _PassengerDetailScreenState createState() => _PassengerDetailScreenState();
}

class _PassengerDetailScreenState extends State<PassengerDetailScreen> {
  bool saveDetails = false;

  InputDecoration getInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Passenger Details'),
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Passenger Details',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Name',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            Text(
                              'Muhammad Ijaz',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        Divider(),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Email',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            Text(
                              'exampleuser35@gmail.com',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        Divider(),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Contact No',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            Text(
                              '+866 (573) 4374 325',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        Divider(),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'CNIC',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            Text(
                              '31204-8598524-9',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ]),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Payments Details',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Subtotal',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            Text(
                              'PKR 457',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        Divider(),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Texes & Other Fees',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            Text(
                              'PKR 120',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                        Divider(),
                        SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Amount to be Paid',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            Text(
                              'PKR 577',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ]),
                ),
              ),
            ],
          ),
        ));
  }
}
