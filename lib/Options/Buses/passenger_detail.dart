import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Component/theme/app_theme.dart';
import '../../Component/theme/text_style_theme.dart';

class passenger_details extends StatefulWidget {
  const passenger_details({Key? key}) : super(key: key);

  @override
  State<passenger_details> createState() => _passenger_detailsState();
}

class _passenger_detailsState extends State<passenger_details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
          title: Text('Passenger Details',style: whiteAppBarTextStyle22px(),),
      ),
      body: Center(
        child: CustomContainer(),
      ),
    );
  }
}
class CustomContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(16.0),
      height: 462.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: <Widget>[
          Text(
            'Main Passenger',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'These details will be used to verify your identity at the bus station',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            decoration: InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16.0),
          TextField(
            decoration: InputDecoration(
              labelText: 'CNIC',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 16.0),
          Row(
            children: <Widget>[
              // Country Code Dropdown
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: DropdownButton<String>(
                    value: '+1', // Change this to the default country code
                    onChanged: (String? newValue) {
                      // Implement code to change country code
                    },
                    items: <String>['+1', '+91', '+44', '+81']
                        .map<DropdownMenuItem<String>>(
                          (String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      },
                    )
                        .toList(),
                  ),
                ),
              ),
              SizedBox(width: 8.0),
              // Phone Text Field
              Expanded(
                flex: 5,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Row(
            children: <Widget>[
              // "Save Details for future use" Text
              Expanded(
                flex: 7,
                child: Text(
                  'Save Details for future use',
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ),
              // Toggle Button
              Expanded(
                flex: 3,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Switch(
                    value: false, // Change this to the initial state
                    onChanged: (bool value) {
                      // Implement code to handle the toggle state
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),
          TextField(
            decoration: InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}