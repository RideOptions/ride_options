import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '../../../../Component/Bottom_Sheet/select_trips_range.dart';
import '../../../../Component/Common_Widget/circular_image_frame.dart';
import '../../../../Component/Dialogue/acitivity_indicator_dialogue.dart';
import '../../../../Component/Dialogue/app_dialogue.dart';
import '../../../../Component/Model/Authentication/user_model.dart';
import '../../../../Component/Provider/activity_provider.dart';
import '../../../../Component/Services/local_service.dart';
import '../../../../Component/common_function.dart';
import '../../../../Component/theme/app_theme.dart';
import '../../../../Component/theme/text_style_theme.dart';
import '../Help/help_page.dart';
import '../TripDetails/filter_trip_page.dart';
import '../Wallet/wallet_page.dart';
import '../WebView/webview_page.dart';

class CustomerProfilePage extends StatefulWidget {
  const CustomerProfilePage({Key? key}) : super(key: key);

  @override
  State<CustomerProfilePage> createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends State<CustomerProfilePage> {
  UserModel? userDetail;
  ActivityProvider? activityProvider;

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
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userDetail?.name ?? "",
                          style: primaryTextBoldIn30px(),
                        ),
                        Text(
                          userDetail?.phoneNumber ?? "",
                          style: blackTextRegularIn16px(),
                        ),
                      ],
                    ),
                    CircularImageFrame(
                      imageUrl: userDetail?.profilePicture ??
                          "https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MjB8fHByb2ZpbGV8ZW58MHx8MHx8&w=1000&q=80",
                      outerCircleRadius: 35,
                      circleRadius: 30,
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(15.0),
                    child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20.0,
                        mainAxisSpacing: 20.0,
                        childAspectRatio: 1.0,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          InkWell(
                            onTap: () async {
                              bool? result = await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.35,
                                    decoration: new BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: new BorderRadius.only(
                                        topLeft: const Radius.circular(25.0),
                                        topRight: const Radius.circular(25.0),
                                      ),
                                    ),
                                    child: SelectTripRange()),
                              );
                              if (result == true) {
                                loadingAlertDialog(context: context);
                                bool? data = await activityProvider
                                    ?.filterActivityHistoryMethod();
                                Navigator.pop(context);
                                if (data == true) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => FilterTripPage()),
                                  );
                                }
                              }
                            },
                            child: Container(
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    CupertinoIcons.car_detailed,
                                    size: 60,
                                    color: primaryColor,
                                  ),
                                  Text(
                                    "Trips",
                                    style: blackTextBoldIn18px(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WalletPage(
                                          UModel: userDetail,
                                        )),
                              );
                            },
                            child: Container(
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.wallet,
                                    size: 60,
                                    color: primaryColor,
                                  ),
                                  Text(
                                    "Wallet",
                                    style: blackTextBoldIn18px(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileBusinessAppHelp()),
                              );

                              // await CommonFunctions().launchEmailSubmission();
                            },
                            child: Container(
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.live_help_rounded,
                                    size: 60,
                                    color: primaryColor,
                                  ),
                                  Text(
                                    "Help",
                                    style: blackTextBoldIn18px(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
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
                            child: Container(
                              decoration: BoxDecoration(
                                color: lightGreyColor,
                                // color: Colors.grey.withOpacity(0.5),
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
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.indeterminate_check_box_rounded,
                                    size: 60,
                                    color: primaryColor,
                                  ),
                                  Text(
                                    "Policy",
                                    style: blackTextBoldIn18px(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
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
                            child: Container(
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.my_library_books_sharp,
                                    size: 60,
                                    color: primaryColor,
                                  ),
                                  Text(
                                    "Terms",
                                    style: blackTextBoldIn18px(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              bool? result = await showDialog(
                                context: context,
                                builder: (ctx) => AppDialogue(
                                  title: "Alert",
                                  description: "Are you sure to logout?",
                                ),
                              );
                              if (result == true) {
                                loadingAlertDialog(context: context);
                                await CommonFunctions
                                    .deleteCustomerSessionAndLogout(
                                        uid: userDetail!.uid!,
                                        context: context);
                              }
                            },
                            child: Container(
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.logout,
                                    size: 60,
                                    color: primaryColor,
                                  ),
                                  Text(
                                    "Log Out",
                                    style: blackTextBoldIn18px(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
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
