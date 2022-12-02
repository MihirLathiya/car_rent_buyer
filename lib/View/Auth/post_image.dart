import 'dart:developer';
import 'dart:io';

import 'package:car_buyer/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostImage extends StatefulWidget {
  const PostImage({Key? key}) : super(key: key);

  @override
  State<PostImage> createState() => _PostImageState();
}

class _PostImageState extends State<PostImage> {
  XFile? selectedImage;

  Future getImage({ImageSource? imageSource}) async {
    XFile? image = await ImagePicker().pickImage(source: imageSource!);

    setState(() {
      selectedImage = image;
    });
  }

  TextEditingController qauery = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await getFcmToken();

                    await getImage(imageSource: ImageSource.gallery);
                    log('PATH :- ${selectedImage!.path}');
                    log('PATH :- ${DateTime.now()}');
                  },
                  child: Text('Gallery'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () async {
                    await getImage(imageSource: ImageSource.camera);
                    log('CAMERA PATH :- ${selectedImage!.path}');
                  },
                  child: Text('Camera'),
                ),
              ],
            ),
            SizedBox(height: 20),
            if (selectedImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  File(selectedImage!.path),
                  height: 100,
                  width: 100,
                ),
              ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: qauery,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: Text('Post'),
            )
          ],
        ),
      ),
    );
  }
}
