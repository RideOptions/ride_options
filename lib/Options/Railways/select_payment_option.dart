import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../Component/Common_Widget/button_widget.dart';
import '../../Component/theme/app_theme.dart';

class SelectPaymentOptionPage extends StatefulWidget {
  @override
  State<SelectPaymentOptionPage> createState() => _SelectPaymentOptionPageState();
}

class _SelectPaymentOptionPageState extends State<SelectPaymentOptionPage> {
  @override

  int? selectedPaymentOption;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Payment Option'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 17.0, right: 17.0, top: 35.0),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white, // Container ka background color
                borderRadius: BorderRadius.circular(10), // Border radius
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Box shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 3), // Offset of the shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Image.asset(
                      'assets/svgexport-17 (1) 1.png', // Aapki image ki path ko yahan add karein
                      width: 40,
                      height: 40,
                    ),
                  ),
                  SizedBox(width: 12), // 12 pixels ka gap
                  Text(
                    'Credit/Debit Card',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Radio(
                      value: 1,
                      groupValue: selectedPaymentOption,
                      onChanged: (int? value) {
                        setState(() {
                          selectedPaymentOption = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16,),

          Padding(
            padding: const EdgeInsets.only(left: 17.0, right: 17.0, top: 17.0),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white, // Container ka background color
                borderRadius: BorderRadius.circular(10), // Border radius
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Box shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 3), // Offset of the shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Image.asset(
                      'assets/image 4.png', // Aapki image ki path ko yahan add karein
                      width: 40,
                      height: 40,
                    ),
                  ),
                  SizedBox(width: 12), // 12 pixels ka gap
                  Text(
                    'Easypaisa',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Radio(
                      value: 2,
                      groupValue: selectedPaymentOption,
                      onChanged: (int? value) {
                        setState(() {
                          selectedPaymentOption = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 16,),

          Padding(
            padding: const EdgeInsets.only(left: 17.0, right: 17.0, top: 17.0),
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white, // Container ka background color
                borderRadius: BorderRadius.circular(10), // Border radius
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // Box shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 3), // Offset of the shadow
                  ),
                ],
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Image.asset(
                      'assets/image 5.png', // Aapki image ki path ko yahan add karein
                      width: 40,
                      height: 40,
                    ),
                  ),
                  SizedBox(width: 12), // 12 pixels ka gap
                  Text(
                    'Jazzcash',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: 16),

                    child: Radio(
                      value: 3,
                      groupValue: selectedPaymentOption,
                      onChanged: (int? value) {
                        setState(() {
                          selectedPaymentOption = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 70,),

          buttonWidget(
            width: 254,
              context: context,
              text: 'Continue',
              color: primaryColor,
              onPress: () async {
                congratesBottomSheet();
              }),
        ],
      ),
    );
  }
  void congratesBottomSheet() {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        context: context,
        builder: (BuildContext context) {
          return Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/adding-an-order-summary-to-the-order-confirmation-page 1.png",
                    height: 280,
                    width: 310,
                  ),
                  Text(
                    "Congratulations!",
                    style: GoogleFonts.lato(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w900,
                      fontSize: 24,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Text(
                      "Your payment has been successfully processed, and your booking is confirmed.",
                      style: GoogleFonts.lato(
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: Color(0xff5F5F5F),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Container(
                      height: 50,
                      width: 250,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (_) {
                          //   return ScreenUserHome();
                          // }));
                        },
                        style: ElevatedButton.styleFrom(
                            primary: primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_back_rounded),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Back to Home",
                              style: TextStyle(
                                fontFamily: 'Open Sans',
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ));
        });
  }
}




