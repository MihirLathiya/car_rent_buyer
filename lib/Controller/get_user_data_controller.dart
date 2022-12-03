import 'package:car_buyer/Controller/email_controller.dart';
import 'package:car_buyer/PrefrenceManager/prefrence_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class UserdataController extends GetxController {
  String name = '';
  String image = '';
  String email = '';
  String bgImage = '';
  bool chatStatus = false;
  var fcm = '';
  List allIds = [];

  getUserData() async {
    var data = await FirebaseFirestore.instance
        .collection('buyer')
        .doc(firebaseAuth.currentUser!.uid)
        .get();
    Map<String, dynamic>? userData = data.data();

    image = userData!['image'];
    name = userData['name'];
    email = userData['email'];
    bgImage = userData['bgImage'];
    PrefrenceManager.setName(name);
    PrefrenceManager.setLogIn(email);
    update();
  }

  getListOfAllUser() async {
    CollectionReference _collectionRef =
        FirebaseFirestore.instance.collection('buyer');

    QuerySnapshot querySnapshot = await _collectionRef.get();

    final allData = querySnapshot.docs.map((doc) => doc.id).toList();
    if (allData.contains(firebaseAuth.currentUser!.uid)) {
      getUserData();
    }

    print('ALL DOCS IDS :- ${allData}');
    update();
  }

  getChatStatus(roomId) async {
    var data = await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(roomId)
        .get();
    Map<String, dynamic>? userData = data.data();
    chatStatus = userData!['isChat'];
    updateStatus(roomId);
    update();
  }

  updateStatus(roomId) async {
    if (chatStatus == true) {
    } else {
      await FirebaseFirestore.instance
          .collection('chatroom')
          .doc(roomId)
          .update({'isChat': true});
    }
    update();
  }

  getFcm(String uid) async {
    var data =
        await FirebaseFirestore.instance.collection('seller').doc(uid).get();
    Map<String, dynamic>? userData = data.data();

    fcm = userData!['fcm'];

    update();
  }
}
