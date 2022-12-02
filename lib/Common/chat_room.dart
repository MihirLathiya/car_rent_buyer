import 'dart:io';

import 'package:car_buyer/Controller/email_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

Future<String> chatRoomId(String user1, String user2) async {
  if (user1[0].toLowerCase().codeUnitAt(0) >
      user2.toLowerCase().codeUnitAt(0)) {
    return '$user1$user2';
  } else {
    return '$user2$user1';
  }
}

class ContainerDecoration extends StatelessWidget {
  const ContainerDecoration({
    Key? key,
    required this.message,
    this.child,
    this.uid,
  }) : super(key: key);

  final QueryDocumentSnapshot<Map<String, dynamic>> message;
  final child;
  final uid;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: message['sendBy'] == firebaseAuth.currentUser!.uid
          ? Alignment.topRight
          : Alignment.topLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: message['sendBy'] == firebaseAuth.currentUser!.uid
              ? BorderRadius.only(
                  topRight: Radius.circular(0),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                )
              : BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                  topLeft: Radius.circular(0),
                ),
          color: Colors.white24,
        ),
        child: child,
      ),
    );
  }
}

Future<String?> uploadFile({File? file, String? filename}) async {
  print("File path:$file");
  try {
    var response =
        await FirebaseStorage.instance.ref("buyer/$filename").putFile(file!);
    var result = await response.storage.ref("buyer/$filename").getDownloadURL();
    return result;
  } catch (e) {
    print("ERROR===>>$e");
  }
  return null;
}
