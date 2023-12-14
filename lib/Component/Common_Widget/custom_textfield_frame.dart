import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rideoptions/Component/theme/app_theme.dart';

import '../theme/text_style_theme.dart';

class CustomTextFieldFrame extends StatelessWidget {
String text;
String hintText;
String iconUrl;
TextInputType? keyboardType;
bool? isPassword;
bool iconVisible;
Function()? onTap;
double? cornerRadius;
TextEditingController? textController;
TextCapitalization? textCapitalization;
bool? isReadOnly;
FocusNode? focusNode;
CustomTextFieldFrame({required this.text,this.keyboardType,this.isPassword ,required this.hintText, required this.iconUrl, required this.iconVisible,
  this.onTap, this.textController,this.cornerRadius=5.0,this.focusNode,this.textCapitalization,
  this.isReadOnly=false,
});


  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width ,
      padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade500,
            offset: const Offset(
              1.0,
              1.0,
            ),
            blurRadius: 1.0,
            spreadRadius: 1.0,
          ), //BoxShadow
          BoxShadow(
            color: Colors.white,
            offset: const Offset(0.0, 0.0),
            blurRadius: 0.0,
            spreadRadius: 0.0,
          ), //BoxShadow
        ],
        borderRadius: BorderRadius.all(Radius.circular(cornerRadius!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: TextField(
              controller: textController,
              keyboardType: keyboardType,
              focusNode: focusNode,
              obscureText: isPassword??false,
              textInputAction: TextInputAction.next,
              textCapitalization: textCapitalization??TextCapitalization.none,
              readOnly: isReadOnly!,
              decoration:  InputDecoration(
                hintText: hintText,
                hintStyle:  TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w100,
                  fontSize: 14.0,
                ),
                border: InputBorder.none,),
              style: blackTextRegularIn14px(),
            ),
          ),
          (iconVisible)?Image.asset(
            iconUrl,
            width:20,
            height: 20,
            color: primaryColor,

          ): GestureDetector(
            onTap: onTap,
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ],
      ),

    );
  }
}
