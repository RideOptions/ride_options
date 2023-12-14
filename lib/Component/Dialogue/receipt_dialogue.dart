import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Common_Widget/button_widget.dart';
import '../Model/Earning/earning_model.dart';
import '../common_function.dart';
import '../theme/app_theme.dart';
import '../theme/text_style_theme.dart';

class ReceiptDialogue extends StatelessWidget {
  EarningModel earningModel;


  ReceiptDialogue({required this.earningModel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 25),
      contentPadding: EdgeInsets.all(20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Receipt",
            style: blackTextBoldIn18px(),
          ),
          SizedBox(height: 25,),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.monetization_on, color: primaryColor, size: 45),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Cash", style: blackTextBoldIn16px()),
                  Text(
                    CommonFunctions().getDateTimeByTimeStamp(
                        earningModel.endTime, 'MM/dd/yyyy h:mm a'),
                    style: greyTextRegularIn14px(),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20,),

          Divider(thickness: 1, color: Colors.grey[300]), // Added a divider

          SizedBox(height: 20,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total", style: blackTextRegularIn16px()),
              Text("PKR ${earningModel.price}.00", style: blackTextBoldIn16px()),
            ],
          ),
          SizedBox(height: 25,),

          Container(
            width: double.infinity,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: primaryColor,
            ),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Close",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );

  }
}
