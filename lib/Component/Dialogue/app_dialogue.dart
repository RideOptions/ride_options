import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppDialogue extends StatelessWidget {
  String title;
  String description;
  String? cancelBtnText;
  String? confirmBthText;
  bool cancelBtnVisible;

  AppDialogue(
      {required this.title,
      required this.description,
      this.confirmBthText,
      this.cancelBtnText,
      this.cancelBtnVisible = true});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      titlePadding: EdgeInsets.all(20.0),
      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      content: Text(
        description,
        style: TextStyle(
          color: Colors.grey[800],
          fontSize: 16,
        ),
      ),
      actionsPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      actions: <Widget>[
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.grey.shade300),
            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            elevation: MaterialStateProperty.all<double>(5.0),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text(
            confirmBthText ?? "Yes",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        if (cancelBtnVisible) ...[
          SizedBox(width: 10), // Spacing between the buttons
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.red.shade600),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              elevation: MaterialStateProperty.all<double>(5.0),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              cancelBtnText ?? "No",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
