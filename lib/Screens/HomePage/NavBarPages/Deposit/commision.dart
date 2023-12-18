import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:rideoptions/Component/Common_Widget/button_widget.dart';
import 'package:rideoptions/main.dart';
import '../../../../Component/Dialogue/acitivity_indicator_dialogue.dart';
import '../../../../Component/Model/Authentication/user_model.dart';
import '../../../../Component/Model/payment_history.dart';
import '../../../../Component/Model/payment_response_model.dart';
import '../../../../Component/Provider/package_provider.dart';
import '../../../../Component/ad_mob/banner_ads.dart';
import '../../../../Component/theme/app_theme.dart';
import '../../../../Component/theme/text_style_theme.dart';
import '../../BottomNavBar/driver_nav_bar_page.dart';
import 'package:http/http.dart' as http;

class CommissionPage extends StatefulWidget {
  static const platform = const MethodChannel('com.flutter.khurramdev');

  CommissionPage({required this.UModel, required this.throughOrderPage});

  String? UModel;
  bool throughOrderPage;

  @override
  State<CommissionPage> createState() => _CommissionPageState();
}

class _CommissionPageState extends State<CommissionPage> {
  UserModel? userDetail;
  String? activePackage;
  String? displayTime;
  int? spendDays;
  int weeklyPackagePrice = 0;
  int dailyPackagePrice = 0;
  String? res;
  late PackageProvider packageProvider;
  static const platform = const MethodChannel('com.flutter.khurramdev');

  final _formKey = GlobalKey<FormState>();
  String? paymentAmount;
  String? paymentMethod;
  String? additionalNotes;

  TextEditingController paymentAmountController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  // TextEditingController paymentMethodController = TextEditingController();

  late DatabaseReference _userRef;
  UserModel? _user;
  var uid =
      currentUid != null ? currentUid : FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

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
    packageProvider = Provider.of<PackageProvider>(context, listen: false);
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // initializeComponent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          'Commissions',
          style: whiteAppBarTextStyle22px(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 50, bottom: 50, left: 16, right: 16),
        child: Center(
          child: Container(
            // width: MediaQuery.of(context).size.width *
            //     0.85, // Taking 85% of screen width
            padding: EdgeInsets.only(top: 80, left: 16, right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      'Deposit Here',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.purpleAccent,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                        letterSpacing: 1.5,
                        // increases the space between letters
                        wordSpacing: 2.0,
                        // increases the space between words
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.purpleAccent,
                        decorationStyle: TextDecorationStyle.dashed,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: paymentAmountController,
                      decoration: InputDecoration(
                        labelText: 'Payment Amount',
                        hintText: 'Enter Payment Amount',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => paymentAmount = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter payment amount';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    DropdownButtonFormField(
                      value: paymentMethod,
                      decoration: InputDecoration(
                        labelText: 'Select Payment Method',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                            child: Text('Jazz Cash'), value: 'Jazz Cash'),
                        DropdownMenuItem(
                            child: Text('Easy Paisa'), value: 'Easy Paisa'),
                        // DropdownMenuItem(child: Text('Online Payment'), value: 'Online Payment'),
                      ],
                      onChanged: (value) {
                        setState(() {
                          paymentMethod = value as String?;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a payment method';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 30),
                    buttonWidget(
                        context: context,
                        text: 'Send Payment',
                        onPress: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            int? enteredAmount =
                                int.tryParse(paymentAmountController.text);

                            if (enteredAmount != null && enteredAmount < 200) {
                              // Show toast message that the amount should be 100 or more
                              Fluttertoast.showToast(
                                  msg:
                                      "Please deposit an amount of 200 or more.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: primaryColor,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              if (paymentMethod == "Jazz Cash") {
                                await jazzCashPaymentMethod();
                              } else if (paymentMethod == "Easy Paisa") {
                                showEasyPaisaPendingDialog(context);
                                // showPaymentDialog(
                                //     context); // Show the payment dialog
                              }
                            }
                          }
                        },
                        color: primaryColor),
                    SizedBox(
                      height: 40,
                    ),
                    // Spacer(),
                    // banner == null
                    //     ? SizedBox(
                    //         height: 50,
                    //       )
                    //     : Container(
                    //         height: 80,
                    //         width: MediaQuery.of(context).size.width,
                    //         child: AdWidget(
                    //           ad: banner,
                    //         ),
                    //       ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  jazzCashPaymentMethod() async {
    int price = int.tryParse(paymentAmountController.text) ?? 0;

    Map<String, String> data = {
      "price": "${price}00",
      "Jazz_MerchantID": "51213142",
      "Jazz_Password": "713129h04u",
      "Jazz_IntegritySalt": "8v03c9fx9y",
      "paymentReturnUrl": "https://rideoptions.pk/"
    };
    String value = "";

    try {
      value = await platform.invokeMethod("Print", data);
      print("my result response: $value");
      if (value.isNotEmpty) {
        List<PaymentResponseModel> responseList = [];
        List<String> values = value.split("&");
        for (String item in values) {
          List<String> nameValue = item.split("=");
          if (nameValue.length == 2) {
            PaymentResponseModel model =
                PaymentResponseModel(key: nameValue[0], value: nameValue[1]);
            print("my model is: ${nameValue[0]} ~  ${nameValue[1]}");
            responseList.add(model);
          }
        }
        if (responseList.any((element) => element.key == "pp_ResponseCode")) {
          PaymentResponseModel responseCode = responseList
              .firstWhere((element) => element.key == "pp_ResponseCode");
          PaymentResponseModel responseMessage = responseList
              .firstWhere((element) => element.key == "pp_ResponseMessage");

          print("${responseList},  \ndqwerty");
          print("${responseCode},  \n codessss");
          print("${responseMessage},  \n messagees");

          if (responseCode.value == "000" || responseCode.value == "121") {
            print("kashii 1234");
            final DatabaseReference databaseReference = FirebaseDatabase
                .instance
                .ref()
                .child('SaTtAaYz')
                .child('paymentHistory');

            paymentHistory payment = paymentHistory(
                profielPic: _user!.profilePicture!,
                name: _user!.name!,
                type: 'Balance',
                amount: paymentAmount.toString(),
                id: DateTime.now().millisecondsSinceEpoch.toString());

            databaseReference.child(payment.id).set(payment.toMap());
            updateDeposit();
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Payment Response Success!"),
                  content: Text(responseMessage.value ??
                      "Thank you for Using JazzCash, your transaction was successful"),
                  actions: [
                    ElevatedButton(
                      child: Text(
                        "OK",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              },
            );
            loadingAlertDialog(context: context);

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => DriverNavBarPage()),
                (Route<dynamic> route) => false);
            print("====================== Success =========================");
          } else if (responseCode.value == "124" ||
              responseCode.value == "157") {
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Payment Pending!"),
                  content: Text(
                    responseMessage.value ??
                        "Something went wrong, please try again later.",
                  ),
                  actions: [
                    ElevatedButton(
                      child: Text(
                        "OK",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              },
            );
            print("====================== Pending =========================");
          } else {
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Payment Response Failed!"),
                  content: Text(responseMessage.value ??
                      "Something went wrong, please try again later."),
                  actions: [
                    ElevatedButton(
                      child: Text(
                        "OK",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
            print("====================== Failed =========================");
          }
        }
      }
    } catch (e) {
      print("jgjgss");
      print(e);
    }
  }

  void showEasyPaisaPendingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          titlePadding: EdgeInsets.all(15),
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          title: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.orange, size: 28),
              SizedBox(width: 10),
              Expanded(
                  child: Text("Easy Paisa Update",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold))),
            ],
          ),
          content: Column(
            mainAxisSize:
                MainAxisSize.min, // Ensure the column takes minimal space
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "We're currently working on integrating the Easy Paisa payment method. It will be available soon. Thank you for your patience.",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 10),
              Text(
                "ہم فی الحال ایزی پیسہ ادائیگی کے طریقہ کار کو مربوط کر رہے ہیں۔ یہ جلد دستیاب ہو گا۔ شکریہ۔",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: Text("Understood",
                  style: TextStyle(color: Colors.white, fontSize: 14)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void updateDeposit() {
    final String currentUserUID = currentUid != null
        ? currentUid
        : FirebaseAuth.instance.currentUser?.uid;

    final DatabaseReference databaseReference = FirebaseDatabase.instance
        .ref()
        .child('SaTtAaYz')
        .child('driverUsers')
        .child(currentUserUID)
        .child('deposit');
    final DatabaseReference databaseReference1 = FirebaseDatabase.instance
        .ref()
        .child('SaTtAaYz')
        .child('driverUsers')
        .child(currentUserUID); // Assuming 'users' is your database root

    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    final int additionalAmount =
        int.tryParse(paymentAmountController.text) ?? 0;

    // Create a map with the deposit data
    final Map<String, dynamic> depositData = {
      'timestamp': timestamp,
      'amount': additionalAmount,
    };

    var updatedAmount = double.parse(paymentAmountController.value.text) +
        double.parse(widget.UModel!);
    databaseReference1.update({"amount": updatedAmount.toString()});
    // Update the deposit child with the new data
    databaseReference.push().update(depositData).then((_) {
      print('Deposit updated successfully');
    }).catchError((error) {
      print('Error updating deposit: $error');
    });
  }

  void updateBalance() async {
    final String currentUserUID = currentUid != null
        ? currentUid
        : FirebaseAuth.instance.currentUser?.uid;

    final DatabaseReference databaseReference = FirebaseDatabase.instance
        .ref()
        .child("SaTtAaYz")
        .child('driverUsers')
        .child(currentUserUID);

    if (userDetail!.amount != null && paymentAmountController.text.isNotEmpty) {
      // Convert both balance and payment amount to double and then add them
      String? currentBalance = userDetail!.amount;

      String? updatedBalanceValue =
          currentBalance! + paymentAmountController.text;

      // Save the updated balance to Firebase
      databaseReference
          .update({"amount": updatedBalanceValue.toString()}).then((value) {
        updateDeposit();
        print('Balance updated successfully');
      }).catchError((error) {
        print('Error updating balance: $error');
      });
    } else {
      print('Error: Balance or Payment Amount is null or empty.');
    }
  }

  void showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Make Payment",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 16.0),
              TextFormField(
                controller: accountNumberController,
                decoration: InputDecoration(
                  labelText: 'Account Number',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: primaryColor, // Change the button's background color
                onPrimary: Colors.white, // Change the button's text color
                elevation: 4.0, // Add elevation for a raised appearance
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Round the corners
                ),
              ),
              onPressed: () {
                if (accountNumberController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Please enter account number",
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: primaryColor,
                    textColor: Colors.white,
                  );
                } else if (emailController.text.isEmpty) {
                  Fluttertoast.showToast(
                    msg: "Please enter email",
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: primaryColor,
                    textColor: Colors.white,
                  );
                } else {
                  // Handle the continue action here
                  print("On Tapped");
                }
              },
              child: Text(
                'Continue',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
