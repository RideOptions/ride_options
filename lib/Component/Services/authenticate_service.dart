import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:rideoptions/Component/Model/deposit/deposit_model.dart';
import 'package:rideoptions/Component/Provider/auth_provider.dart';
import 'package:rideoptions/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../Screens/Authentication/personal_detail_page.dart';
import '../../Screens/Authentication/sign_up_form_page.dart';
import '../../Screens/HomePage/BottomNavBar/customer_nav_bar_page.dart';
import '../../Screens/HomePage/BottomNavBar/driver_nav_bar_page.dart';
import '../../role_screen.dart';
import '../Common_Widget/show_snack_bar.dart';
import '../Dialogue/app_dialogue.dart';
import '../Model/Authentication/driver_user_model.dart';
import '../Model/Authentication/location.dart';
import '../Model/Authentication/user_model.dart';
import '../Model/Package/package_model.dart';
import '../common_function.dart';
import '../constant.dart';
import 'local_service.dart';

class AuthenticateService {
  bool activeStatus = false;
  // Future<void> loginWithPhone(
  //     BuildContext context, String phoneNumber, String role) async {
  //   try {
  //     FirebaseAuth auth = FirebaseAuth.instance;
  //     print("phone num code verify otp: $phoneNumber");
  //     auth
  //         .verifyPhoneNumber(
  //           phoneNumber: phoneNumber,
  //           timeout: Duration(seconds: 4),
  //           forceResendingToken: 4,
  //           verificationCompleted: (PhoneAuthCredential credential) async {
  //             await auth.signInWithCredential(credential).then((value) {
  //               print("You are logged in successfully");
  //             });
  //           },
  //           verificationFailed: (FirebaseAuthException authException) {
  //             Navigator.pop(context);
  //             print(authException.message);
  //             if (authException.toString().contains(
  //                 "We have blocked all requests from this device due to unusual activity. Try again later.")) {
  //               showSnackBar(context,
  //                   "We have blocked all requests from this device is blocked due to unusual activity. Try again later.");
  //             } else {
  //               showSnackBar(context,
  //                   "Please enter a valid phone number (ex: +123 12345678)");
  //             }
  //           },
  //           codeSent: (String verificationId, int? resendToken) {
  //             print("Verification id: $verificationId");
  //             Navigator.pop(context);
  //             Navigator.of(context).push(MaterialPageRoute(
  //                 builder: (context) => PinCodePage(
  //                       phoneNumber: phoneNumber,
  //                       role: role,
  //                     )));
  //           },
  //           codeAutoRetrievalTimeout: (String verificationId) {
  //             // showSnackBar(context,"Timed out waiting for SMS.${verificationId}");
  //           },
  //         )
  //         .timeout(Duration(seconds: 3));
  //   } on TimeoutException catch (ex) {
  //     print("TimeoutException loginWithPhone: ${ex.toString()}");
  //     showSnackBar(context, "something went wrong!");
  //   } catch (ex) {
  //     print("exception: ${ex.toString()}");
  //   }
  // }

  // Future<void> ResendOTP(
  //     BuildContext context, String phoneNumber, String role) async {
  //   try {
  //     FirebaseAuth auth = FirebaseAuth.instance;
  //     print("phone num code verify otp: $phoneNumber");
  //     await auth.verifyPhoneNumber(
  //       phoneNumber: phoneNumber,
  //       timeout: Duration(seconds: 5),
  //       verificationCompleted: (PhoneAuthCredential credential) async {
  //         await auth.signInWithCredential(credential).then((value) {
  //           print("You are logged in successfully");
  //         });
  //       },
  //       verificationFailed: (FirebaseAuthException authException) {
  //         Navigator.pop(context);
  //         print(authException.message);
  //         if (authException.toString().contains(
  //             "We have blocked all requests from this device due to unusual activity. Try again later.")) {
  //           showSnackBar(context,
  //               "We have blocked all requests from this device is blocked due to unusual activity. Try again later.");
  //         } else {
  //           showSnackBar(context,
  //               "Please enter a valid phone number (ex: +123 12345678)");
  //         }
  //       },
  //       codeSent: (String verificationId, int? resendToken) {
  //         print("Verification id: ${verificationId}");
  //
  //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //           content: Text("OTP resend successfully. "),
  //         ));
  //         Navigator.of(context).push(MaterialPageRoute(
  //             builder: (context) => PinCodePage(
  //                   phoneNumber: phoneNumber,
  //                   role: role,
  //                 )));
  //         // Navigator.of(context).pushReplacement(MaterialPageRoute(
  //         //     builder: (context) =>
  //         //         PinCodeVerificationScreen(verificationId: verificationId,signUpDetailsModel: signUpDetailsModel!,)));
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {
  //         // showSnackBar(context,"Timed out waiting for SMS.${verificationId}");
  //       },
  //     );
  //   } catch (ex) {
  //     print("exception: ${ex.toString()}");
  //   }
  // }
  void storeUID(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('uid', uid);
  }

  Future<void> verifyOTP(
    BuildContext context,
    String phoneNumber,
    String? otpCode,
    String role,
  ) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    print("rebuild");
    if (role == Constant.driverRole) {
      DriverUserModel? user = DriverCurrent;
      if (otpCode == random.toString()) {
        // print('helloasjdhvfasjndfbv asdv n\n\n\n\n\n\n ${user!.uid}');
        authProvider.phoneNoController.clear();
        currentUid = user?.uid;
        bool result = false;
        if (user != null) {
          result = await checkUserAlreadyRegister("driverUsers", user.uid!);
          storeUID(user.uid.toString());
        }

        Navigator.pop(context);
        if (result) {
          if (role == Constant.customerRole) {
            UserModel? userModel = await getCustomerUserDetails(user?.uid);
            await CommonFunctions().addCustomerDeviceToken(userModel);

            await LocalStorageService.setSignUpModel(userModel!);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => CustomerNavBarPage()),
                (Route<dynamic> route) => false);
          } else {
            UserModel? userModel = await getDriverUserDetails(user!.uid);
            print("gajjagaj>>>>>>>>>>>>>> ${userModel?.toMap()}");
            if (userModel != null &&
                userModel.status == Constant.accountApprovedStatus) {
              await CommonFunctions().addDriverDeviceToken(userModel);
              await LocalStorageService.setSignUpModel(userModel);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => DriverNavBarPage()),
                  (Route<dynamic> route) => false);
              bool netConnect =
                  await CommonFunctions().checkInternetConnection();
              if (netConnect) {
                // loadingAlertDialog(context: context);
                // activeStatus = !activeStatus;
                await CommonFunctions().permissionServices().then(
                  (value) async {
                    if (value.isNotEmpty) {
                      print("status location: $value");
                      if (value[Permission.location]?.isGranted == true) {
                        /* ========= New Screen Added  ============= */
                        var status = await Permission.location.serviceStatus;
                        if (status.isEnabled) {
                          Position? currentPosition =
                              await CommonFunctions().getCurrentLocation();
                          if (currentPosition != null) {
                            String? address = await CommonFunctions()
                                .GetAddressFromLatLong(currentPosition);
                            LocationModel model = LocationModel(
                                lat: currentPosition.latitude,
                                long: currentPosition.longitude,
                                location: address);
                            activeStatus = !activeStatus;
                            await updateLocationAndActiveStatus(
                                model, userModel!.uid!);
                            userModel?.active = activeStatus;
                            userModel?.location = model;
                            await LocalStorageService.setSignUpModel(
                                userModel!);
                          }
                        } else {
                          Position? currentPosition =
                              await CommonFunctions().getCurrentLocation();
                          if (currentPosition != null) {
                            String? address = await CommonFunctions()
                                .GetAddressFromLatLong(currentPosition);
                            LocationModel model = LocationModel(
                                lat: currentPosition.latitude,
                                long: currentPosition.longitude,
                                location: address);
                            activeStatus = !activeStatus;
                            await updateLocationAndActiveStatus(
                                model, userModel!.uid!);
                            userModel?.active = activeStatus;
                            userModel?.location = model;
                            await LocalStorageService.setSignUpModel(
                                userModel!);
                          }
                        }
                      }
                      if (value[Permission.location]?.isDenied == true ||
                          value[Permission.location]?.isPermanentlyDenied ==
                              true) {
                        await openAppSettings();
                      }
                    }
                  },
                );
                Navigator.pop(context);
              } else {
                showSnackBar(context, "please check your internet connection.");
              }
            } else if (userModel != null &&
                userModel.status == Constant.accountPendingStatus) {
              await showDialog(
                context: context,
                builder: (ctx) => AppDialogue(
                  title: "Alert",
                  description:
                      "Your driver account is awaiting approval by admin.it will be approved soon.Please wait for the approval.",
                  cancelBtnVisible: false,
                  confirmBthText: "ok",
                ),
              );
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => RolePage()),
                  (Route<dynamic> route) => false);
            } else if (userModel != null &&
                userModel.status == Constant.accountCancelStatus) {
              await showDialog(
                context: context,
                builder: (ctx) => AppDialogue(
                  title: "Alert",
                  description:
                      "Due to the unavailability of clear documentation, admin has cancelled your account. Please update your documents to rectify this situation..",
                  cancelBtnVisible: false,
                  confirmBthText: "Update",
                ),
              );
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => PersonalDetailPage(
                            phoneNumber: phoneNumber,
                            uid: user.uid!,
                            status: 'update',
                          )),
                  (Route<dynamic> route) => false);
            } else if (userModel != null &&
                userModel.status == Constant.accountBlockStatus) {
              await showDialog(
                context: context,
                builder: (ctx) => AppDialogue(
                  title: "Alert",
                  description: "your account has been blocked by admin.",
                  cancelBtnVisible: false,
                  confirmBthText: "ok",
                ),
              );
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => RolePage()),
                  (Route<dynamic> route) => false);
            }
          }
        } else {
          showSnackBar(context, "your verification code is valid.");
          if (role == Constant.customerRole) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => SignUpFormPage(
                          phoneNumber: phoneNumber,
                          uid: user != null ? user.uid! : Uuid().v4(),
                        )),
                (Route<dynamic> route) => false);
          } else {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => PersonalDetailPage(
                          phoneNumber: phoneNumber,
                          uid: user != null ? user.uid! : Uuid().v4(),
                          status: 'pending',
                        )),
                (Route<dynamic> route) => false);
          }
        }
      } else {
        Navigator.pop(context);
        showSnackBar(context, "Please enter correct verification code.");
      }
    }
    if (role == Constant.customerRole) {
      UserModel? user = userCurrent;
      if (otpCode == random.toString()) {
        authProvider.phoneNoController.clear();

        currentUid = user?.uid;
        bool result = false;
        if (user != null) {
          result = await checkUserAlreadyRegister("users", user.uid!);
        }

        Navigator.pop(context);
        if (result) {
          if (role == Constant.customerRole) {
            print(userCurrent);
            UserModel? userModel = await getCustomerUserDetails(
              user != null ? user.uid! : Uuid().v4(),
            );
            await CommonFunctions().addCustomerDeviceToken(userModel);

            await LocalStorageService.setSignUpModel(userModel!);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) {
              return CustomerNavBarPage();
            }), (Route<dynamic> route) => false);
          } else {
            UserModel? userModel = await getDriverUserDetails(user!.uid);
            print("gajjagaj>>>>>>>>>>>>>> ${userModel?.toMap()}");
            if (userModel != null &&
                userModel.status == Constant.accountApprovedStatus) {
              await CommonFunctions().addDriverDeviceToken(userModel);
              await LocalStorageService.setSignUpModel(userModel);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => DriverNavBarPage()),
                  (Route<dynamic> route) => false);
            } else if (userModel != null &&
                userModel.status == Constant.accountPendingStatus) {
              await showDialog(
                context: context,
                builder: (ctx) => AppDialogue(
                  title: "Alert",
                  description:
                      "Your driver account is awaiting approval by admin.it will be approved soon.Please wait for the approval.",
                  cancelBtnVisible: false,
                  confirmBthText: "ok",
                ),
              );
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => RolePage()),
                  (Route<dynamic> route) => false);
            } else if (userModel != null &&
                userModel.status == Constant.accountCancelStatus) {
              await showDialog(
                context: context,
                builder: (ctx) => AppDialogue(
                  title: "Alert",
                  description:
                      "Due to the unavailability of clear documentation, admin has cancelled your account. Please update your documents to rectify this situation..",
                  cancelBtnVisible: false,
                  confirmBthText: "Update",
                ),
              );
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => PersonalDetailPage(
                            phoneNumber: phoneNumber,
                            uid: user.uid!,
                            status: 'update',
                          )),
                  (Route<dynamic> route) => false);
            } else if (userModel != null &&
                userModel.status == Constant.accountBlockStatus) {
              await showDialog(
                context: context,
                builder: (ctx) => AppDialogue(
                  title: "Alert",
                  description: "your account has been blocked by admin.",
                  cancelBtnVisible: false,
                  confirmBthText: "ok",
                ),
              );
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => RolePage()),
                  (Route<dynamic> route) => false);
            }
          }
        } else {
          showSnackBar(context, "your verification code is valid.");
          if (role == Constant.customerRole) {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => SignUpFormPage(
                          phoneNumber: phoneNumber,
                          uid:
                              user != null ? user.uid! : Uuid().v4().toString(),
                        )),
                (Route<dynamic> route) => false);
          } else {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => PersonalDetailPage(
                          phoneNumber: phoneNumber,
                          uid:
                              user != null ? user.uid! : Uuid().v4().toString(),
                          status: 'pending',
                        )),
                (Route<dynamic> route) => false);
          }
        }
      } else {
        Navigator.pop(context);
        showSnackBar(context, "Please enter correct verification code.");
      }
    }
  }

  Future<UserModel?> getCustomerUserDetails(String? uid) async {
    UserModel? userData;
    try {
      var event = await FirebaseDatabase.instance
          .ref()
          .child('SaTtAaYz')
          .child("users")
          .child(uid!)
          .once()
          .timeout(Duration(seconds: 30));
      final myUser = Map<dynamic, dynamic>.from(
          event.snapshot.value as Map<dynamic, dynamic>);

      if (myUser.isNotEmpty) {
        userData = UserModel.fromMap(myUser);
      }
      return userData;
    } on TimeoutException catch (ex) {
      print("TimeOutException getUserDeatil: $ex");
      return userData;
    } catch (ex) {
      print("Exception getUserDeatil: $ex");
      return userData;
    }
  }

  Future<UserModel?> getDriverUserDetails(String? uid) async {
    UserModel? userData;
    try {
      var event = await FirebaseDatabase.instance
          .ref()
          .child('SaTtAaYz')
          .child("driverUsers")
          .child(uid!)
          .once()
          .timeout(Duration(seconds: 30));
      final myUser = Map<dynamic, dynamic>.from(
          event.snapshot.value as Map<dynamic, dynamic>);

      if (myUser.isNotEmpty) {
        userData = UserModel.fromMap(myUser);
      }
      return userData;
    } on TimeoutException catch (ex) {
      print("TimeOutException getUserDeatil: $ex");
      return userData;
    } catch (ex) {
      print("Exception getUserDeatil: $ex");
      return userData;
    }
  }

  Future<bool> checkUserAlreadyRegister(String path, String uid) async {
    try {
      var event = await FirebaseDatabase.instance
          .ref()
          .child('SaTtAaYz')
          .child(path)
          .child(uid)
          .once()
          .timeout(Duration(seconds: 30));
      if (event.snapshot.value != null) {
        return true;
      } else {
        return false;
      }
    } on TimeoutException catch (e) {
      return false;
    } catch (ex) {
      print("Exception checkUserAlreadyRegister: $ex");
      return false;
      // Navigator.pop(context);
    }
  }

  updateDriverPackageStatus(String uid, PackageModel packageModel) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("SaTtAaYz").child('driverUsers');
    await ref.child(uid).update({
      "package": packageModel.toMap(),
    });
  }

  updateDriverDepositStatus(String uid, DepositModel depositModel) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("SaTtAaYz").child('driverUsers');
    await ref.child(uid).update({
      "deposit": depositModel.toMap(),
    });
  }

  updateLocationAndActiveStatus(LocationModel model, String uid) async {
    await FirebaseDatabase.instance
        .ref()
        .child('SaTtAaYz')
        .child("driverUsers")
        .child(uid)
        .update({
      "active": activeStatus,
      "location": model.toMap(),
    });
  }
}
