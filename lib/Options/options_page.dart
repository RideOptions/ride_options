import 'package:flutter/material.dart';
import 'package:rideoptions/Screens/HomePage/NavBarPages/Deposit/package.dart';
import '../Component/theme/app_theme.dart';
import '../Component/theme/text_style_theme.dart';

class options_page extends StatefulWidget {
  const options_page({Key? key}) : super(key: key);

  @override
  State<options_page> createState() => _options_pageState();
}

class _options_pageState extends State<options_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          'Options',
          style: whiteAppBarTextStyle22px(),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PackagePage())
                                // WalletPage(UModel: _user)),
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
                                  Icons.airplane_ticket,
                                  size: 60,
                                  color: primaryColor,
                                ),
                                Text(
                                  "Airplane",
                                  style: blackTextBoldIn18px(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PackagePage())
                                // WalletPage(UModel: _user)),
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
                                  Icons.directions_railway_outlined,
                                  size: 60,
                                  color: primaryColor,
                                ),
                                Text(
                                  "Railways",
                                  style: blackTextBoldIn18px(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PackagePage())
                                // WalletPage(UModel: _user)),
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
                                  Icons.directions_bus_outlined,
                                  size: 60,
                                  color: primaryColor,
                                ),
                                Text(
                                  "Buses",
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
      ),
    );
  }
}
