import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../../../Component/Model/Authentication/user_model.dart';
import '../../../../Component/Model/Earning/earning_model.dart';
import '../../../../Component/Services/local_service.dart';
import '../../../../Component/common_function.dart';
import '../../../../Component/theme/app_theme.dart';
import '../../../../Component/theme/text_style_theme.dart';
import '../Order/order_page.dart';

class ReceiptPage extends StatefulWidget {
  EarningModel earningModel;


  ReceiptPage({required this.earningModel});

  @override
  State<ReceiptPage> createState() => _ReceiptPageState();
}

class _ReceiptPageState extends State<ReceiptPage> {
  UserModel? userDetail;
  // double tripFare=0.0;
  // double pbTax=0.0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      initializeComponent();
    });
  }
  initializeComponent() async {
    userDetail = await LocalStorageService.getSignUpModel();
     // pbTax=(widget.earningModel.price! * 15)/100;
     // tripFare=  widget.earningModel.price!-pbTax;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Receipt',style: whiteAppBarTextStyle22px(),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: size.width,
                  height: 270,
                  color: primaryColor,
                ),
                Positioned(
                    right: 10,
                    bottom: 10,
                    child: Image.asset("assets/images/car_photo.png",width: size.width*0.5,)),
                Positioned(
                    top: 40,
                    left: 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(CommonFunctions().getDateTimeByTimeStamp(widget.earningModel.endTime, 'MMM dd, yyyy'),style: whiteTextRegularIn16px(),),
                    SizedBox(
                      width: size.width*0.5,
                      child: Text("Here's your receipt for your ride, ${userDetail?.name}",style: whiteTextBoldIn30px(),),

                    )
                  ],
                )),
              ],
            ),
            SizedBox(height:20,),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total",style: blackTextBoldIn25px(),),
                      Text("PKR ${widget.earningModel.price}.00",style: blackTextBoldIn25px(),),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    color: primaryColor,
                    width: size.width,
                    height: 1,
                  ),
                  SizedBox(height:20,),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text("Trip Fare",style: greyTextRegularIn16px(),),
                  //     Text("PKR $tripFare",style: greyTextRegularIn16px(),),
                  //   ],
                  // ),
                  // SizedBox(height:20,),
                  // Container(
                  //   margin: EdgeInsets.symmetric(vertical: 20),
                  //   color: Colors.black.withOpacity(0.5),
                  //   width: size.width,
                  //   height: 1,
                  // ),
                  // SizedBox(height:20,),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Sub Total",style: blackTextRegularIn16px(),),
                          // Text("PKR ${tripFare.toStringAsFixed(2)}",style: blackTextRegularIn16px(),),
                        ],
                      ),
                      SizedBox(height: 10,),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text("Punjab Tax Sales Tax",style: blackTextRegularIn16px(),),
                      //     Text("PKR ${ pbTax.toStringAsFixed(2)}",style: blackTextRegularIn16px(),),
                      //   ],
                      // ),
                    ],
                  ),
                  SizedBox(height:20,),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    color: Colors.black.withOpacity(0.5),
                    width: size.width,
                    height: 1,
                  ),
                  SizedBox(height:20,),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Payments",style: blackTextBoldIn16px(),),
                        ],
                      ),
                      SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.monetization_on,color: primaryColor,size: 45,),
                          SizedBox(width: 10,),
                          Expanded(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Cash",style: blackTextBoldIn16px(),),
                                Text(CommonFunctions().getDateTimeByTimeStamp(widget.earningModel.endTime, 'MM/dd/yyyy h:mm a'),style: greyTextRegularIn14px(),),
                              ],
                            ),
                          ),
                          Center(child: Text("PKR ${widget.earningModel.price}.00",style:blackTextBoldIn16px(),))
                          

                        ],
                      ),
                    ],
                  ),
                  SizedBox(height:20,),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    color: Colors.black.withOpacity(0.5),
                    width: size.width,
                    height: 1,
                  ),
                ],
              ),
            )
          ],
        ),
      ),

    );
  }
}
