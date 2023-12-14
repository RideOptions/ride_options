import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '../../../../Component/Model/Authentication/user_model.dart';
import '../../../../Component/Provider/earning_provider.dart';
import '../../../../Component/common_function.dart';
import '../../../../Component/theme/app_theme.dart';
import '../../../../Component/theme/text_style_theme.dart';

class WalletPage extends StatefulWidget {
  WalletPage({required this.UModel});

  UserModel? UModel;

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  EarningProvider? earningProvider;

  @override
  void initState() {
    super.initState();
    print("1234, ${widget.UModel!.amount}");
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      initializeComponent();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Stack(
          children: [
            Container(
              color: primaryColor,
            ),
            Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height * 0.13,
                    color: Colors.transparent,
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 30,
                          left: size.width * 0.5 - 110,
                          child: Container(
                            width: 240,
                            //color: Colors.green,
                            child: Center(
                              child: Text(
                                "Wallet",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 20,
                            left: 15,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.arrow_back,
                                    size: 25,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Back",
                                    style: whiteTextRegularIn16px(),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    )),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        //new Color.fromRGBO(255, 0, 0, 0.0),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40.0),
                            topRight: Radius.circular(40.0))),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Balance",
                                      style: blackTextBoldIn16px(),
                                    ),
                                    Text(
                                      widget.UModel?.amount?.isNotEmpty ?? false
                                          ? '${roundDouble(double.parse(widget.UModel!.amount!.toString()))}'
                                          : '0.00 PKR' ,
                                      // "${"0.0"} PKR",
                                      style: greyTextRegularIn16px(),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Transaction History",
                                  style: blackTextBoldIn16px(),
                                ),
                                () {
                                  if (earningProvider != null) {
                                    if (earningProvider!
                                        .earningList.isNotEmpty) {
                                      return ListView.builder(
                                          itemCount: earningProvider!
                                              .earningList.length,
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Pick Up:",
                                                            style:
                                                                blackTextBoldIn14px(),
                                                          ),
                                                          Text(
                                                            earningProvider!
                                                                    .earningList[
                                                                        index]
                                                                    .pickedUpLocation
                                                                    ?.location ??
                                                                "",
                                                            style:
                                                                greyTextRegularIn14px(),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 2,
                                                          ),
                                                          SizedBox(
                                                            height: 15,
                                                          ),
                                                          Text(
                                                            "Destination:",
                                                            style:
                                                                blackTextBoldIn14px(),
                                                          ),
                                                          Text(
                                                            earningProvider!
                                                                    .earningList[
                                                                        index]
                                                                    .destinationLocation
                                                                    ?.location ??
                                                                "",
                                                            style:
                                                                greyTextRegularIn14px(),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 2,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Column(
                                                      children: [
                                                        Text(
                                                          "Price PKR",
                                                          style:
                                                              blackTextBoldIn14px(),
                                                        ),
                                                        Text(
                                                          "${earningProvider!.earningList[index].price}.00",
                                                          style:
                                                              blackTextBoldIn14px(),
                                                        ),
                                                        Text(
                                                          "Commission PKR",
                                                          style:
                                                              blackTextBoldIn14px(),
                                                        ),
                                                        Text(
                                                          "${widget.UModel!.vehicleType == 'MotorBike' ? roundDouble(8 / 100 * earningProvider!.earningList[index].price!.toDouble()) : widget.UModel!.vehicleType == 'Car' ? roundDouble(12 / 100 * earningProvider!.earningList[index].price!.toDouble()) : roundDouble(10 / 100 * earningProvider!.earningList[index].price!.toDouble())}",
                                                          style:
                                                              blackTextBoldIn14px(),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  CommonFunctions()
                                                      .getDateTimeByTimeStamp(
                                                          earningProvider!
                                                              .earningList[
                                                                  index]
                                                              .endTime,
                                                          'dd-MM-yyyy h:mm a'),
                                                  style:
                                                      greyTextRegularIn14px(),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Container(
                                                  margin: EdgeInsets.symmetric(
                                                      vertical: 15),
                                                  width: size.width,
                                                  height: 1,
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                )
                                              ],
                                            );
                                          });
                                    } else {
                                      if (earningProvider!
                                          .getEarningListEmpty) {
                                        return Column(
                                          children: [
                                            SizedBox(
                                              height: size.height * 0.25,
                                            ),
                                            Center(
                                                child:
                                                    Text("No data available")),
                                          ],
                                        );
                                      } else {
                                        return Column(
                                          children: [
                                            SizedBox(
                                              height: size.height * 0.25,
                                            ),
                                            Center(
                                              child: CircularProgressIndicator(
                                                color: primaryColor,
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    }
                                  } else {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height: size.height * 0.25,
                                        ),
                                        Center(
                                          child: CircularProgressIndicator(
                                            color: primaryColor,
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                }(),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  initializeComponent() async {
    earningProvider = Provider.of<EarningProvider>(context, listen: false);

    await earningProvider?.getEarningMethod(user: widget.UModel!);
    setState(() {});
  }

  double roundDouble(double value, ) {
    num mod = pow(10.0, 2);
    return ((value * mod).round().toDouble() / mod);
  }

}
