import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ImageAddController extends GetxController {
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
}
