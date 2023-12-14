import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:provider/provider.dart';
import 'package:rideoptions/Component/Provider/auth_provider.dart';
import '../../Component/Common_Widget/button_widget.dart';
import '../../Component/Dialogue/acitivity_indicator_dialogue.dart';
import '../../Component/common_function.dart';
import '../../Component/theme/app_theme.dart';
import '../../Component/theme/text_style_theme.dart';
import '../HomePage/NavBarPages/WebView/webview_page.dart';
import 'pincode_page.dart';

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  String role;
  LoginPage({Key? key, required this.role}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool phoneNoErrorVisible = false;
  String phoneNoErrorText = "";

  // var rndm = Random().nextInt(900000) + 100000;

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   // random = rndm;
  // }

  @override
  Widget build(BuildContext context) {
    KeepScreenOn.turnOff();
    Size size = MediaQuery.of(context).size;
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(size.width * 0.05),
          child: Container(
            height: size.height - 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter your mobile number",
                  style: blackTextBoldIn18px(),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Container(
                        width: size.width * 0.2,
                        height: 55,
                        decoration: BoxDecoration(
                          color: lightGreyColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade500,
                              offset: const Offset(
                                0.0,
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
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: Image.asset(
                          "assets/images/pakistan_flag.png",
                          width: 60,
                        )),
                    SizedBox(
                      width: size.width * 0.02,
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      height: 55,
                      width: size.width * 0.68,
                      decoration: BoxDecoration(
                        color: lightGreyColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade500,
                            offset: const Offset(
                              0.0,
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
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      ),
                      child: Row(
                        children: [
                          Text("+92"),
                          SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: Center(
                              child: TextField(
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Mobile number',
                                ),
                                keyboardType: TextInputType.number,
                                controller: authProvider.phoneNoController,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Visibility(
                  visible: phoneNoErrorVisible,
                  child: Text(
                    phoneNoErrorText,
                    style: errorMessageLightIn12px(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                buttonWidget(
                    context: context,
                    text: 'Continue',
                    color: primaryColor,
                    onPress: () async {
                      if (authProvider.phoneNoController.text.isNotEmpty &&
                          authProvider.phoneNoController.text.length == 10) {
                        loadingAlertDialog(context: context);
                        authProvider.sendOTP(
                            authProvider.phoneNoController.text.trim());

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => PinCodePage(
                                  phoneNumber:
                                      CommonFunctions.phoneCodeList[0] +
                                          authProvider.phoneNoController.text
                                              .toString(),
                                  role: widget.role,
                                )));
                      } else {
                        if (authProvider.phoneNoController.text.isEmpty) {
                          phoneNoErrorText = "please enter phone number";
                        } else {
                          phoneNoErrorText =
                              "please enter valid phone number ex +92-3XX-XXXXXXX";
                        }
                        phoneNoErrorVisible = true;
                        setState(() {});
                      }
                    }),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Container(
                      width: size.width * 0.4,
                      color: Colors.grey,
                      height: 2,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text("or"),
                    SizedBox(
                      width: 8,
                    ),
                    Container(
                      width: size.width * 0.4,
                      color: Colors.grey,
                      height: 2,
                    ),
                  ],
                ),
                // SizedBox(height: 40,),
                // Container(
                //   padding: EdgeInsets.all(8),
                //   height: 55,
                //   width: size.width,
                //   decoration: BoxDecoration(
                //     color: lightGreyColor,
                //     boxShadow: [
                //       BoxShadow(
                //         color: Colors.grey.shade500,
                //         offset: const Offset(
                //           0.0,
                //           1.0,
                //         ),
                //         blurRadius: 1.0,
                //         spreadRadius: 1.0,
                //       ), //BoxShadow
                //       BoxShadow(
                //         color: Colors.white,
                //         offset: const Offset(0.0, 0.0),
                //         blurRadius: 0.0,
                //         spreadRadius: 0.0,
                //       ), //BoxShadow
                //     ],
                //     borderRadius: BorderRadius.all(Radius.circular(5.0)),
                //   ),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Image.asset("assets/images/google.png",width: 35,),
                //       SizedBox(width: 8,),
                //       Text("Continue with Google",style: blackTextBoldIn16px(),)
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  "By proceeding, you consent to get call,whatsapp or SMS message, including by automated means, from ride option and its affiliates to under to number provide.",
                  style: greyTextRegularIn14px(),
                ),
                Spacer(),
                Text.rich(TextSpan(children: <InlineSpan>[
                  TextSpan(
                    text: "This site is protected by reCAPTCHA and the Google ",
                    style: greyTextRegularIn14px(),
                  ),
                  TextSpan(
                    text: "Privacy Policy",
                    style: blackTextUnderLineLightIn14px(),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WebviewPage(
                                    title: "Privacy Policy",
                                    url:
                                        "https://rideoptions.pk/PrivacyPolicy.html",
                                  )),
                        );
                      },
                  ),
                  TextSpan(
                    text: " and ",
                    style: greyTextRegularIn14px(),
                  ),
                  TextSpan(
                    text: "Term of Service",
                    style: blackTextUnderLineLightIn14px(),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WebviewPage(
                                    title: "Terms & Conditions",
                                    url:
                                        "https://drive.google.com/file/d/1C00sBYIih00MthZqAeAn38usU-XQRrQe/view?usp=sharing",
                                  )),
                        );
                      },
                  ),
                  TextSpan(
                    text: " apply.",
                    style: greyTextRegularIn14px(),
                  ),
                ])),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
