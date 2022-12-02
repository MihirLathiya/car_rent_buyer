import 'dart:ui';

import 'package:car_buyer/Common/size_box.dart';
import 'package:car_buyer/Controller/add_image_controller.dart';
import 'package:car_buyer/Controller/email_controller.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _logEmail = TextEditingController();
  TextEditingController _logPassword = TextEditingController();
  GlobalKey<FormState> _key1 = GlobalKey();
  GlobalKey<FormState> _key2 = GlobalKey();

  final RoundedLoadingButtonController _logBtnController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();

  OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
    borderRadius: BorderRadius.circular(100),
  );
  OutlineInputBorder errorBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red),
    borderRadius: BorderRadius.circular(100),
  );
  TextStyle whiteColor = TextStyle(color: Colors.white);
  FlipCardController _controller = FlipCardController();
  EmailController emailController = Get.put(EmailController());

  ImageAddController imageAddController = Get.put(ImageAddController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        image: DecorationImage(
          image: AssetImage('assets/images/background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: GetBuilder<EmailController>(
          builder: (controller) {
            return FlipCard(
              controller: _controller,
              direction: FlipDirection.HORIZONTAL,
              back: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Welcome',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 40,
                        fontFamily: 'Mali',
                      ),
                    ),
                  ),
                  CommonSizedHeight(30.0),
                  ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 4,
                        sigmaY: 4,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Form(
                          key: _key1,
                          child: Column(
                            children: [
                              GetBuilder<ImageAddController>(
                                builder: (controller) {
                                  return GestureDetector(
                                    onTap: () {
                                      controller.pickImage();
                                    },
                                    child: Container(
                                      height: 150,
                                      width: 150,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white38,
                                      ),
                                      child: controller.userImage != null
                                          ? Image.file(
                                              controller.userImage!,
                                              fit: BoxFit.cover,
                                            )
                                          : Icon(Icons.add_a_photo),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextFormField(
                                style: whiteColor,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Enter Name';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  enabledBorder: border,
                                  focusedBorder: border,
                                  errorBorder: errorBorder,
                                  focusedErrorBorder: errorBorder,
                                  hintText: 'Name',
                                  hintStyle: whiteColor,
                                  prefixIcon: Icon(
                                    Icons.person_outline,
                                    color: Colors.grey,
                                  ),
                                ),
                                controller: _name,
                              ),
                              CommonSizedHeight(25.0),
                              TextFormField(
                                style: whiteColor,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Enter Email';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  enabledBorder: border,
                                  focusedBorder: border,
                                  errorBorder: errorBorder,
                                  focusedErrorBorder: errorBorder,
                                  hintText: 'Email',
                                  hintStyle: whiteColor,
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: Colors.grey,
                                  ),
                                ),
                                controller: _email,
                              ),
                              CommonSizedHeight(25.0),
                              TextFormField(
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Enter Password';
                                  }
                                  return null;
                                },
                                style: whiteColor,
                                decoration: InputDecoration(
                                  enabledBorder: border,
                                  focusedBorder: border,
                                  errorBorder: errorBorder,
                                  focusedErrorBorder: errorBorder,
                                  hintText: 'Password',
                                  hintStyle: whiteColor,
                                  prefixIcon: Icon(
                                    Icons.password,
                                    color: Colors.grey,
                                  ),
                                ),
                                controller: _password,
                              ),
                              CommonSizedHeight(25.0),
                              SizedBox(
                                height: 50,
                                width: 200,
                                child: RoundedLoadingButton(
                                  color: Colors.black,
                                  borderRadius: 100,
                                  child: Text(
                                    'SignUp',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  controller: _btnController,
                                  onPressed: () async {
                                    if (_key1.currentState!.validate() &&
                                        imageAddController.userImage != null) {
                                      _btnController.start();
                                      controller.signUp(
                                          email: _email.text.trim(),
                                          password: _password.text.trim(),
                                          name: _name.text.trim(),
                                          buttonController: _btnController);
                                    } else {
                                      _btnController.stop();
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account ?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.grey),
                        onPressed: () {
                          _controller.state!.toggleCard();
                          _email.clear();
                          _password.clear();
                        },
                        child: Text('LogIn'),
                      )
                    ],
                  )
                ],
              ),

              /// LOG IN
              front: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Welcome back',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 40,
                      fontFamily: 'Mali',
                    ),
                  ),
                  CommonSizedHeight(30.0),
                  ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 4,
                        sigmaY: 4,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Form(
                          key: _key2,
                          child: Column(
                            children: [
                              TextFormField(
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Enter Email';
                                  }
                                  return null;
                                },
                                style: whiteColor,
                                decoration: InputDecoration(
                                  enabledBorder: border,
                                  focusedBorder: border,
                                  errorBorder: errorBorder,
                                  focusedErrorBorder: errorBorder,
                                  hintText: 'Email',
                                  hintStyle: whiteColor,
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: Colors.grey,
                                  ),
                                ),
                                controller: _logEmail,
                              ),
                              CommonSizedHeight(25.0),
                              TextFormField(
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Enter Password';
                                  }
                                  return null;
                                },
                                style: whiteColor,
                                decoration: InputDecoration(
                                  enabledBorder: border,
                                  focusedBorder: border,
                                  errorBorder: errorBorder,
                                  focusedErrorBorder: errorBorder,
                                  hintText: 'Password',
                                  hintStyle: whiteColor,
                                  prefixIcon: Icon(
                                    Icons.password,
                                    color: Colors.grey,
                                  ),
                                ),
                                controller: _logPassword,
                              ),
                              CommonSizedHeight(25.0),
                              SizedBox(
                                height: 50,
                                width: 200,
                                child: RoundedLoadingButton(
                                  color: Colors.black,
                                  borderRadius: 100,
                                  child: Text(
                                    'Login',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  controller: _logBtnController,
                                  onPressed: () async {
                                    if (_key2.currentState!.validate()) {
                                      _logBtnController.start();
                                      controller.logIn(
                                          email: _logEmail.text.trim(),
                                          password: _logPassword.text.trim(),
                                          buttonController: _logBtnController);
                                    } else {
                                      _logBtnController.reset();
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account ?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      TextButton(
                        style:
                            TextButton.styleFrom(foregroundColor: Colors.grey),
                        onPressed: () {
                          _controller.state!.toggleCard();
                          _email.clear();
                          _password.clear();
                        },
                        child: Text('SignUp'),
                      )
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void logInMethod() async {}

  void signUpMethod() async {}
}
