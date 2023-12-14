import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rideoptions/Component/Common_Widget/button_widget.dart';
import 'package:uuid/uuid.dart';
import '../../../../Component/theme/app_theme.dart';
import '../../../../helper/colors.dart';
import '../../../../helper/globel_methods.dart';
import '../../../../main.dart';

class ProfileBusinessAppHelp extends StatefulWidget {
  @override
  State<ProfileBusinessAppHelp> createState() => _ProfileBusinessAppHelpState();
}

class _ProfileBusinessAppHelpState extends State<ProfileBusinessAppHelp> {
  final TextEditingController _name = TextEditingController(text: '');

  final TextEditingController _contactNumber = TextEditingController(text: '');

  final TextEditingController _EmailController =
      TextEditingController(text: '');

  final TextEditingController _feedbackcontroller =
      TextEditingController(text: '');

  bool _isLoading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FocusNode _namefocusnode = FocusNode();

  final FocusNode _contactfocusnode = FocusNode();

  final FocusNode _emailfocusnode = FocusNode();

  final FocusNode _Feedbackfocusnode = FocusNode();

  final databaseReference = FirebaseDatabase.instance.ref();

  @override
  void dispose() {
    _EmailController.dispose();
    _name.dispose();
    _contactNumber.dispose();
    _feedbackcontroller.dispose();

    _namefocusnode.dispose();
    _contactfocusnode.dispose();
    _emailfocusnode.dispose();
    _Feedbackfocusnode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: Colors.black,
            size: 18,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Help",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 23, color: Colors.black),
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height / 1.70,
              width: MediaQuery.of(context).size.width * 0.90,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(blurRadius: 4, color: Colors.grey)]),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 50,
                      child: Text(
                        'Contact Us',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                    Container(
                      height: 43,
                      width: MediaQuery.of(context).size.width * 0.90,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                        border: Border(),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.30),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _name,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () =>
                            FocusScope.of(context).requestFocus(_namefocusnode),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Your Name",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Color(0xff7D7D7D),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 43,
                      // height: MediaQuery.of(context).size.height/9,
                      width: MediaQuery.of(context).size.width * 0.90,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                        border: Border(),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.30),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _contactNumber,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_contactfocusnode),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Your contact number",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Color(0xff7D7D7D),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 43,
                      // height: MediaQuery.of(context).size.height/9,
                      width: MediaQuery.of(context).size.width * 0.90,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                        border: Border(),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.30),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: TextField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_emailfocusnode),
                        keyboardType: TextInputType.emailAddress,
                        controller: _EmailController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Your Email",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Color(0xff7D7D7D),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.90,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(2),
                        border: Border(),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.30),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: TextField(
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => FocusScope.of(context)
                            .requestFocus(_Feedbackfocusnode),
                        keyboardType: TextInputType.text,
                        controller: _feedbackcontroller,
                        maxLines: 5,
                        decoration: InputDecoration(
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          hintText:
                              "Feedback, Questions, Concerns...We want to hear from you!!",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12,
                            color: Color(0xff7D7D7D),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    // buttonWidget(context: context, text: 'Send', color: primaryColor, onPress: () async{
                    //   if (_name.text == '') {
                    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //         content: Text('please enter your name')));
                    //   } else if (_contactNumber.text == '') {
                    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //         content: Text('please enter contact number')));
                    //   } else if (_EmailController.text == '') {
                    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //         content: Text('please enter email address')));
                    //   } else if (_feedbackcontroller.text == '') {
                    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //         content: Text('please enter your feedback')));
                    //   } else {
                    //     _uploadHelpData();
                    //
                    //   }
                    // }),
                    TextButton(
                      style: TextButton.styleFrom(
                          minimumSize: const Size(200, 45),
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          )),
                      onPressed: () async {
                        if (_name.text == '') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('please enter your name')));
                        } else if (_contactNumber.text == '') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('please enter contact number')));
                        } else if (_EmailController.text == '') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('please enter email address')));
                        } else if (_feedbackcontroller.text == '') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('please enter your feedback')));
                        } else {
                          _uploadHelpData();
                        }
                        ;
                      },
                      child: Text("Send",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          )
                          // button,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Text(
                "We Are Available On",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.wordpress_sharp,
                      color: lightGreyColor,
                    ),
                  ),
                  Text(
                    "www.rideoptions.pk",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.mail_outline_rounded,
                      color: lightGreyColor,
                    ),
                  ),
                  Text(
                    "rideoptions.pk@gmail.com",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Icon(
                      Icons.phone,
                      color: lightGreyColor,
                    ),
                  ),
                  Text(
                    "042-35-44-33-55",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _uploadHelpData() async {
    // showProgressindicator();
    try {
      final autoid = Uuid().v4();
      final User? user = _auth.currentUser;
      final _uid =  currentUid != null ? currentUid : FirebaseAuth.instance.currentUser?.uid;

      // FirebaseFirestore.instance.collection('Help').doc(autoid)
      databaseReference.child('SaTtAaYz').child('Help').set({
        'name': _name.text.toString().trim(),
        'contactNo': _contactNumber.text.toString().trim(),
        'email': _EmailController.text.toString().trim(),
        'feedback': _feedbackcontroller.text.toString().trim(),
        'uid': _uid,
        'updatedOn': DateTime.now(),
        'key': autoid,
      }).whenComplete(() => GlobalMethod.showErrorDialog(
          error:
              'Your help request has been submitted successfully. Our support team has been notified and will get back to you shortly. We appreciate your patience',
          ctx: context));

      // Navigator.pop(context);
      // Navigator.canPop(context) ? Navigator.pop(context) : null;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
    Navigator.pop(context);
  }

  void showProgressindicator() {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(
            color: Color(0xffD8543B),
          ),
        );
      },
    );
  }
}
