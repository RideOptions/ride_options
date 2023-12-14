import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Common_Widget/button_widget.dart';
import '../Common_Widget/seprator_line_wiget.dart';
import '../common_function.dart';
import '../theme/app_theme.dart';
import '../theme/text_style_theme.dart';

class SchedularRide extends StatefulWidget {
  const SchedularRide({Key? key}) : super(key: key);

  @override
  State<SchedularRide> createState() => _SchedularRideState();
}

class _SchedularRideState extends State<SchedularRide> {

  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickeds = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor, // <-- SEE HERE
              onPrimary: Colors.black, // <-- SEE HERE
              onSurface: Colors.black, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colors.black, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickeds != null && pickeds != selectedTime )
      setState(() {
        selectedTime = pickeds;
      });
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
            right: 0,
            top: 0,
            child: IconButton(onPressed: () {
              Navigator.pop(context);
            },
              icon: Icon(Icons.cancel,color: primaryColor,size: 30,),
            )),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Text("Schedule Ride", style: blackTextBoldIn25px(),),
            SepratorLine(horizontalMargin: 0,),
            Text("Sat, Jan 14", style: blackTextRegularIn20px(),),
            SepratorLine(horizontalMargin: 0,),
            GestureDetector(
                onTap: () async{
                  await _selectTime(context);
                },
                child: Text(selectedTime.format(context).toString(), style: blackTextRegularIn20px(),)),
            SepratorLine(horizontalMargin: 0,),
            Spacer(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0,10.0,20.0,20.0),
              child: buttonWidget(context: context, text: 'Ride Scheduler', color: primaryColor, onPress: () {
                Navigator.pop(context,selectedTime);
              }),
            )
          ],
        ),
      ],
    );
  }
}
