import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rideoptions/Screens/HomePage/NavBarPages/Documents/show_full_image.dart';
import '../../../../Component/Common_Widget/circular_network_Image.dart';
import '../../../../Component/Common_Widget/seprator_line_wiget.dart';
import '../../../../Component/Dialogue/acitivity_indicator_dialogue.dart';
import '../../../../Component/Model/Authentication/user_model.dart';
import '../../../../Component/Provider/activity_provider.dart';
import '../../../../Component/Services/local_service.dart';
import '../../../../Component/theme/app_theme.dart';
import '../../../../Component/theme/text_style_theme.dart';
import '../../../../helper/helper.dart';
import '../../../../main.dart';

class documents_page extends StatefulWidget {
  const documents_page({Key? key}) : super(key: key);

  @override
  State<documents_page> createState() => _documents_pageState();
}

class _documents_pageState extends State<documents_page> {
  UserModel? userDetail;
  ActivityProvider? activityProvider;
  late DatabaseReference _userRef;
  UserModel? _user;
  var uid =  currentUid != null ? currentUid : FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _userRef = FirebaseDatabase.instance
        .ref()
        .child('SaTtAaYz')
        .child('driverUsers')
        .child(uid);

    _userRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          _user =
              UserModel.fromMap(event.snapshot.value as Map<dynamic, dynamic>);
        });
      }
    });

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      initializeComponent();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Documents',
            style: blackTextRegularIn30px(),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context)
                  .pop(); // This line will navigate to the previous screen
            },
          ),
        ),
        body: SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Vehicle Number",
                                        style: blackTextBoldIn16px(),
                                      ),
                                      Text(
                                        userDetail?.vehicleNumber ?? "",
                                        style: blackTextRegularIn16px(),
                                      ),
                                    ],
                                  ),
                                  SepratorLine(
                                    horizontalMargin: 0,
                                    verticalMargin: 25,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Vehicle Type",
                                        style: blackTextBoldIn16px(),
                                      ),
                                      Text(
                                        userDetail?.vehicleType ?? "",
                                        style: blackTextRegularIn16px(),
                                      ),
                                    ],
                                  ),
                                  SepratorLine(
                                    horizontalMargin: 0,
                                    verticalMargin: 25,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Vehicle Color",
                                        style: blackTextBoldIn16px(),
                                      ),
                                      Text(
                                        userDetail?.vehicleColor ?? "",
                                        style: blackTextRegularIn16px(),
                                      ),
                                    ],
                                  ),
                                  SepratorLine(
                                    horizontalMargin: 0,
                                    verticalMargin: 25,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Phone Number",
                                        style: blackTextBoldIn16px(),
                                      ),
                                      Text(
                                        userDetail?.phoneNumber ?? "",
                                        style: blackTextRegularIn16px(),
                                      ),
                                    ],
                                  ),
                                  SepratorLine(
                                    horizontalMargin: 0,
                                    verticalMargin: 25,
                                  ),
                                ],
                              ),
                              // Column(
                              //   children: [
                              //     Row(
                              //       mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //       children: [
                              //         Text(
                              //           "Email",
                              //           style: blackTextBoldIn16px(),
                              //         ),
                              //         Text(
                              //           userDetail?.email??"",
                              //           style:blackTextRegularIn16px(),
                              //         ),
                              //
                              //       ],
                              //     ),
                              //     SepratorLine(
                              //       horizontalMargin: 0,
                              //       verticalMargin: 25,
                              //     ),
                              //   ],
                              // ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "CNIC Front & Back",
                                    style: blackTextBoldIn16px(),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        openScreen(
                                          context,
                                          FullScreenImageView(
                                            imageUrl: userDetail!
                                                .nationalIdCardPhotos![0],
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: size.width * 0.6,
                                        height: 150,
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0)),
                                        ),
                                        child: Center(
                                          child: RectangularNetworkImageFrame(
                                              userDetail?.nationalIdCardPhotos![
                                                      0] ??
                                                  "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjB8fHByb2ZpbGV8ZW58MHx8MHx8&w=1000&q=80",
                                              130,
                                              size.width * 0.55,
                                              null),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      openScreen(
                                        context,
                                        FullScreenImageView(
                                          imageUrl: userDetail!
                                              .nationalIdCardPhotos![1],
                                        ),
                                      );
                                    },
                                    child: Center(
                                      child: Container(
                                        width: size.width * 0.6,
                                        height: 150,
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0)),
                                        ),
                                        child: Center(
                                          child: RectangularNetworkImageFrame(
                                              userDetail?.nationalIdCardPhotos![
                                                      1] ??
                                                  "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjB8fHByb2ZpbGV8ZW58MHx8MHx8&w=1000&q=80",
                                              130,
                                              size.width * 0.55,
                                              null),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SepratorLine(
                                    horizontalMargin: 0,
                                    verticalMargin: 15,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Documents",
                                    style: blackTextBoldIn16px(),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Center(
                                    child: Container(
                                      width: size.width * 0.6,
                                      height: 150,
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          openScreen(
                                            context,
                                            FullScreenImageView(
                                              imageUrl:
                                                  userDetail!.documentPhoto!,
                                            ),
                                          );
                                        },
                                        child: Center(
                                          child: RectangularNetworkImageFrame(
                                              userDetail?.documentPhoto ??
                                                  "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjB8fHByb2ZpbGV8ZW58MHx8MHx8&w=1000&q=80",
                                              130,
                                              size.width * 0.55,
                                              null),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SepratorLine(
                                    horizontalMargin: 0,
                                    verticalMargin: 15,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Licence",
                                    style: blackTextBoldIn16px(),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Center(
                                    child: Container(
                                      width: size.width * 0.6,
                                      height: 150,
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          openScreen(
                                            context,
                                            FullScreenImageView(
                                              imageUrl:
                                                  userDetail!.licencePhoto!,
                                            ),
                                          );
                                        },
                                        child: Center(
                                          child: RectangularNetworkImageFrame(
                                              userDetail?.licencePhoto ??
                                                  "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjB8fHByb2ZpbGV8ZW58MHx8MHx8&w=1000&q=80",
                                              130,
                                              size.width * 0.55,
                                              null),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SepratorLine(
                                    horizontalMargin: 0,
                                    verticalMargin: 15,
                                  ),
                                ],
                              ),
                            ],
                          ),
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
    activityProvider = Provider.of<ActivityProvider>(context, listen: false);
    userDetail = await LocalStorageService.getSignUpModel();

    setState(() {});
  }
}
