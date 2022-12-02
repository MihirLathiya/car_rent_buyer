import 'dart:io';

import 'package:car_buyer/Controller/email_controller.dart';
import 'package:car_buyer/Controller/get_user_data_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageAddController extends GetxController {
  UserdataController userdataController = Get.put(UserdataController());
  File? userImage;

  pickImage() async {
    var pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      userImage = File(pickedFile.path);
      update();
    }
    update();
  }

  Future<String?> uploadFile({File? file, String? filename}) async {
    print("File path:$file");
    try {
      var response =
          await FirebaseStorage.instance.ref("buyer/$filename").putFile(file!);
      var result =
          await response.storage.ref("buyer/$filename").getDownloadURL();
      return result;
    } catch (e) {
      print("ERROR===>>$e");
    }
    return null;
  }

  File? userImage1;

  pickImage1() async {
    var pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      userImage1 = File(pickedFile.path);
      await uploadFile1();

      String? imageUrl = await uploadFile1(
          file: userImage1, filename: userdataController.name);
      FirebaseFirestore.instance
          .collection('buyer')
          .doc(firebaseAuth.currentUser!.uid)
          .update({'bgImage': imageUrl});
      userdataController.getUserData();
      update();
    }
    update();
  }

  Future<String?> uploadFile1({File? file, String? filename}) async {
    print("File path:$file");
    try {
      var response = await FirebaseStorage.instance
          .ref("bgImage/$filename")
          .putFile(file!);
      var result =
          await response.storage.ref("bgImage/$filename").getDownloadURL();
      return result;
    } catch (e) {
      print("ERROR===>>$e");
    }
    return null;
  }
}
