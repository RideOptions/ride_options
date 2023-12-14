import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Common_Widget/button_widget.dart';
import '../Common_Widget/text_field_area.dart';
import '../theme/app_theme.dart';
import '../theme/text_style_theme.dart';

class ReportRide extends StatefulWidget {
  const ReportRide({Key? key}) : super(key: key);

  @override
  State<ReportRide> createState() => _ReportRideState();
}

class _ReportRideState extends State<ReportRide> {
  String? reportingValue = "Other";
  TextEditingController reportController = TextEditingController();
  bool reportErrorVisible=false;
  String?  reportErrorText;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    reportController.addListener(() {
      if (reportController.text.isNotEmpty) {
        setState(() {
          reportErrorVisible = false;
        });
      }
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Center(child: Text("Report a Ride", style: blackTextBoldIn25px(),)),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  Row(
                    children: [
                      Radio(value: reportingValue??"", groupValue: "Abusing/Inappropriate",
                          activeColor: primaryColor,
                        onChanged: (newValue) {
                          setState(() {
                            reportingValue="Abusing/Inappropriate";
                          });
                        }
                      ),
                      GestureDetector(
                          onTap: (){
                            setState(() {
                              reportingValue="Abusing/Inappropriate";
                            });
                          },
                          child: Text("Abusing/Inappropriate"))
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: reportingValue??"", groupValue: "Harassment",
                          activeColor: primaryColor,
                          onChanged: (newValue) {
                            setState(() {
                              reportingValue="Harassment";
                            });
                          }
                      ),
                      GestureDetector(
                          onTap: (){
                            setState(() {
                              reportingValue="Harassment";
                            });
                          },
                          child: Text("Harassment"))
                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: reportingValue??"", groupValue: "Fake person",
                          activeColor: primaryColor,
                          onChanged: (newValue) {
                            setState(() {
                              reportingValue="Fake person";
                            });
                          }
                      ),
                      GestureDetector(
                          onTap: (){
                            setState(() {
                              reportingValue="Fake person";
                            });
                          },
                          child: Text("Fake person"))

                    ],
                  ),
                  Row(
                    children: [
                      Radio(value: reportingValue??"", groupValue: "Other",
                          activeColor: primaryColor,
                          onChanged: (newValue) {
                            setState(() {
                              reportingValue="Other";
                            });
                          }
                      ),
                      GestureDetector(
                          onTap: (){
                            setState(() {
                              reportingValue="Other";
                            });
                          },
                          child: Text("Other"))

                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 5.0),
                    child: TextFieldArea(
                      hintText: "Please let us know",
                      controller: reportController,
                      isReadOnly:
                      (reportingValue == "Other") ? false : true,
                      height: 4,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 5),
              child: Visibility(
                visible:reportErrorVisible,
                child: Text(
                  reportErrorText??"",
                  style: errorMessageLightIn12px(),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20.0,0.0,20.0,10.0),
              child: buttonWidget(context: context, text: 'Report', color: primaryColor, onPress: () {
                if(reportingValue=="Other"){
                  if(reportController.text.isNotEmpty){
                    Navigator.pop(context,reportController.text);

                  }
                  else{
                    setState(() {
                      reportErrorText="please enter reason of reported.";
                      reportErrorVisible=true;
                    });
                  }
                }
                else{
                  Navigator.pop(context,reportingValue);

                }
              }),
            )
          ],
        ),
      ],
    );
  }
}
