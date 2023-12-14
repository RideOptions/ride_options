import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Component/Bottom_Sheet/choose_photo_sheet.dart';
import '../../Component/Common_Widget/button_widget.dart';
import '../../Component/Common_Widget/custom_textfield_frame.dart';
import '../../Component/Common_Widget/phone_Number_frame_Template.dart';
import '../../Component/Dialogue/acitivity_indicator_dialogue.dart';
import '../../Component/Dialogue/app_dialogue.dart';
import '../../Component/Model/Authentication/user_model.dart';
import '../../Component/Provider/auth_provider.dart';
import '../../Component/common_function.dart';
import '../../Component/constant.dart';
import '../../Component/theme/app_theme.dart';
import '../../Component/theme/text_style_theme.dart';
import '../HomePage/BottomNavBar/customer_nav_bar_page.dart';

class SignUpFormPage extends StatefulWidget {
  String phoneNumber;
  String uid;
  SignUpFormPage({required this.phoneNumber, required this.uid});

  @override
  State<SignUpFormPage> createState() => _SignUpFormPageState();
}

class _SignUpFormPageState extends State<SignUpFormPage> {
  TextEditingController phoneNumberController = TextEditingController();
  // TextEditingController userNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  // TextEditingController emailController = TextEditingController();
  // bool userNameErrorVisible=false;
  bool nameErrorVisible = false;
  // bool emailErrorVisible=false;
  // String? emailErrorText;
  AuthProvider? authProvider;

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
                        SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Register",
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

                                    File? imageFile =
                                        await showModalBottomSheet(
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
                                      authProvider
                                          ?.setProfilePicture(imageFile);
                                    }
                                  },
                                  child: (authProvider?.getProfilePicture !=
                                          null)
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
                                    authProvider?.setProfilePicture(imageFile);
                                  }
                                },
                                child: Center(
                                  child: Text(
                                    "Photo /  تصویر",
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
                        // CustomTextFieldFrame(
                        //   text: "",
                        //   keyboardType: TextInputType.text,
                        //   hintText: "Enter Your User Name",
                        //   textController: userNameController,
                        //   iconVisible: true,
                        //   iconUrl: "assets/images/user.png",
                        // ),
                        // SizedBox(
                        //   height: 5,
                        // ),
                        // Visibility(
                        //   visible: userNameErrorVisible,
                        //   child: Text(
                        //     "please enter username",
                        //     style:errorMessageLightIn12px(),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        CustomTextFieldFrame(
                          text: "",
                          keyboardType: TextInputType.text,
                          hintText: "Enter Name / نام لکھیں",
                          textController: nameController,
                          iconVisible: true,
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
                        //     emailErrorText??"",
                        //     style:errorMessageLightIn12px(),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        buttonWidget(
                            context: context,
                            text: "Next",
                            color: primaryColor,
                            onPress: nextButtonClicked
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  initializeComponent() async {
    authProvider = Provider.of<AuthProvider>(context, listen: false);
    phoneNumberController.text = widget.phoneNumber;
  }

  nextButtonClicked() async {
    String? url;
    if (nameController.text.isNotEmpty) {
      // userNameErrorVisible=false;
      nameErrorVisible = false;

      // if(CommonFunctions().emailValidation(emailController.text)){
      loadingAlertDialog(context: context);
      if (authProvider?.profilePicture != null) {
        url = await CommonFunctions()
            .submitSubscription(
                file: authProvider!.profilePicture!, filename: "picture")
            .then((value) {
          storeUID(widget.uid);
        });
      }
      UserModel model = UserModel(
          uid: widget.uid,
          name: nameController.text,
          userType: 'customer',
          phoneNumber: widget.phoneNumber,
          profilePicture: url,
          // email: emailController.text,
          status: Constant.accountApprovedStatus,
          timeStamp: DateTime.now().millisecondsSinceEpoch);
      await authProvider?.submitUserDetailsMethod(
          context: context, model: model);

      // }else{
      //   emailErrorVisible=true;
      //   emailErrorText="please enter valid email address";
      //   setState(() {
      //   });
      //
      // }
    } else {
      // if(userNameController.text.isEmpty){
      //   userNameErrorVisible=true;
      // }
      if (nameController.text.isEmpty) {
        nameErrorVisible = true;
      }
      // if(emailController.text.isEmpty){
      //   emailErrorVisible=true;
      //   emailErrorText="please enter email address";
      // }
      setState(() {});
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

  void storeUID(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('uid', uid);
  }
}
