import 'package:car_buyer/Controller/email_controller.dart';
import 'package:car_buyer/View/Auth/otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class MobileController extends GetxController {
  final TextEditingController phone = TextEditingController();
  // final TextEditingController otp = TextEditingController();
  final TextEditingController name = TextEditingController();
  String verificationIds = "";
  String otpValue = "";
  bool isLoading = false;
  bool isLoading1 = false;

  fillOtp(val) {
    otpValue = val;
    update();
  }

  sendOtp(BuildContext context) async {
    isLoading = true;
    update();
    try {
      firebaseAuth.verifyPhoneNumber(
          phoneNumber: "+91" + phone.text,
          codeAutoRetrievalTimeout: (String verificationId) {},
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
            showAlert("Otp send");
          },
          codeSent: (String verificationId, int? forceResendingToken) {
            verificationIds = verificationId;
            Get.to(
              () => OtpScreen(),
              transition: Transition.zoom,
            );

            isLoading = false;

            update();
          },
          verificationFailed: (FirebaseAuthException e) {
            isLoading = false;
            update();
            if (e.code == 'invalid-phone-number') {
              showAlert('Invalid MobileNumber');
              print('Invalid MobileNumber');
            } else if (e.code == 'missing-phone-number') {
              showAlert('Missing Phone Number');
            } else if (e.code == 'user-disabled') {
              showAlert('Number is Disabled');
              print('Number is Disabled');
            } else if (e.code == 'quota-exceeded') {
              showAlert('You try too many time. try later ');
            } else if (e.code == 'captcha-check-failed') {
              showAlert('Try Again');
            } else {
              showAlert('Verification Failed!');
            }
            print('>>> Verification Failed');
          });
    } on FirebaseAuthException catch (e) {
      print('$e');
    }
  }

  ///Verify Otp
  // verifyOtp(BuildContext context) async {
  //   try {
  //     isLoading = true;
  //     update();
  //     PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
  //         verificationId: verificationIds, smsCode: otpValue);
  //
  //     try {
  //       firebaseAuth.signInWithCredential(phoneAuthCredential).then((value) {
  //         if (phoneAuthCredential.verificationId!.isEmpty) {
  //           isLoading = false;
  //           update();
  //           showAlert("Enter Valid OTP");
  //         } else {
  //           Get.offAll(
  //             () => HomeScreen(),
  //             transition: Transition.zoom,
  //           );
  //           firebaseAuth.currentUser!.delete();
  //
  //           isLoading = false;
  //           update();
  //         }
  //       });
  //     } on FirebaseAuthException catch (e) {
  //       showAlert("Enter Valid OTP");
  //       isLoading = false;
  //       update();
  //       if (e.code == 'expired-action-code') {
  //         showAlert('Code Expired');
  //       } else if (e.code == 'invalid-verification-code') {
  //         showAlert('Invalid Code');
  //       } else if (e.code == 'user-disabled') {
  //         showAlert('User Disabled');
  //       }
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     showAlert("Enter Right OTP");
  //   } catch (e) {
  //     isLoading = false;
  //     update();
  //     print(e.toString());
  //     showAlert("Enter Right OTP");
  //   }
  // }

  Future verifyOtp() async {
    try {
      isLoading = true;
      update();

      UserCredential userCred = await firebaseAuth.signInWithCredential(
        await PhoneAuthProvider.credential(
          verificationId: verificationIds,
          smsCode: otpValue.trim(),
        ),
      );

      if (userCred.user != null) {
        showAlert('success user signed with phone number');
        isLoading = false;
        update();

        return true;
      }
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      update();
      if (e.code == 'invalid-verification-code') {
        showAlert('Invalid Code');
      }
      debugPrint(e.toString());
    }
  }
}

void showAlert(String? msg) {
  Fluttertoast.showToast(msg: msg!);
}
