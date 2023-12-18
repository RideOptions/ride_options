import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rideoptions/Component/Model/withdarw_model.dart';
import '../../../../Component/Model/Authentication/user_model.dart';
import '../../../../Component/theme/app_theme.dart';
import '../../../../main.dart';

enum WithdrawOption { withdraw, wallet }

class ReferralPage extends StatefulWidget {
  // ReferralPage({});

  // UserModel? UModel;

  @override
  _ReferralPageState createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  late DatabaseReference _userRef;
  UserModel? _user;
  var uid =
      currentUid != null ? currentUid : FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _userRef = FirebaseDatabase.instance
        .ref()
        .child('SaTtAaYz')
        .child('driverUsers')
        .child(uid);

    _userRef.onValue.listen(
      (event) {
        var snapshot = event.snapshot;
        if (snapshot.value != null) {
          // Cast snapshot value to Map<dynamic, dynamic> to use indexing
          Map<dynamic, dynamic> userData =
              snapshot.value as Map<dynamic, dynamic>;

          setState(() {
            _user = UserModel.fromMap(userData);
          });

          // Check if referralId exists in the database
          if (userData['referralId'] == null) {
            // If referralId does not exist, update it
            String newReferralId = _user!.referralId!.isNotEmpty
                ? _user!.referralId!
                : DateTime.now().millisecondsSinceEpoch.toString();
            _userRef.update({'referralId': newReferralId});
          }
        }
      },
    );
  }

  var amountCtrl = TextEditingController();
  var numberCtrl = TextEditingController();
  var accountTitleCtrl = TextEditingController();

  WithdrawOption _option = WithdrawOption.withdraw;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invite & Earn!'),
        backgroundColor: Color(0xff290D4A),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _user?.referralBalance?.isNotEmpty ?? false
                  ? int.parse(_user!.referralBalance!) >= 200
                      ? _showDialog()
                      : _showDialog()
                  : _showDialog();
              // Fluttertoast.showToast(msg: 'You can withdraw the balance of at least 200 \n آپ کم از کم 200 کا بیلنس نکال سکتے ہیں۔'):Fluttertoast.showToast(msg: 'You can withdraw the balance of at least 200 \n آپ کم از کم 200 کا بیلنس نکال سکتے ہیں۔');
            },
            child: Text(
              'Withdraw',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xff290D4A), Color(0xff707070)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildCard(
              title: 'Referral Balance',
              content: _user?.referralBalance?.isNotEmpty ?? false
                  ? _user!.referralBalance!
                  : '0.0  ',
              contentStyle: TextStyle(
                  fontSize: 24,
                  color: Color(0xffEFBE00),
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildCard(
              title: 'Total Referrals',
              content: _user?.totalReferral?.isNotEmpty ?? false
                  ? _user!.totalReferral!
                  : '0',
              contentStyle: TextStyle(
                  fontSize: 24,
                  color: Color(0xff68D9E5),
                  fontWeight: FontWeight.bold),
            ),
            Spacer(),
            _buildCard(
              title: 'Your Referral ID',
              content: _user!.referralId!,
              contentStyle: TextStyle(fontSize: 18, color: Color(0xffdad7d7)),
              trailing: IconButton(
                icon: Icon(Icons.copy, color: Color(0xffEFBE00)),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _user!.referralId!));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Referral ID copied to clipboard!'),
                    backgroundColor: Color(0xffED1F2F),
                  ));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      {required String title,
      required String content,
      TextStyle? contentStyle,
      Widget? trailing}) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                SizedBox(height: 8),
                Text(content,
                    style: contentStyle ??
                        TextStyle(fontSize: 16, color: Colors.white)),
              ],
            ),
            trailing ?? SizedBox(),
          ],
        ),
      ),
    );
  }

  void _showDialog() {
    String? selectedOption;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) setState) {
            return AlertDialog(
              title: Text(
                'Withdraw or Wallet',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // Text Fields
                      if (_option == WithdrawOption.withdraw ||
                          _option == WithdrawOption.wallet)
                        Container(
                          width: 300,
                          child: TextFormField(
                            controller: amountCtrl,
                            decoration: InputDecoration(
                              labelText: 'Enter Amount',
                              border: OutlineInputBorder(),
                              labelStyle: TextStyle(color: Colors.grey),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value == '' ||
                                  value.isEmpty) {
                                return 'Please Enter amount';
                              } else if (int.parse(value) < 200) {
                                return 'please enter amount 200 or above';
                              } else if (int.parse(value) >
                                  int.parse(_user!.referralBalance!)) {
                                return 'Insufficient Balance';
                              }
                              return null;
                            },
                          ),
                        ),
                      if (_option == WithdrawOption.withdraw)
                        SizedBox(height: 10), // Adds spacing
                      if (_option == WithdrawOption.withdraw)
                        TextFormField(
                          controller: numberCtrl,
                          decoration: InputDecoration(
                            labelText: 'Account Number',
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(color: Colors.grey),
                          ),
                          validator: (value) {
                            if (value == null || value == '' || value.isEmpty) {
                              return 'Please Enter Account Number';
                            }
                            return null;
                          },
                        ),
                      if (_option == WithdrawOption.withdraw)
                        SizedBox(height: 10),
                      if (_option == WithdrawOption.withdraw)
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Account',
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(color: Colors.grey),
                          ),
                          value: selectedOption,
                          items: [
                            DropdownMenuItem(
                                value: 'EasyPaisa', child: Text('EasyPaisa')),
                            DropdownMenuItem(
                                value: 'JazzCash', child: Text('JazzCash')),
                          ],
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedOption = newValue;
                            });
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a service';
                            }
                            return null;
                          },
                        ),
                      if (_option == WithdrawOption.withdraw)
                        SizedBox(height: 10), // Adds spacing
                      if (_option == WithdrawOption.withdraw)
                        TextFormField(
                          controller: accountTitleCtrl,
                          decoration: InputDecoration(
                            labelText: 'Account Title',
                            border: OutlineInputBorder(),
                            labelStyle: TextStyle(color: Colors.grey),
                          ),
                          validator: (value) {
                            if (value == null || value == '' || value.isEmpty) {
                              return 'Please Enter account Title';
                            }
                            return null;
                          },
                        ),
                      ListTile(
                        title: Text('Wallet'),
                        leading: Radio(
                          value: WithdrawOption.wallet,
                          groupValue: _option,
                          onChanged: (WithdrawOption? value) {
                            setState(() {
                              _option = value!;
                            });
                          },
                          activeColor: primaryColor,
                        ),
                      ),
                      ListTile(
                        title: Text('Withdraw'),
                        leading: Radio(
                          value: WithdrawOption.withdraw,
                          groupValue: _option,
                          onChanged: (WithdrawOption? value) {
                            setState(() {
                              _option = value!;
                            });
                          },
                          activeColor: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('Done'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context);
                      if (_option == WithdrawOption.withdraw) {
                        DatabaseReference dbRef = FirebaseDatabase.instance
                            .ref()
                            .child('SaTtAaYz')
                            .child('withdrawRequest');
                        Withdraw withdarw = Withdraw(
                          amount: amountCtrl.text.trim().toString(),
                          accountNumber: numberCtrl.text.trim().toString(),
                          accountTitle: accountTitleCtrl.text.trim().toString(),
                          walletName: selectedOption.toString(),
                          timestamp:
                              DateTime.now().millisecondsSinceEpoch.toString(),
                          uid: _user!.uid!,
                        );
                        dbRef
                            .child(withdarw.timestamp)
                            .set(withdarw.toMap())
                            .then((value) {
                          FirebaseDatabase.instance
                              .ref()
                              .child('SaTtAaYz')
                              .child('driverUsers')
                              .child(_user!.uid!)
                              .update({
                            'referralBalance':
                                (int.parse(_user!.referralBalance!) -
                                        int.parse(
                                            amountCtrl.text.trim().toString()))
                                    .toString()
                          }).then((value) {
                            congratesBottomSheet();
                          });
                        });
                      } else if (_option == WithdrawOption.wallet) {
                        FirebaseDatabase.instance
                            .ref()
                            .child('SaTtAaYz')
                            .child('driverUsers')
                            .child(_user!.uid!)
                            .update({
                          'referralBalance': (int.parse(
                                      _user!.referralBalance!) -
                                  int.parse(amountCtrl.text.trim().toString()))
                              .toString(),
                          'amount': (double.parse(_user!.amount!) +
                                  double.parse(
                                      amountCtrl.text.trim().toString()))
                              .toString(),
                        }).then((value) {
                          congratesBottomSheet();
                        });
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    backgroundColor: primaryColor,
                  ),
                ),
              ],
            );
          },
        );
      },
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
                  color: primaryColor,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Text(
                  _option == WithdrawOption.wallet
                      ? "Your referral balance has been successfully added to your wallet"
                      : "Your request to withdraw the referral balance has been successfully sent. Your payment will be processed and transferred to your account within 2 to 3 business days",
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
                      Navigator.pop(context);
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
                          "Go Back ",
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
          ),
        );
      },
    );
  }
}
