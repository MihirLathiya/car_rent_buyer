import 'dart:developer';

import 'package:car_buyer/Controller/email_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DetailController extends GetxController {
  bool favourite = false;

  List favouriteList = [];
  isAdd() {
    favourite = true;
    update();
  }

  isRemove() {
    favourite = false;
    update();
  }

  favouriteData(List fav) {
    favouriteList = fav;
    log('DATA ADD :- $favouriteList');
    update();
  }

  favouriteAdd(String id) {
    favouriteList.add(firebaseAuth.currentUser!.uid);
    FirebaseFirestore.instance
        .collection('cars')
        .doc(id)
        .update({'isFavourite': favouriteList});

    update();
  }

  favouriteRemove(String id) {
    favouriteList.remove(firebaseAuth.currentUser!.uid);
    FirebaseFirestore.instance
        .collection('cars')
        .doc(id)
        .update({'isFavourite': favouriteList});
    update();
  }
}
