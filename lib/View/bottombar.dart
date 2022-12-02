import 'package:car_buyer/Controller/email_controller.dart';
import 'package:car_buyer/View/chat_screen.dart';
import 'package:car_buyer/View/favourite_screen.dart';
import 'package:car_buyer/View/home_screen.dart';
import 'package:car_buyer/View/profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controller/bottom_controller.dart';

class BottomBar extends StatefulWidget {
  BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> with WidgetsBindingObserver {
  BottomController bottomController = Get.put(BottomController());

  List pages = [
    HomeScreen(),
    ChatScreen(),
    FavouriteScreen(),
    ProfileScreen(),
  ];
  setStatus(String status) async {
    await FirebaseFirestore.instance
        .collection('buyer')
        .doc(firebaseAuth.currentUser!.uid)
        .update(
      {"status": status},
    );
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      setStatus("Offline");
      // offline
    }
    super.didChangeAppLifecycleState(state);
  }

  void initState() {
    setStatus('Online');
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        bottomNavigationBar: FloatingNavbar(
          selectedBackgroundColor: Colors.white54,
          onTap: (int val) {
            bottomController.selectItem(val);
          },
          currentIndex: bottomController.selectedPage.value,
          items: [
            FloatingNavbarItem(icon: Icons.home_outlined, title: 'Home'),
            FloatingNavbarItem(icon: Icons.chat_bubble_outline, title: 'Chats'),
            FloatingNavbarItem(
                icon: Icons.favorite_outline_rounded, title: 'Favourite'),
            FloatingNavbarItem(
                icon: Icons.settings_outlined, title: 'Settings'),
          ],
        ),
        body: pages[bottomController.selectedPage.value],
      ),
    );
  }
}
