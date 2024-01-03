import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../Component/Bottom_Sheet/choose_photo_sheet.dart';
import '../../Component/Common_Widget/app_frame_template.dart';
import '../../Component/Common_Widget/button_widget.dart';
import '../../Component/Common_Widget/custom_textfield_frame.dart';
import '../../Component/Dialogue/acitivity_indicator_dialogue.dart';
import '../../Component/Dialogue/app_dialogue.dart';
import '../../Component/Model/Authentication/user_model.dart';
import '../../Component/Provider/auth_provider.dart';
import '../../Component/common_function.dart';
import '../../Component/theme/app_theme.dart';
import '../../Component/theme/text_style_theme.dart';

// ignore: must_be_immutable
class CarDetailsPage extends StatefulWidget {
  UserModel userModel;

  CarDetailsPage({required this.userModel});

  @override
  State<CarDetailsPage> createState() => _CarDetailsPageState();
}

class _CarDetailsPageState extends State<CarDetailsPage> {
  AuthProvider? authProvider;
  TextEditingController vehicleNumberController = TextEditingController();
  bool vehicleNumberErrorVisible = false;
  bool vehicleColorErrorVisible = false;
  bool vehicleCCErrorVisible = false;
  bool cnicForntPhotoErrorVisible = false;
  bool cnicBackPhotoErrorVisible = false;
  bool licencePhotoErrorVisible = false;
  bool vehicleDocumentsErrorVisible = false;

  List<String> vehicleColorList = [
    "White",
    "Black",
    "Gray",
    "Silver",
    "Red",
    "Blue",
    "Brown",
    "Green",
    "Beige",
    "Orange",
    "Gold",
    "Purple",
    "Other",
  ];
  List<String> vehicleCCList = [
    "700",
    "1000",
    "1300",
    "1800",
    "2000",
  ];

  String? selectedVehicleColor;
  String? selectedVehicleCC;
  String? vehicleAcValue = "withOutAC";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      initializeComponent();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Sign Up',
          style: whiteAppBarTextStyle22px(),
        ),
      ),
      body: Consumer<AuthProvider>(
          builder: (context, consumerAuthProvider, child) {
        return GestureDetector(
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
                              "Vehicle Details",
                              style: blackTextBoldIn20px(),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
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
                                  authProvider?.setVehiclePicture(imageFile);
                                }
                              },
                              child: (authProvider?.getVehiclePicture != null)
                                  ? CircleAvatar(
                                      radius: 55,
                                      backgroundColor: primaryColor,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.white,
                                        radius: 50,
                                        backgroundImage: FileImage(
                                          authProvider!.vehiclePicture!,
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
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Center(
                                child: Text(
                                  "Vehicle Photo / سواری کی تصویر",
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
                        hintText: "Vehicle Number / سواری کا نمبر",
                        textController: vehicleNumberController,
                        textCapitalization: TextCapitalization.words,
                        iconVisible: true,
                        iconUrl: "assets/images/id-card.png",
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "*Format: ABC####",
                        style: TextStyle(color: Colors.red, fontSize: 12),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Visibility(
                        visible: vehicleNumberErrorVisible,
                        child: Text(
                          "please enter name",
                          style: errorMessageLightIn12px(),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      AppFrameTemplate(
                        customWidget: Container(
                          margin: EdgeInsets.symmetric(vertical: 12.0),
                          child: PopupMenuButton<String>(
                              constraints: BoxConstraints.expand(
                                  width: size.width * 0.8, height: 350),
                              itemBuilder: (context) {
                                return vehicleColorList.map((str) {
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
                                  selectedVehicleColor != null
                                      ? Text(
                                          selectedVehicleColor ?? "",
                                          style: blackTextRegularIn14px(),
                                        )
                                      : Row(
                                          children: [
                                            Text(
                                              "Vehicle Color / ",
                                              style: greyTextRegularIn14px(),
                                            ),
                                            Text("سواری کا رنگ",
                                                style:
                                                    blackTextRegularIn14px()),
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
                                selectedVehicleColor = newValue;
                                setState(() {});
                              }),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Visibility(
                        visible: vehicleColorErrorVisible,
                        child: Text(
                          "please enter vehicle color",
                          style: errorMessageLightIn12px(),
                        ),
                      ),
                      (widget.userModel.vehicleType == "Car")
                          ? Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                AppFrameTemplate(
                                  customWidget: Container(
                                    margin:
                                        EdgeInsets.symmetric(vertical: 12.0),
                                    child: PopupMenuButton<String>(
                                        constraints: BoxConstraints.expand(
                                            width: size.width * 0.8,
                                            height: 250),
                                        itemBuilder: (context) {
                                          return vehicleCCList.map((str) {
                                            return PopupMenuItem(
                                              value: str,
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                child: Text(str,
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14.0,
                                                    )),
                                              ),
                                            );
                                          }).toList();
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text(
                                              selectedVehicleCC ??
                                                  "Select Vehicle CC",
                                              style: (selectedVehicleCC == null)
                                                  ? greyTextRegularIn14px()
                                                  : blackTextRegularIn14px(),
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
                                          selectedVehicleCC = newValue;
                                          setState(() {});
                                        }),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Visibility(
                                  visible: vehicleCCErrorVisible,
                                  child: Text(
                                    "please enter vehicle cc",
                                    style: errorMessageLightIn12px(),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Radio(
                                        value: vehicleAcValue ?? "",
                                        groupValue: "withOutAC",
                                        activeColor: primaryColor,
                                        onChanged: (newValue) {
                                          setState(() {
                                            vehicleAcValue = "withOutAC";
                                          });
                                        }),
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            vehicleAcValue = "withOutAC";
                                          });
                                        },
                                        child: Text("WithOut AC"))
                                  ],
                                ),
                                Row(
                                  children: [
                                    Radio(
                                        value: vehicleAcValue ?? "",
                                        groupValue: "withAC",
                                        activeColor: primaryColor,
                                        onChanged: (newValue) {
                                          setState(() {
                                            vehicleAcValue = "withAC";
                                          });
                                        }),
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            vehicleAcValue = "withAC";
                                          });
                                        },
                                        child: Text("With AC"))
                                  ],
                                ),
                              ],
                            )
                          : Container(),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "CNIC Front Photo / شناختی کارڈ  کی تصویر",
                        style: blackTextBoldIn14px(),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: GestureDetector(
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
                              authProvider?.setFrontCNICPicture(imageFile);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.all(1),
                            width: size.width * 0.65,
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.white,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            child: Center(
                                child: (authProvider?.frontCNICPicture != null)
                                    ? Stack(
                                        children: [
                                          Container(
                                              margin: EdgeInsets.all(8),
                                              child: Image.file(
                                                authProvider!.frontCNICPicture!,
                                                fit: BoxFit.fitWidth,
                                                width: size.width * 0.65,
                                              )),
                                          Positioned(
                                              right: 0,
                                              top: 0,
                                              child: IconButton(
                                                  onPressed: () {
                                                    authProvider!
                                                        .setFrontCNICPicture(
                                                            null);
                                                  },
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                    size: 30,
                                                  )))
                                        ],
                                      )
                                    : Icon(
                                        Icons.add_photo_alternate,
                                        size: 80,
                                        color: primaryColor,
                                      )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        visible: cnicForntPhotoErrorVisible,
                        child: Text(
                          "please upload CNIC back picture",
                          style: errorMessageLightIn12px(),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "CNIC Back Photo / شناختی کارڈ  کی تصویر",
                        style: blackTextBoldIn14px(),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: GestureDetector(
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
                              authProvider?.setBackCNICPicture(imageFile);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.all(1),
                            width: size.width * 0.65,
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.white,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            child: Center(
                                child: (authProvider?.backCNICPicture != null)
                                    ? Stack(
                                        children: [
                                          Container(
                                              margin: EdgeInsets.all(8),
                                              child: Image.file(
                                                authProvider!.backCNICPicture!,
                                                fit: BoxFit.fitWidth,
                                                width: size.width * 0.65,
                                              )),
                                          Positioned(
                                              right: 5,
                                              top: 5,
                                              child: IconButton(
                                                  onPressed: () {
                                                    authProvider!
                                                        .setBackCNICPicture(
                                                            null);
                                                  },
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                    size: 30,
                                                  )))
                                        ],
                                      )
                                    : Icon(
                                        Icons.add_photo_alternate,
                                        size: 80,
                                        color: primaryColor,
                                      )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        visible: cnicBackPhotoErrorVisible,
                        child: Text(
                          "please upload CNIC back picture",
                          style: errorMessageLightIn12px(),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Vehicle Documents / سواری کے کاغذات",
                        style: blackTextBoldIn14px(),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Center(
                        child: GestureDetector(
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
                              authProvider?.setVehicleDocuments(imageFile);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.all(1),
                            width: size.width * 0.65,
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.white,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            child: Center(
                                child: (authProvider?.vehicleDocuments != null)
                                    ? Stack(
                                        children: [
                                          Container(
                                              margin: EdgeInsets.all(8),
                                              child: Image.file(
                                                authProvider!.vehicleDocuments!,
                                                fit: BoxFit.fitWidth,
                                                width: size.width * 0.65,
                                              )),
                                          Positioned(
                                              right: 5,
                                              top: 5,
                                              child: IconButton(
                                                  onPressed: () {
                                                    authProvider!
                                                        .setVehicleDocuments(
                                                            null);
                                                  },
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                    size: 30,
                                                  )))
                                        ],
                                      )
                                    : Icon(
                                        Icons.add_photo_alternate,
                                        size: 80,
                                        color: primaryColor,
                                      )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        visible: vehicleDocumentsErrorVisible,
                        child: Text(
                          "please upload vehicle documents",
                          style: errorMessageLightIn12px(),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "License Photo / لائسنس کی تصویر",
                        style: blackTextBoldIn14px(),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: GestureDetector(
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
                              authProvider?.setLicencePicture(imageFile);
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.all(1),
                            width: size.width * 0.65,
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.white,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                            ),
                            child: Center(
                                child: (authProvider?.licencePicture != null)
                                    ? Stack(
                                        children: [
                                          Container(
                                              margin: EdgeInsets.all(8),
                                              child: Image.file(
                                                authProvider!.licencePicture!,
                                                fit: BoxFit.fitWidth,
                                                width: size.width * 0.65,
                                              )),
                                          Positioned(
                                              right: 5,
                                              top: 5,
                                              child: IconButton(
                                                  onPressed: () {
                                                    authProvider!
                                                        .setLicencePicture(
                                                            null);
                                                  },
                                                  icon: Icon(
                                                    Icons.delete,
                                                    color: Colors.red,
                                                    size: 30,
                                                  )))
                                        ],
                                      )
                                    : Icon(
                                        Icons.add_photo_alternate,
                                        size: 80,
                                        color: primaryColor,
                                      )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        visible: licencePhotoErrorVisible,
                        child: Text(
                          "please upload licence picture",
                          style: errorMessageLightIn12px(),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      buttonWidget(
                          context: context,
                          color: primaryColor,
                          text: "Next",
                          onPress: () async {
                            if (widget.userModel.vehicleType == "Car") {
                              await carValidationClicked();
                            } else {
                              await nextButtonClicked();
                            }
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  initializeComponent() async {
    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  nextButtonClicked() async {
    try {
      vehicleNumberErrorVisible = false;
      vehicleColorErrorVisible = false;
      cnicForntPhotoErrorVisible = false;
      cnicBackPhotoErrorVisible = false;
      vehicleDocumentsErrorVisible = false;
      licencePhotoErrorVisible = false;
      String? vehiclePicUrl;
      if (vehicleNumberController.text.isNotEmpty &&
          selectedVehicleColor != null &&
          authProvider!.frontCNICPicture != null &&
          authProvider!.vehicleDocuments != null &&
          authProvider!.backCNICPicture != null &&
          authProvider!.licencePicture != null &&
          authProvider!.vehiclePicture != null) {
        loadingAlertDialog(
            context: context, text: "Fetching details....", color: Colors.red);
        vehiclePicUrl = await CommonFunctions().submitSubscription(
            file: authProvider!.vehiclePicture!, filename: "picture.png");
        String CNICForntPic = await CommonFunctions().submitSubscription(
            file: authProvider!.frontCNICPicture!, filename: "picture.png");
        Navigator.pop(context);
        loadingAlertDialog(
            context: context,
            text: "Verifying documents....",
            color: Colors.orange);
        String CNICBackPic = await CommonFunctions().submitSubscription(
            file: authProvider!.backCNICPicture!, filename: "picture.png");
        String licencePic = await CommonFunctions().submitSubscription(
            file: authProvider!.licencePicture!, filename: "picture.png");
        Navigator.pop(context);
        loadingAlertDialog(context: context);
        String docUrl = await CommonFunctions().submitSubscription(
            file: authProvider!.vehicleDocuments!, filename: "picture.png");
        List<String> CINCPictureList = [];
        CINCPictureList.add(CNICForntPic);
        CINCPictureList.add(CNICBackPic);
        widget.userModel.vehiclePicture = vehiclePicUrl;
        widget.userModel.licencePhoto = licencePic;
        widget.userModel.nationalIdCardPhotos = CINCPictureList;
        widget.userModel.vehicleNumber = vehicleNumberController.text;
        widget.userModel.vehicleColor = selectedVehicleColor;
        widget.userModel.documentPhoto = docUrl;

        await authProvider?.submitDriverUserDetailsMethod(
            context: context, model: widget.userModel);
      } else {
        if (vehicleNumberController.text.isEmpty) {
          vehicleNumberErrorVisible = true;
        }
        if (selectedVehicleColor == null) {
          vehicleColorErrorVisible = true;
        }
        if (authProvider!.frontCNICPicture == null) {
          cnicForntPhotoErrorVisible = true;
        }
        if (authProvider!.backCNICPicture == null) {
          cnicBackPhotoErrorVisible = true;
        }
        if (authProvider!.vehicleDocuments == null) {
          vehicleDocumentsErrorVisible = true;
        }
        if (authProvider!.licencePicture == null) {
          licencePhotoErrorVisible = true;
        }
        if (authProvider!.vehiclePicture == null) {
          showDialog(
            context: context,
            builder: (ctx) => AppDialogue(
              title: "Alert",
              description: "please upload your vehicle picture.",
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

  carValidationClicked() async {
    try {
      vehicleNumberErrorVisible = false;
      vehicleColorErrorVisible = false;
      vehicleCCErrorVisible = false;
      cnicForntPhotoErrorVisible = false;
      cnicBackPhotoErrorVisible = false;
      vehicleDocumentsErrorVisible = false;
      licencePhotoErrorVisible = false;
      String? vehiclePicUrl;
      if (vehicleNumberController.text.isNotEmpty &&
          selectedVehicleColor != null &&
          selectedVehicleCC != null &&
          authProvider!.frontCNICPicture != null &&
          authProvider!.vehicleDocuments != null &&
          authProvider!.backCNICPicture != null &&
          authProvider!.licencePicture != null &&
          authProvider!.vehiclePicture != null) {
        loadingAlertDialog(
            context: context, text: "uploading....", color: Colors.red);
        vehiclePicUrl = await CommonFunctions().submitSubscription(
            file: authProvider!.vehiclePicture!, filename: "picture.png");
        String CNICForntPic = await CommonFunctions().submitSubscription(
            file: authProvider!.frontCNICPicture!, filename: "picture.png");
        Navigator.pop(context);
        loadingAlertDialog(
            context: context,
            text: "verifying documents....",
            color: Colors.yellow);
        String CNICBackPic = await CommonFunctions().submitSubscription(
            file: authProvider!.backCNICPicture!, filename: "picture.png");
        String licencePic = await CommonFunctions().submitSubscription(
            file: authProvider!.licencePicture!, filename: "picture.png");
        Navigator.pop(context);
        loadingAlertDialog(context: context);
        String docUrl = await CommonFunctions().submitSubscription(
            file: authProvider!.vehicleDocuments!, filename: "picture.png");
        List<String> CINCPictureList = [];
        CINCPictureList.add(CNICForntPic);
        CINCPictureList.add(CNICBackPic);
        widget.userModel.vehiclePicture = vehiclePicUrl;
        widget.userModel.licencePhoto = licencePic;
        widget.userModel.nationalIdCardPhotos = CINCPictureList;
        widget.userModel.vehicleNumber = vehicleNumberController.text;
        widget.userModel.vehicleColor = selectedVehicleColor;
        widget.userModel.documentPhoto = docUrl;
        if (vehicleAcValue == "withAC" &&
            int.parse(selectedVehicleCC!) <= 1000) {
          widget.userModel.Mini = true;
          widget.userModel.RideGo = true;
          widget.userModel.RideX = false;
        } else if (vehicleAcValue == "withAC" &&
            int.parse(selectedVehicleCC!) > 1000) {
          widget.userModel.Mini = true;
          widget.userModel.RideGo = true;
          widget.userModel.RideX = true;
        } else {
          widget.userModel.Mini = true;
          widget.userModel.RideGo = false;
          widget.userModel.RideX = false;
        }

        await authProvider?.submitDriverUserDetailsMethod(
            context: context, model: widget.userModel);
      } else {
        if (vehicleNumberController.text.isEmpty) {
          vehicleNumberErrorVisible = true;
        }
        if (selectedVehicleColor == null) {
          vehicleColorErrorVisible = true;
        }
        if (selectedVehicleCC == null) {
          vehicleCCErrorVisible = true;
        }
        if (authProvider!.frontCNICPicture == null) {
          cnicForntPhotoErrorVisible = true;
        }
        if (authProvider!.backCNICPicture == null) {
          cnicBackPhotoErrorVisible = true;
        }
        if (authProvider!.vehicleDocuments == null) {
          vehicleDocumentsErrorVisible = true;
        }
        if (authProvider!.licencePicture == null) {
          licencePhotoErrorVisible = true;
        }
        if (authProvider!.vehiclePicture == null) {
          showDialog(
            context: context,
            builder: (ctx) => AppDialogue(
              title: "Alert",
              description: "please upload your vehicle picture.",
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
}
