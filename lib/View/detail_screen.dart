import 'dart:developer';

import 'package:car_buyer/Common/chat_room.dart';
import 'package:car_buyer/Common/color.dart';
import 'package:car_buyer/Common/common_text.dart';
import 'package:car_buyer/Controller/detail_controller.dart';
import 'package:car_buyer/Controller/email_controller.dart';
import 'package:car_buyer/Controller/get_user_data_controller.dart';
import 'package:car_buyer/View/chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailScreen extends StatefulWidget {
  final String? company,
      carName,
      color,
      fuelType,
      rentType,
      seat,
      transmission,
      type,
      price,
      driver,
      id,
      sellerId,
      sellerName;
  final List? carImage, favouriteList;
  DetailScreen(
      {Key? key,
      this.company,
      this.carName,
      this.carImage,
      this.color,
      this.fuelType,
      this.rentType,
      this.seat,
      this.transmission,
      this.type,
      this.driver,
      this.price,
      this.id,
      this.favouriteList,
      this.sellerId,
      this.sellerName})
      : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  DetailController detailController = Get.put(DetailController());
  UserdataController userdataController = Get.put(UserdataController());

  @override
  void initState() {
    detailController.favouriteData(widget.favouriteList!);
    userdataController.getFcm(widget.sellerId!);
    super.initState();
  }

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
      child: GetBuilder<DetailController>(
        builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              child: Container(
                margin: EdgeInsets.only(bottom: 5, right: 5, left: 5),
                width: Get.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: Colors.white12,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              splashRadius: 20,
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_sharp,
                                color: Colors.white,
                              ),
                            ),
                            CommonText(
                              text: '${widget.company} ${widget.carName}',
                              size: 16,
                              color: AppColors.white,
                              weight: FontWeight.w700,
                            ),
                            Spacer(),
                            IconButton(
                              splashRadius: 20,
                              onPressed: () {
                                if (controller.favouriteList
                                    .contains(firebaseAuth.currentUser!.uid)) {
                                  controller.favouriteRemove(widget.id!);
                                  FirebaseFirestore.instance
                                      .collection('favourite')
                                      .doc(firebaseAuth.currentUser!.uid)
                                      .collection('fav')
                                      .doc(widget.id)
                                      .delete();
                                } else {
                                  controller.favouriteAdd(widget.id!);
                                  FirebaseFirestore.instance
                                      .collection('favourite')
                                      .doc(firebaseAuth.currentUser!.uid)
                                      .collection('fav')
                                      .doc(widget.id)
                                      .set(
                                    {
                                      "CarImage": FieldValue.arrayUnion(
                                          widget.carImage!),
                                      "Time": DateTime.now(),
                                      'Available': true,
                                      "CarSellerId":
                                          firebaseAuth.currentUser!.uid,
                                      "CarName": widget.carName,
                                      "CarBrand": widget.company,
                                      "CarColor": widget.color,
                                      "CarSeat": widget.seat,
                                      "CarPrice": widget.price,
                                      "CarType": widget.type,
                                      "CarFuelType": widget.fuelType,
                                      "CarTransmission": widget.transmission,
                                      "CarRentType": widget.driver == ''
                                          ? 'Without Driver'
                                          : widget.driver,
                                      "CarDriverName": widget.driver,
                                      "CarDriverNumber": widget.driver,
                                      "CarRating": "0",
                                      'isFavourite': [
                                        firebaseAuth.currentUser!.uid
                                      ]
                                    },
                                  );
                                }
                              },
                              icon: Icon(
                                controller.favouriteList
                                        .contains(firebaseAuth.currentUser!.uid)
                                    ? Icons.favorite
                                    : Icons.favorite_outline_sharp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              preferredSize: Size(width, 70),
            ),
            extendBody: true,
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  BackDrop(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 300,
                          width: width,
                          child: PageView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: widget.carImage!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                                child: GestureDetector(
                                  onTap: () {
                                    Get.to(
                                      () => ImageView(
                                          imageList: widget.carImage!,
                                          index: index),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Hero(
                                      tag: widget.carImage!,
                                      child: ImageLoading(
                                        url: '${widget.carImage![index]}',
                                        height: 160,
                                        width: width,
                                        // width: 110,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Info(title: 'Brand', ans: widget.company),
                              SizedBox(height: 10),
                              Info(title: 'Name', ans: widget.carName),
                              SizedBox(height: 10),
                              Info(title: 'Color', ans: widget.color),
                              SizedBox(height: 10),
                              Info(title: 'Fuel Type', ans: widget.fuelType),
                              SizedBox(height: 10),
                              Info(title: 'Rent Type', ans: widget.rentType),
                              SizedBox(height: 10),
                              Info(title: 'Seat', ans: widget.seat),
                              SizedBox(height: 10),
                              Info(
                                  title: 'Transmission',
                                  ans: widget.transmission),
                              SizedBox(height: 10),
                              Info(title: 'Type', ans: widget.type),
                              SizedBox(height: 10),
                              Info(
                                  title: 'Driver',
                                  ans: widget.driver == ''
                                      ? 'Without Driver'
                                      : widget.driver),
                              SizedBox(height: 10),
                              Info(
                                  title: 'Price',
                                  ans: '${widget.price} / PerDay'),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white54,
                              padding: EdgeInsets.symmetric(vertical: 10),
                            ),
                            onPressed: () async {
                              String roomId = await chatRoomId(
                                  firebaseAuth.currentUser!.uid,
                                  widget.sellerId!);

                              var querySnapshot = await FirebaseFirestore
                                  .instance
                                  .collection('chatroom')
                                  .doc(roomId)
                                  .get();

                              if (querySnapshot.exists == true) {
                                log('EXIST');
                              } else {
                                FirebaseFirestore.instance
                                    .collection('chatroom')
                                    .doc(roomId)
                                    .set({'isChat': false});
                              }
                              log('FCM TOKEN ${userdataController.fcm}');
                              Get.to(
                                () => ChatRoom(
                                  roomId: roomId,
                                  sellerName: widget.sellerName,
                                  sellerId: widget.sellerId,
                                  fcm: userdataController.fcm,
                                ),
                              );
                            },
                            child: Icon(
                              Icons.chat_bubble,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.white54,
                              padding: EdgeInsets.symmetric(vertical: 10),
                            ),
                            onPressed: () {},
                            child: Icon(
                              Icons.call_sharp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget Info({String? title, String? ans}) {
    return Row(
      children: [
        CommonText(
          text: '$title : ',
          color: Colors.grey.shade400,
          weight: FontWeight.w600,
          size: 18,
        ),
        CommonText(
          text: ' ${ans}',
          color: Colors.white,
          size: 20,
          weight: FontWeight.w600,
        ),
      ],
    );
  }
}

class ImageView extends StatefulWidget {
  final List imageList;
  final index;
  const ImageView({Key? key, required this.imageList, this.index})
      : super(key: key);

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios_sharp, color: Colors.white),
        ),
      ),
      body: PageView.builder(
        itemCount: widget.imageList.length,
        itemBuilder: (context, index) {
          return Hero(
            tag: widget.imageList,
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    widget.imageList[index],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
