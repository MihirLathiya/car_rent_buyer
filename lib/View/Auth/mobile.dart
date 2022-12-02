import 'package:car_buyer/Controller/mobile_auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EnterMobile extends StatefulWidget {
  const EnterMobile({Key? key}) : super(key: key);

  @override
  State<EnterMobile> createState() => _EnterMobileState();
}

class _EnterMobileState extends State<EnterMobile> {
  MobileController mobileController = Get.put(MobileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: GetBuilder<MobileController>(
            builder: (controller) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: controller.phone,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(),
                    ),
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
                            controller.sendOtp(context);
                          },
                          child: Text('Send Otp'),
                        )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
