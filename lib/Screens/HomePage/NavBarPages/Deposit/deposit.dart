import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rideoptions/Component/theme/app_theme.dart';
import 'package:rideoptions/Screens/HomePage/NavBarPages/Deposit/commision.dart';
import 'package:rideoptions/Screens/HomePage/NavBarPages/Deposit/packages.dart';
import 'package:rideoptions/helper/helper.dart';

import '../../../../Component/Dialogue/acitivity_indicator_dialogue.dart';
import '../../../../Component/Model/Authentication/user_model.dart';
import '../../../../Component/theme/text_style_theme.dart';
import '../../../../main.dart';

class deposit_page extends StatefulWidget {
  bool throughOrderPage;

  deposit_page({Key? key, required this.throughOrderPage}) : super(key: key);

  @override
  State<deposit_page> createState() => _deposit_pageState();
}

class _deposit_pageState extends State<deposit_page> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  final List<String> imgList = [
    'assets/images/slider1.jpeg',
    'assets/images/slider2.jpeg',
    'assets/images/slider3.jpeg',
    'assets/images/slider4.jpeg',
    //  'assets/images/slider5.jpeg',
    //  'assets/images/slider6.jpeg',
  ];

  late DatabaseReference _userRef;
  UserModel? _user;

  var uid =
      currentUid != null ? currentUid : FirebaseAuth.instance.currentUser?.uid;

  // for banner ads
  //test id
  var AdUnitId = "ca-app-pub-3940256099942544/6300978111";
  //real id
  // var AdUnitId = "ca-app-pub-2881496466882737/3695820003";
  late BannerAd banner;

  void createBannerAd() {
    banner = BannerAd(
      adUnitId: AdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) => print('${ad.runtimeType} loaded.'),
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('${ad.runtimeType} failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => print('${ad.runtimeType} opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {
          print('${ad.runtimeType} closed');
          ad.dispose();
          createBannerAd();
          print('${ad.runtimeType} reloaded');
        },
      ),
    )..load();
  }

  @override
  void initState() {
    super.initState();
    getUID();
    createBannerAd();
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

    // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    //   initializeComponent();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Deposit",
                    textAlign: TextAlign.center,
                    style: blackTextBoldIn40px(),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Container(
                  height: 180,
                  child: Stack(
                    children: [
                      CarouselSlider(
                        //Slider Container properties
                        options: CarouselOptions(
                          height: 180.0,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
                          viewportFraction: 1.0,
                          initialPage: 0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          },
                        ),
                        items: imgList
                            .map((item) => ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Image.asset(
                                  item,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                )))
                            .toList(),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: imgList.asMap().entries.map((entry) {
                            return GestureDetector(
                              onTap: () => _controller.animateToPage(entry.key),
                              child: Container(
                                width: 12.0,
                                height: 12.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 4.0),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: (_current == entry.key)
                                        ? primaryColor
                                        : Colors.grey),
                              ),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 3,
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
                          loadingAlertDialog(context: context);
                          // bool? data =  await  activityProvider?.filterActivityHistoryMethod();
                          Navigator.pop(context);
                          openScreen(
                            context,
                            PackagesPage(
                              throughOrderPage: false,
                            ),
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
                                Icons.payment_outlined,
                                size: 60,
                                color: primaryColor,
                              ),
                              Text(
                                "Packages",
                                style: blackTextBoldIn18px(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          loadingAlertDialog(context: context);
                          // bool? data =  await  activityProvider?.filterActivityHistoryMethod();
                          Navigator.pop(context);
                          openScreen(
                            context,
                            CommissionPage(
                              userModel: _user?.amount?.isNotEmpty ?? false
                                  ? _user!.amount!
                                  : '0',
                              throughOrderPage: false,
                            ),
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
                                Icons.currency_exchange,
                                size: 60,
                                color: primaryColor,
                              ),
                              Text(
                                "Commisions",
                                style: blackTextBoldIn18px(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Spacer(),
                banner == null
                    ? SizedBox(
                        height: 50,
                      )
                    : Container(
                        height: 80,
                        width: MediaQuery.of(context).size.width,
                        child: AdWidget(
                          ad: banner,
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
