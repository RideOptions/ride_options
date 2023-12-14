import 'package:flutter/material.dart';

import '../../../../Component/theme/app_theme.dart';
import '../../../../Component/theme/text_style_theme.dart';

class PackagePage extends StatefulWidget {
  const PackagePage({Key? key}) : super(key: key);

  @override
  State<PackagePage> createState() => _PackagePageState();
}

class _PackagePageState extends State<PackagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Options',style: whiteAppBarTextStyle22px(),),
      ),
      body: Center(
        child: Image.asset("assets/images/comingSoon.png",width: 250,),
      ),
    );
  }
}
