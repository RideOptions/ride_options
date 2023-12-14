import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:rideoptions/Component/Model/Authentication/user_model.dart';
import 'package:rideoptions/Component/Provider/auth_provider.dart';
import 'package:rideoptions/Component/constant.dart';
import '../../Component/Dialogue/acitivity_indicator_dialogue.dart';
import '../../Component/Model/Authentication/driver_user_model.dart';
import '../../Component/Services/authenticate_service.dart';
import '../../Component/theme/app_theme.dart';
import '../../Component/theme/text_style_theme.dart';
import '../../main.dart';

class PinCodePage extends StatefulWidget {
  String phoneNumber;
  String role;

  PinCodePage({required this.phoneNumber, required this.role});

  @override
  State<PinCodePage> createState() => _PinCodePageState();
}

class _PinCodePageState extends State<PinCodePage> {
  final formKey = GlobalKey<FormState>();
  StreamController<ErrorAnimationType>? errorController;
  TextEditingController textEditingController = TextEditingController();
  String currentText = "";
  bool hasError = false;
  bool wait = true;
  int _counter = 30;
  Timer? _timer;
  late DatabaseReference _usersRef;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      errorController = StreamController<ErrorAnimationType>();
      _startTimer();
    });
    super.initState();
    setState(
      () {},
    );
    _usersRef = FirebaseDatabase.instance
        .ref()
        .child('SaTtAaYz')
        .child(widget.role == Constant.customerRole ? 'users' : 'driverUsers');

    _usersRef.onValue.listen(
      (event) {
        if (event.snapshot.value != null) {
          final usersMap = event.snapshot.value as Map;

          usersMap.forEach(
            (key, value) {
              var user;
              if (widget.role == Constant.driverRole) {
                setState(() {});
                user = DriverUserModel.fromMap(value);
              } else {
                setState(() {});
                user = UserModel.fromMap(value);
              }
              setState(
                () {
                  if (user.phoneNumber == widget.phoneNumber) {
                    if (widget.role == Constant.customerRole) {
                      setState(() {
                        userCurrent = user;
                      });
                    } else if (widget.role == Constant.driverRole) {
                      setState(() {
                        DriverCurrent = user;
                      });
                    }
                  }
                },
              );
            },
          );
        }
      },
    );
  }

  @override
  void dispose() {
    errorController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Enter the 4-digit code to send to you at ${widget.phoneNumber}.",
                style: blackTextRegularIn20px(),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 60),
                    child: PinCodeTextField(
                      enablePinAutofill: false,
                      useExternalAutoFillGroup: false,

                      onAutoFillDisposeAction: AutofillContextAction.cancel,
                      autovalidateMode: AutovalidateMode.disabled,
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      length: 4,
                      obscureText: false,
                      obscuringCharacter: '*',
                      animationType: AnimationType.fade,
                      // validator: (v) {
                      //   if (v!.length < 3) {
                      //     return "I'm from validator";
                      //   } else {
                      //     return null;
                      //   }
                      // },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        activeFillColor: primaryColor,
                        inactiveFillColor: Colors.white,
                        errorBorderColor: Colors.red,
                        inactiveColor: lightGreyColor,
                        activeColor: Colors.transparent,
                        selectedColor: primaryColor,
                        selectedFillColor: lightGreyColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 60,
                        fieldWidth: 45,

                        //  activeFillColor: hasError ? Colors.red : Colors.white,
                      ),
                      cursorColor: Colors.white,
                      animationDuration: Duration(milliseconds: 300),
                      textStyle: TextStyle(
                          fontSize: 20, color: Colors.white, height: 1.6),
                      backgroundColor: Colors.transparent,
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      beforeTextPaste: (_) => false,
                      boxShadows: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                      onCompleted: (v) {
                        print("Completed");
                      },
                      // onTap: () {
                      //   print("Pressed");
                      // },
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "*Please fill up all the cells properly" : "",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Resend Code after : $_counter",
                    style: blackTextBoldIn14px(),
                  ),
                  if (_counter == 0)
                    TextButton(
                        onPressed: () {
                          _startTimer();
                          authProvider
                              .sendOTP(authProvider.phoneNoController.text);
                        },
                        child: Text(
                          "Resend ",
                          style: TextStyle(color: primaryColor, fontSize: 16),
                        )),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  if (textEditingController.text.length == 4) {
                    hasError = false;
                    loadingAlertDialog(context: context);
                    AuthenticateService().verifyOTP(
                      context,
                      widget.phoneNumber,
                      textEditingController.text,
                      widget.role,
                    );
                  } else {
                    setState(() {
                      hasError = true;
                    });
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 100,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: primaryColor,
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
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Next",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 8,
                      ),
                      Icon(
                        Icons.arrow_forward,
                        size: 25,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     GestureDetector(
              //       onTap: () {
              //         Navigator.pop(context);
              //       },
              //       child: Container(
              //           padding: EdgeInsets.all(15),
              //           decoration: BoxDecoration(
              //             color: lightGreyColor,
              //             boxShadow: [
              //               BoxShadow(
              //                 color: Colors.grey.shade500,
              //                 offset: const Offset(
              //                   0.0,
              //                   1.0,
              //                 ),
              //                 blurRadius: 1.0,
              //                 spreadRadius: 1.0,
              //               ), //BoxShadow
              //               BoxShadow(
              //                 color: Colors.white,
              //                 offset: const Offset(0.0, 0.0),
              //                 blurRadius: 0.0,
              //                 spreadRadius: 0.0,
              //               ), //BoxShadow
              //             ],
              //             borderRadius: BorderRadius.all(Radius.circular(30.0)),
              //           ),
              //           child: Icon(
              //             Icons.arrow_back,
              //             size: 25,
              //           )),
              //     ),
              //     GestureDetector(
              //       onTap: () {
              //         if (textEditingController.text.length == 6) {
              //           hasError = false;
              //           loadingAlertDialog(context: context);
              //           AuthenticateService().verifyOTP(
              //             context,
              //             widget.phoneNumber,
              //             textEditingController.text,
              //             widget.role,
              //           );
              //         } else {
              //           setState(() {
              //             hasError = true;
              //           });
              //         }
              //         // Navigator.push(
              //         //   context,
              //         //   MaterialPageRoute(builder: (context) =>  SignUpFormPage()),
              //         // );
              //       },
              //       child: Container(
              //           padding: EdgeInsets.all(15),
              //           decoration: BoxDecoration(
              //             color: lightGreyColor,
              //             boxShadow: [
              //               BoxShadow(
              //                 color: Colors.grey.shade500,
              //                 offset: const Offset(
              //                   0.0,
              //                   1.0,
              //                 ),
              //                 blurRadius: 1.0,
              //                 spreadRadius: 1.0,
              //               ), //BoxShadow
              //               BoxShadow(
              //                 color: Colors.white,
              //                 offset: const Offset(0.0, 0.0),
              //                 blurRadius: 0.0,
              //                 spreadRadius: 0.0,
              //               ), //BoxShadow
              //             ],
              //             borderRadius: BorderRadius.all(Radius.circular(25.0)),
              //           ),
              //           child: Row(
              //             children: [
              //               Text("Next"),
              //               SizedBox(
              //                 width: 8,
              //               ),
              //               Icon(
              //                 Icons.arrow_forward,
              //                 size: 25,
              //               ),
              //             ],
              //           )),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void _startTimer() {
    _counter = 30;
    if (_timer != null) {
      _timer?.cancel();
      setState(() {
        wait = false;
      });
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted)
        setState(() {
          if (_counter > 0) {
            _counter--;
          } else {
            _timer?.cancel();
            setState(() {
              wait = false;
            });
          }
        });
    });
  }
}
