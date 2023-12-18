import 'package:flutter/material.dart';

import '../theme/text_style_theme.dart';

// ignore: must_be_immutable
class PhoneNumberFrameTemplate extends StatelessWidget {
  String? hintText;
  Function()? onTap;
  Function(String)? onSelected;
  TextEditingController? textController;
  List<String> phoneCodeListItem;
  FocusNode? focusNode;
  bool? isReadOnly;

  PhoneNumberFrameTemplate(
      {this.hintText,
      this.onTap,
      this.textController,
      required this.phoneCodeListItem,
      this.onSelected,
      this.focusNode,
      this.isReadOnly = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
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
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.0),
          topRight: Radius.circular(5.0),
          bottomLeft: Radius.circular(5.0),
          bottomRight: Radius.circular(5.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 20,
            width: 60,
            child: Row(
              children: [
                PopupMenuButton<String>(
                    itemBuilder: (context) {
                      return phoneCodeListItem.map((str) {
                        return PopupMenuItem(
                          value: str,
                          child: Text(str,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w100,
                                fontSize: 14.0,
                              )),
                        );
                      }).toList();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "+92",
                          style: blackTextBoldIn14px(),
                        ),
                        Icon(Icons.arrow_drop_down),
                      ],
                    ),
                    onSelected: onSelected),
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom,
                )
              ],
            ),
          ),
          Flexible(
            child: TextField(
              controller: textController,
              keyboardType: TextInputType.phone,
              obscureText: false,
              readOnly: isReadOnly!,
              focusNode: focusNode,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w100,
                  fontSize: 14.0,
                ),
                border: InputBorder.none,
              ),
              style: blackTextRegularIn14px(),
            ),
          ),
          Image.asset(
            "assets/images/call.png",
            width: 20,
            height: 20,
          ),
        ],
      ),
    );
  }
}
