import 'dart:developer';
import 'dart:ui';

import 'package:car_buyer/Common/chat_room.dart';
import 'package:car_buyer/Common/color.dart';
import 'package:car_buyer/Common/common_text.dart';
import 'package:car_buyer/Controller/email_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatRoom extends StatefulWidget {
  final sellerId, sellerName, roomId, image;
  const ChatRoom(
      {Key? key, this.sellerId, this.sellerName, this.roomId, this.image})
      : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    log('SELLER ID :- ${widget.sellerId}');
    log('SELLER ID :- ${widget.roomId}');
    log('SELLER ID :- ${widget.sellerName}');
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
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 4,
          sigmaY: 4,
        ),
        child: Container(
          decoration: BoxDecoration(
              // color: Colors.white12,/
              ),
          child: Scaffold(
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
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SafeArea(
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_sharp,
                                color: Colors.white,
                              ),
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.white38,
                              backgroundImage: NetworkImage(widget.image),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            CommonText(
                              text: '${widget.sellerName}',
                              size: 16,
                              color: AppColors.white,
                              weight: FontWeight.w700,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('seller')
                                  .doc('${widget.sellerId}')
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<
                                          DocumentSnapshot<
                                              Map<String, dynamic>>>
                                      snapshot) {
                                if (snapshot.hasData) {
                                  log('MESSAGE ${snapshot.data!['status']}');
                                  return snapshot.data!['status'] == 'Online'
                                      ? Icon(
                                          Icons.sunny,
                                          color: Colors.green,
                                        )
                                      : Icon(
                                          Icons.nightlight_outlined,
                                          color: Colors.red,
                                        );
                                } else {
                                  return SizedBox();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
              preferredSize: Size(width, 70),
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('chatroom')
                        .doc(widget.roomId)
                        .collection('chat')
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          reverse: true,
                          itemBuilder: (context, index) {
                            var message = snapshot.data!.docs[index];
                            var myDateTime;
                            var myDateTime2;
                            var time1;
                            var time2;

                            try {
                              time1 = snapshot.data!.docs[index]['time'];
                              try {
                                time2 = snapshot.data!.docs[index + 1]['time'];
                              } catch (e) {}
                              myDateTime = time1
                                  .toDate()
                                  .toString()
                                  .split(' ')
                                  .first
                                  .toString();
                              try {
                                myDateTime2 = time2
                                    .toDate()
                                    .toString()
                                    .split(' ')
                                    .first
                                    .toString();
                              } catch (e) {}
                            } catch (e) {
                              log('DATE ERROR');
                            }

                            Widget seprate = SizedBox();

                            try {
                              if (index != 0 && myDateTime != myDateTime2) {
                                var day = myDateTime.toString().split('-').last;
                                var month = myDateTime.toString().split('-')[1];
                                var year =
                                    myDateTime.toString().split('-').first;
                                var cDate =
                                    DateTime.now().toString().split(' ').first;
                                var cDay = cDate.toString().split('-').last;
                                var cMonth = cDate.toString().split('-')[1];
                                var cYear = cDate.toString().split('-').first;
                                var currentDate = '$cDay $cMonth $cYear';
                                var notCurrentDate = '$day $month $year';

                                var extractMonth = month == 1
                                    ? 'January'
                                    : month == 2
                                        ? 'February'
                                        : month == 3
                                            ? 'March'
                                            : month == 4
                                                ? 'April'
                                                : month == 5
                                                    ? 'May'
                                                    : month == 6
                                                        ? 'June'
                                                        : month == 7
                                                            ? 'July'
                                                            : month == 8
                                                                ? 'August'
                                                                : month == 9
                                                                    ? 'September'
                                                                    : month ==
                                                                            10
                                                                        ? 'October'
                                                                        : month ==
                                                                                11
                                                                            ? 'November'
                                                                            : 'December';

                                seprate = Text(
                                  currentDate == notCurrentDate
                                      ? 'Today'
                                      : '$day $extractMonth $year',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                );
                              }
                            } catch (e) {
                              seprate = SizedBox();
                              log('TIME ERROR');
                            }

                            return Column(
                              children: [
                                seprate,
                                ContainerDecoration(
                                  message: message,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          message['message'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            );
                          },
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
                sendMessage(Get.width, Get.height),
              ],
            ),
          ),
        ),
      ),
    );
  }

  sendMessage(double width, double height) {
    return Padding(
      padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              style: TextStyle(fontSize: 18, color: Colors.white),
              onChanged: (value) {},
              controller: message,
              decoration: InputDecoration(
                fillColor: Colors.white12,
                filled: true,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(1200),
                    borderSide: BorderSide(color: Colors.white38)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(1200),
                    borderSide: BorderSide(color: Colors.white38)),
                hintText: "Type Something...",
                hintStyle: TextStyle(fontSize: 18, color: Colors.white),
                border: UnderlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              onSendMessage();
            },
            child: Container(
              margin: EdgeInsets.only(left: 6, right: 12),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
              child: Icon(
                Icons.send,
                color: Colors.white,
                size: 25,
              ),
            ),
          )
        ],
      ),
    );
  }

  void onSendMessage() async {
    if (message.text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('chatroom')
          .doc(widget.roomId)
          .collection('chat')
          .add(
        {
          'sendBy': firebaseAuth.currentUser!.uid,
          "message": message.text,
          "time": DateTime.now(),
          'isDelete': false,
          'isCheck': false,
        },
      );
    } else {
      print('Enter Something');
    }

    message.clear();
  }
}
