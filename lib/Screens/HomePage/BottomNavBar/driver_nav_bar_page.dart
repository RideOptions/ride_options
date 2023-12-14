import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:provider/provider.dart';
import '../../../Component/Dialogue/app_dialogue.dart';
import '../../../Component/Model/Authentication/user_model.dart';
import '../../../Component/Provider/connectivity_provider.dart';
import '../../../Component/theme/app_theme.dart';
import '../../../main.dart';
import '../NavBarPages/Activity/activity_page.dart';
import '../NavBarPages/Deposit/commision.dart';
import '../NavBarPages/Deposit/deposit.dart';
import '../NavBarPages/Deposit/packages.dart';
import '../NavBarPages/Order/order_page.dart';
import '../NavBarPages/Profile/driver_profile_page.dart';

class DriverNavBarPage extends StatefulWidget {
  DriverNavBarPage({Key? key}) : super(key: key);

  @override
  State<DriverNavBarPage> createState() => _DriverNavBarPageState();
}

class _DriverNavBarPageState extends State<DriverNavBarPage> {
  int _currentIndex = 0;

  late DatabaseReference _userRef;
  UserModel? _user;

  var uid =
      currentUid != null ? currentUid : FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    KeepScreenOn.turnOn();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      initializeComponent();
      getUID();
    });
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: onWillPop,
        child: IndexedStack(
          index: _currentIndex,
          children: <Widget>[
            OrderPage(),
            ActivityPage(),
            CommissionPage(
                UModel:
                    _user?.amount?.isNotEmpty ?? false ? _user!.amount! : '0',
                throughOrderPage: false),

            // deposit_page(
            //   throughOrderPage: false,
            // ),
            // PackagesPage(throughOrderPage: false,),
            DriverProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryColor,
        unselectedItemColor: primaryColor.withOpacity(0.5),
        currentIndex: _currentIndex,
        onTap: (value) {
          // Respond to item press.
          setState(() => _currentIndex = value);
        },
        items: const [
          BottomNavigationBarItem(
            label: 'Requests',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Activity',
            icon: Icon(Icons.chat_sharp),
          ),
          BottomNavigationBarItem(
            label: 'Deposit',
            icon: Icon(Icons.payments),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person),
          ),
        ],
      ),
    );
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

  initializeComponent() async {
    Provider.of<ConnectivityProvider>(context, listen: false)
        .checkInternetConnectionsLost(context);
  }
}
