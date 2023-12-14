import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../Model/Chat/chat_message_model.dart';
import '../common_function.dart';
import '../theme/app_theme.dart';
import '../theme/text_style_theme.dart';

class MessageTemplate extends StatelessWidget {
 bool Mine;
 ChatMessageModel chatMessageModel;

 MessageTemplate({this.Mine=false,required this.chatMessageModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:(Mine)? CrossAxisAlignment.end:  CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
          margin:(Mine)? EdgeInsets.fromLTRB(70, 0, 0, 0): EdgeInsets.fromLTRB(0, 0, 70, 0),
          child: Align(
            alignment:(Mine)? Alignment.topRight:Alignment.topLeft,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                    bottomLeft: Radius.circular(15.0)),
                color: (Mine)? Colors.blue.withOpacity(0.5): Colors.red.withOpacity(0.5),
              ),
              padding: EdgeInsets.all(16),
              child: Text(
               chatMessageModel.message??"",
                style: whiteTextRegularIn16px(),
              ),
            ),
          ),
        ),
        Container(
            margin:(Mine)? EdgeInsets.fromLTRB(0, 0, 20, 0):EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Text(CommonFunctions().getDateTimeByTimeStamp(chatMessageModel.timeStamp, 'h:mm a'), style: greyTextRegularIn12px(),)),
      ],
    );
  }
}
