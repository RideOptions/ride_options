import 'package:flutter/material.dart';

import '../Common_widget/button_widget.dart';
import '../theme/app_theme.dart';

// ignore: must_be_immutable
class ApplicationAlertDialogue extends StatelessWidget {
  String? imagePath;
  double? imageWidth;
  double? imageHeight;
  String? title;
  String? description;
  TextStyle? titleStyle;
  TextStyle? descriptionStyle;
  TextStyle? descriptionHighlightStyle;
  double? dialogueHeight;
  Function() onTap;
  bool richTextFlag;
  String? txt1;
  String? txt2;
  String? txt3;
  bool? cancelBtnVisible;
  String? buttonText;
  bool? crossBtnVisible;
  bool? pngPath;

  ApplicationAlertDialogue(
      {this.imagePath,
      this.title,
      this.description,
      this.titleStyle,
      this.descriptionStyle,
      this.descriptionHighlightStyle,
      this.dialogueHeight,
      required this.onTap,
      this.imageHeight = 230,
      this.imageWidth = 280,
      required this.richTextFlag,
      this.txt1,
      this.txt2,
      this.txt3,
      this.cancelBtnVisible = false,
      this.buttonText = "Continue",
      this.crossBtnVisible = true,
      this.pngPath = false});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        insetPadding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        content: Container(
          height: dialogueHeight ?? 450,
          width: MediaQuery.of(context).size.width * 0.85,
          child: Stack(
            children: [
              Positioned(
                  right: 1,
                  top: 1,
                  child: Visibility(
                    visible: crossBtnVisible!,
                    child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Image.asset(
                          "assets/images/close.png",
                          width: 15,
                        )),
                  )),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                      child: Image.asset(
                    imagePath!,
                    width: imageWidth,
                    height: imageHeight,
                  )),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Text(
                      title!,
                      textAlign: TextAlign.center,
                      style: titleStyle,
                    ),
                  ),
                  (richTextFlag == false)
                      ? Center(
                          child: Text(
                            description!,
                            textAlign: TextAlign.center,
                            style: descriptionStyle,
                          ),
                        )
                      : Center(
                          child: Text.rich(
                            TextSpan(children: <InlineSpan>[
                              TextSpan(
                                text: txt1,
                                style: descriptionStyle,
                              ),
                              TextSpan(
                                text: txt2,
                                style: descriptionHighlightStyle,
                              ),
                              TextSpan(
                                text: txt3,
                                style: descriptionStyle,
                              ),
                            ]),
                            textAlign: TextAlign.center,
                          ),
                        ),
                  // Expanded(
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Text(txt1!, maxLines: 4,style: descriptionStyle,),
                  //       Text(txt2!, maxLines: 4,style: descriptionHighlightStyle,),
                  //       Text(txt3!, maxLines: 4,style: descriptionStyle,),
                  //
                  //     ],
                  //   ),
                  // ),
                  Spacer(),
                  buttonWidget(
                      context: context,
                      text: buttonText!,
                      color: primaryColor,
                      onPress: onTap),
                  if (cancelBtnVisible == true)
                    Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        buttonWidget(
                            context: context,
                            text: buttonText!,
                            onPress: () {},
                            color: Colors.white),
                      ],
                    )
                  else
                    Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
