import 'dart:developer';

import 'package:car_buyer/Controller/mobile_auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GetBuilder<MobileController>(
          builder: (controller) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OTPTextField(
                  length: 6,
                  width: 260,
                  fieldWidth: 40,
                  keyboardType: TextInputType.number,
                  contentPadding: EdgeInsets.symmetric(vertical: 5),
                  style: TextStyle(fontSize: 17),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.box,
                  outlineBorderRadius: 7,
                  otpFieldStyle: OtpFieldStyle(
                    backgroundColor: Colors.white,
                    borderColor: Colors.black54,
                    disabledBorderColor: Color(0xffE8ECF4),
                    enabledBorderColor: Colors.deepOrange,
                    errorBorderColor: Colors.deepOrange,
                    focusBorderColor: Colors.deepOrange,
                  ),
                  onChanged: (value) {
                    value;
                    log('VALUE := $value');
                  },
                  onCompleted: (pin) {
                    log('PIN := $pin');
                    controller.fillOtp(pin);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                controller.isLoading == true
                    ? Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    : ElevatedButton(
                        onPressed: () {
                          if (controller.otpValue.length < 6) {
                            showAlert('Enter 6 digit otp');
                          } else {
                            controller.verifyOtp();
                          }
                        },
                        child: Text('Go'),
                      ),
              ],
            );
          },
        ),
      ),
    );
  }
}
