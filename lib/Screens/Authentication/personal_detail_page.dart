import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rideoptions/Screens/Authentication/car_details_update_page.dart';
import 'package:rideoptions/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Component/Bottom_Sheet/choose_photo_sheet.dart';
import '../../Component/Common_Widget/app_frame_template.dart';
import '../../Component/Common_Widget/button_widget.dart';
import '../../Component/Common_Widget/custom_textfield_frame.dart';
import '../../Component/Dialogue/acitivity_indicator_dialogue.dart';
import '../../Component/Dialogue/app_dialogue.dart';
import '../../Component/Model/Authentication/user_model.dart';
import '../../Component/Provider/auth_provider.dart';
import '../../Component/common_function.dart';
import '../../Component/constant.dart';
import '../../Component/theme/app_theme.dart';
import '../../Component/theme/text_style_theme.dart';
import 'car_details_page.dart';

class PersonalDetailPage extends StatefulWidget {
  String phoneNumber;
  String uid;
  String status;

  PersonalDetailPage({
    required this.phoneNumber,
    required this.uid,
    required this.status,
  });

  @override
  State<PersonalDetailPage> createState() => _PersonalDetailPageState();
}

class _PersonalDetailPageState extends State<PersonalDetailPage> {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController referrelController = TextEditingController();
  TextEditingController cnicController = TextEditingController();

  // TextEditingController emailController = TextEditingController();
  bool nameErrorVisible = false;
  bool cnicErrorVisible = false;

  // bool emailErrorVisible = false;
  bool vehicleTypeErrorVisible = false;

  // String? emailErrorText;
  String? cnicErrorText;
  AuthProvider? authProvider;
  List<String> vehicleTypeList = [
    "MotorBike / بائیک",
    "Rickshaw / رکشہ",
    "Car / کار"
  ];
  String? selectedVehicle;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      initializeComponent();
    });
    phoneNumberController.text = widget.phoneNumber;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    authProvider?.profilePicture = null;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Sign Up',
          style: whiteAppBarTextStyle22px(),
        ),
      ),
      resizeToAvoidBottomInset: true,
      body: WillPopScope(
        onWillPop: onWillPop,
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Personal Details",
                              style: blackTextBoldIn20px(),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Consumer<AuthProvider>(builder:
                                (context, consumerAuthProvider, child) {
                              return GestureDetector(
                                onTap: () async {
                                  CommonFunctions().unFocus(context);

                                  File? imageFile = await showModalBottomSheet(
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25.0),
                                        topRight: Radius.circular(25.0),
                                      ),
                                    ),
                                    // barrierDismissible: false,

                                    builder: (BuildContext context) {
                                      return ChoosePhotoSheet();
                                    },
                                  );
                                  print("image file: $imageFile");
                                  if (imageFile != null) {
                                    authProvider?.setProfilePicture(imageFile);
                                  }
                                },
                                child: (authProvider?.getProfilePicture != null)
                                    ? CircleAvatar(
                                        radius: 55,
                                        backgroundColor: primaryColor,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 50,
                                          backgroundImage: FileImage(
                                            authProvider!.profilePicture!,
                                          ),
                                        ))
                                    : CircleAvatar(
                                        radius: 55,
                                        backgroundColor: primaryColor,
                                        child: CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 50,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              radius: 15,
                                              child: ColorFiltered(
                                                colorFilter: ColorFilter.mode(
                                                  primaryColor,
                                                  BlendMode.srcIn,
                                                ),
                                                child: Image.asset(
                                                  'assets/images/camera_icon.png',
                                                  fit: BoxFit
                                                      .scaleDown, // This will respect the size of the CircleAvatar.
                                                ),
                                              ),
                                            ))),
                              );
                            }),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Center(
                                child: Text(
                                  "Driver Photo / ڈرائیور کی تصویر \n witout glasses / عینک کے بغیر",
                                  style: blackTextBoldIn14px(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),

                      CustomTextFieldFrame(
                        text: "",
                        keyboardType: TextInputType.text,
                        hintText: "Enter Name / نام لکھیں",
                        iconVisible: true,
                        textController: nameController,
                        iconUrl: "assets/images/user.png",
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Visibility(
                        visible: nameErrorVisible,
                        child: Text(
                          "please enter name",
                          style: errorMessageLightIn12px(),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CustomTextFieldFrame(
                        text: "",
                        keyboardType: TextInputType.text,
                        hintText: "Enter Phone Number",
                        textController: phoneNumberController,
                        iconVisible: true,
                        isReadOnly: true,
                        iconUrl: "assets/images/call.png",
                      ),
                      // PhoneNumberFrameTemplate(
                      //   onTap: () {},
                      //   phoneCodeListItem:
                      //   CommonFunctions.phoneCodeList,
                      //   hintText: "Enter Phone Number",
                      //   isReadOnly: true,
                      //   textController: phoneNumberController,
                      //   onSelected: (newValue) {
                      //     print("tapped on selec");
                      //   },
                      // ),
                      SizedBox(
                        height: 15,
                      ),
                      CustomTextFieldFrame(
                        text: "",
                        keyboardType: TextInputType.number,
                        hintText: "Enter CNIC / شناختی کارڈ نمبر",
                        textController: cnicController,
                        iconVisible: true,
                        iconUrl: "assets/images/id-card.png",
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Visibility(
                        visible: cnicErrorVisible,
                        child: Text(
                          "please enter CNIC number",
                          style: errorMessageLightIn12px(),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // CustomTextFieldFrame(
                      //   text: "",
                      //   keyboardType: TextInputType.emailAddress,
                      //   hintText: "Enter Your Email",
                      //   iconVisible: true,
                      //   textController: emailController,
                      //   iconUrl: "assets/images/email.png",
                      //   onTap: () {},
                      // ),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      // Visibility(
                      //   visible: emailErrorVisible,
                      //   child: Text(
                      //     emailErrorText ?? "",
                      //     style:errorMessageLightIn12px(),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      AppFrameTemplate(
                        customWidget: Container(
                          margin: EdgeInsets.symmetric(vertical: 12.0),
                          child: PopupMenuButton<String>(
                              constraints: BoxConstraints.expand(
                                  width: size.width * 0.8, height: 150),
                              itemBuilder: (context) {
                                return vehicleTypeList.map((str) {
                                  return PopupMenuItem(
                                    value: str,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Text(str,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.0,
                                          )),
                                    ),
                                  );
                                }).toList();
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  selectedVehicle != null
                                      ? Text(
                                          selectedVehicle!,
                                          style: blackTextRegularIn14px(),
                                        )
                                      : Row(
                                          children: [
                                            Text(
                                              "Vehicle Type / ",
                                              style: greyTextRegularIn14px(),
                                            ),
                                            Text(
                                              " سواری",
                                              style: blackTextRegularIn14px(),
                                            ),
                                          ],
                                        ),
                                  Spacer(),
                                  Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 30,
                                    color: primaryColor,
                                  )
                                ],
                              ),
                              onSelected: (newValue) {
                                selectedVehicle = newValue;
                                setState(() {});
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Visibility(
                        visible: vehicleTypeErrorVisible,
                        child: Text(
                          "please enter vehicle type",
                          style: errorMessageLightIn12px(),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      CustomTextFieldFrame(
                        text: "",
                        keyboardType: TextInputType.text,
                        hintText: "Referral id / ریفرل آئی ڈی",
                        textController: referrelController,
                        iconVisible: true,
                        iconUrl: "assets/images/referrel.png",
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      buttonWidget(
                        context: context,
                        text: "Next",
                        color: primaryColor,
                        onPress: () {
                          // Check if the status is updated
                          if (widget.status == "pending") {
                            nextButtonClicked();
                          } else {
                            storeUID(currentUid.toString());
                            updateNextButtonClicked(); // Call the pending function
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  initializeComponent() async {
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    phoneNumberController.text = widget.phoneNumber;
  }

  void storeUID(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('uid', uid);
  }

  nextButtonClicked() async {
    String? url;

    try {
      nameErrorVisible = false;
      cnicErrorVisible = false;
      // emailErrorVisible = false;
      vehicleTypeErrorVisible = false;
      if (nameController.text.isNotEmpty &&
          cnicController.text.isNotEmpty &&
          selectedVehicle != null &&
          authProvider?.profilePicture != null) {
        if (cnicController.text.length == 13) {
          loadingAlertDialog(context: context);
          url = await CommonFunctions().submitSubscription(
            file: authProvider!.profilePicture!,
            filename: "picture.png",
            type: 'png',
          );
          if (selectedVehicle == "MotorBike / بائیک") {
            selectedVehicle = "MotorBike";
          } else if (selectedVehicle == "Rickshaw / رکشہ") {
            selectedVehicle = "Rickshaw";
          } else {
            selectedVehicle = "Car";
          }
          UserModel userModel = UserModel(
              uid: widget.uid,
              phoneNumber: widget.phoneNumber,
              active: false,
              userType: Constant.driverRole,
              profilePicture: url,
              name: nameController.text,
              nationalIdCardNumber: int.tryParse(cnicController.text),
              // email: emailController.text,
              referredBy: referrelController.text,
              referralId: DateTime.now().millisecondsSinceEpoch.toString(),
              status: Constant.accountPendingStatus,
              vehicleType: selectedVehicle);
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CarDetailsPage(
                      userModel: userModel,
                    )),
          );
        } else {
          // if(!CommonFunctions().emailValidation(emailController.text)){
          //   emailErrorVisible = true;
          //   emailErrorText = "please enter valid email address";
          // }
          if (cnicController.text.length != 13) {
            cnicErrorVisible = true;
            cnicErrorText = "please enter valid CNIC number";
          }
          setState(() {});
        }
      } else {
        if (nameController.text.isEmpty) {
          nameErrorVisible = true;
        }
        if (cnicController.text.isEmpty) {
          cnicErrorVisible = true;
          cnicErrorText = "please enter CNIC number";
        }
        // if (emailController.text.isEmpty) {
        //   emailErrorVisible = true;
        //   emailErrorText = "please enter email address";
        // }
        if (selectedVehicle == null) {
          vehicleTypeErrorVisible = true;
        }
        if (authProvider?.profilePicture == null) {
          showDialog(
            context: context,
            builder: (ctx) => AppDialogue(
              title: "Alert",
              description: "please upload your profile picture.",
              cancelBtnVisible: false,
              confirmBthText: "ok",
            ),
          );
        }
        setState(() {});
      }
    } catch (ex) {
      Navigator.pop(context);
      print("Exception:$ex");
    }
  }

  updateNextButtonClicked() async {
    String? url;

    try {
      nameErrorVisible = false;
      cnicErrorVisible = false;
      // emailErrorVisible = false;
      vehicleTypeErrorVisible = false;
      if (nameController.text.isNotEmpty &&
          cnicController.text.isNotEmpty &&
          selectedVehicle != null &&
          authProvider?.profilePicture != null) {
        if (cnicController.text.length == 13) {
          setState(() async {
            loadingAlertDialog(context: context);
            url = await CommonFunctions().submitSubscription(
              file: authProvider!.profilePicture!,
              filename: "picture.png",
              type: 'png',
            );
            if (selectedVehicle == "MotorBike / بائیک") {
              selectedVehicle = "MotorBike";
            } else if (selectedVehicle == "Rickshaw / رکشہ") {
              selectedVehicle = "Rickshaw";
            } else {
              selectedVehicle = "Car";
            }
            UserModel userModel = UserModel(
              uid: widget.uid,
              phoneNumber: widget.phoneNumber,
              active: false,
              userType: Constant.driverRole,
              profilePicture: url,
              name: nameController.text,
              nationalIdCardNumber: int.tryParse(cnicController.text),
              // email: emailController.text,
              status: Constant.updatePendingStatus,
              vehicleType: selectedVehicle,
              referredBy: referrelController.text,
            );

            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => car_details_update_page(
                        userModel: userModel,
                      )),
            );
          });
        } else {
          // if(!CommonFunctions().emailValidation(emailController.text)){
          //   emailErrorVisible = true;
          //   emailErrorText = "please enter valid email address";
          // }
          if (cnicController.text.length != 13) {
            cnicErrorVisible = true;
            cnicErrorText = "please enter valid CNIC number";
          }
          setState(() {});
        }
      } else {
        if (nameController.text.isEmpty) {
          nameErrorVisible = true;
        }
        if (cnicController.text.isEmpty) {
          cnicErrorVisible = true;
          cnicErrorText = "please enter CNIC number";
        }
        // if (emailController.text.isEmpty) {
        //   emailErrorVisible = true;
        //   emailErrorText = "please enter email address";
        // }
        if (selectedVehicle == null) {
          vehicleTypeErrorVisible = true;
        }
        if (authProvider?.profilePicture == null) {
          showDialog(
            context: context,
            builder: (ctx) => AppDialogue(
              title: "Alert",
              description: "please upload your profile picture.",
              cancelBtnVisible: false,
              confirmBthText: "ok",
            ),
          );
        }
        setState(() {});
      }
    } catch (ex) {
      Navigator.pop(context);
      print("Exception:$ex");
    }
  }

  Future<bool> onWillPop() async {
    bool? result = await showDialog(
      context: context,
      builder: (ctx) => AppDialogue(
        title: "Alert",
        description: "Do you want exit app?",
      ),
    );
    if (result == true) {
      return Future.value(true);
    }
    return Future.value(false);
  }
}
