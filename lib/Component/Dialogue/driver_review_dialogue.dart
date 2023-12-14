import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Common_Widget/button_widget.dart';
import '../Common_Widget/circular_image_frame.dart';
import '../theme/app_theme.dart';
import '../theme/text_style_theme.dart';

class DriverReviewDialogue extends StatefulWidget {
  String? pictureUrl;


  DriverReviewDialogue({this.pictureUrl});

  @override
  State<DriverReviewDialogue> createState() => _DriverReviewDialogueState();
}

class _DriverReviewDialogueState extends State<DriverReviewDialogue> {
  int selectedStart=0;
  bool selectedStartErrorVisible=false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      contentPadding: EdgeInsets.all(25),
      content: WillPopScope(
        onWillPop: () => Future.value(false),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularImageFrame(
              imageUrl: widget.pictureUrl ?? "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjB8fHByb2ZpbGV8ZW58MHx8MHx8&w=1000&q=80",
              outerCircleRadius: 60,
              circleRadius: 55,
            ),
            SizedBox(height: 20),
            Text("How was your ride?", style: blackTextBoldIn18px()),
            SizedBox(height: 10),
            Text("Your feedback helps us improve!", style: TextStyle(color: primaryColor, fontSize: 14)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) => GestureDetector(
                onTap: () {
                  setState(() {
                    selectedStart = index + 1;
                  });
                },
                child: Image.asset(
                  selectedStart > index
                      ? "assets/images/selected_star.png"
                      : "assets/images/unselected_star.png",
                  width: 45,
                ),
              )),
            ),
            SizedBox(height: 15),
            Visibility(
              visible: selectedStartErrorVisible,
              child: Text(
                "Please rate us before submitting.",
                style: errorMessageLightIn12px(),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedStart != 0) {
                  Navigator.pop(context, selectedStart);
                } else {
                  setState(() {
                    selectedStartErrorVisible = true;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                primary: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: EdgeInsets.symmetric(vertical: 12),
              ),
              child: Center(
                child: Text("Submit Review", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Maybe Later", style: TextStyle(color: primaryColor, fontWeight: FontWeight.normal, fontSize: 14)),
            ),
          ],
        ),
      ),
    );

  }
}
