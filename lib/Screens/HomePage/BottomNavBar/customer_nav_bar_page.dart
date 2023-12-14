import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '../../../Component/Dialogue/app_dialogue.dart';
import '../../../Component/Provider/connectivity_provider.dart';
import '../../../Component/theme/app_theme.dart';
import '../NavBarPages/Activity/activity_page.dart';
import '../NavBarPages/Home/home_page.dart';
import '../NavBarPages/Profile/customer_profile_page.dart';

class CustomerNavBarPage extends StatefulWidget {
  const CustomerNavBarPage({Key? key}) : super(key: key);

  @override
  State<CustomerNavBarPage> createState() => _CustomerNavBarPageState();
}

class _CustomerNavBarPageState extends State<CustomerNavBarPage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      initializeComponent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: onWillPop,
        child: IndexedStack(
          index: _currentIndex,
          children:  <Widget>[
            HomePage(),
            ActivityPage(),
            CustomerProfilePage(),
          ],
        ),
      ),
      bottomNavigationBar:  BottomNavigationBar(
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
              label: 'Home',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: 'Activity',
              icon: Icon(Icons.chat_sharp),
            ),
            BottomNavigationBarItem(
              label: 'Account',
              icon: Icon(Icons.person),
            ),
          ],
        ),
    );
  }
  Future<bool> onWillPop() async {

     bool? result = await showDialog(
          context: context,
          builder: (ctx) => AppDialogue(title: "Alert",description: "Do you want exit app?",),);
     if( result==true){
       return Future.value(true);
     }
    return Future.value(false);
  }

   initializeComponent() async{
    Provider.of<ConnectivityProvider>(context,listen: false).checkInternetConnectionsLost(context);
   }
}
