import 'package:flutter/material.dart';
import 'package:rideoptions/Component/Common_Widget/button_widget.dart';
import 'package:rideoptions/Component/theme/app_theme.dart';
import 'package:rideoptions/Screens/Authentication/login_page.dart';

import 'Component/constant.dart';

class RolePage extends StatelessWidget {
  const RolePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(15.0)),
              ),
              child: Image.asset(
                'assets/images/logoApp.png',
                width: MediaQuery.of(context).size.width * 0.4,
              ),
            ),
            // SizedBox(height: 15,),
            // Text(
            //   "Ride Options",
            //   style: primaryTextBoldIn18px(),
            // ),
            SizedBox(
              height: 80,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: buttonWidget(
                  context: context,
                  text: "Customer",
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LoginPage(
                                role: Constant.customerRole,
                              )),
                    );
                  },
                  color: primaryColor),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: buttonWidget(
                  context: context,
                  text: "Driver",
                  onPress: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(
                          role: Constant.driverRole,
                        ),
                      ),
                    );
                    // openScreen(context, OrderPage());
                  },
                  color: primaryColor),
            )
          ],
        ),
      ),
    );
  }
}
