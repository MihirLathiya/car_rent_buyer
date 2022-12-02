import 'dart:developer';
import 'dart:ui';

import 'package:car_buyer/Common/chat_room.dart';
import 'package:car_buyer/Common/color.dart';
import 'package:car_buyer/Common/common_text.dart';
import 'package:car_buyer/Controller/email_controller.dart';
import 'package:car_buyer/View/chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    // getIds();
    super.initState();
  }

  List chatsId = [];

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
        appBar: PreferredSize(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: width,
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CommonText(
                            text: 'Chat',
                            size: 20,
                            color: AppColors.white,
                            weight: FontWeight.w700,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
          preferredSize: Size(width, 50),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 10),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('chatroom')
                      .snapshots(),
                  builder: (context, snapshot1) {
                    if (snapshot1.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot1.data!.docs.length,
                        itemBuilder: (context, index1) {
                          return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('seller')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                log('DATA:-${snapshot1.data!.docs[index1].id}');

                                if (snapshot1.data!.docs[index1].id
                                    .contains(firebaseAuth.currentUser!.uid)) {
                                  chatsId.add(snapshot1.data!.docs[index1].id);
                                }
                                chatsId.toSet().toList();
                                log('IDS:-$chatsId');

                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    if (firebaseAuth.currentUser!.uid +
                                                snapshot.data!.docs[index].id ==
                                            chatsId[index1] ||
                                        snapshot.data!.docs[index].id +
                                                firebaseAuth.currentUser!.uid ==
                                            chatsId[index1]) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 13),
                                        child: GestureDetector(
                                          onTap: () async {
                                            String roomId = await chatRoomId(
                                                firebaseAuth.currentUser!.uid,
                                                snapshot.data!.docs[index].id);

                                            Get.to(
                                              () => ChatRoom(
                                                  roomId: roomId,
                                                  sellerName: snapshot.data!
                                                      .docs[index]['name'],
                                                  sellerId: snapshot
                                                      .data!.docs[index].id,
                                                  image: snapshot.data!
                                                      .docs[index]['image']),
                                            );
                                          },
                                          child: Container(
                                            height: 100,
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: Colors.white12,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white12,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                      '${snapshot.data!.docs[index]['image']}'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                color: Colors.black38,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    CommonText(
                                                      text:
                                                          '${snapshot.data!.docs[index]['name']}',
                                                      color: Colors.white,
                                                      weight: FontWeight.w600,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    StreamBuilder(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              "chatroom")
                                                          .doc(chatsId[index1])
                                                          .collection('chat')
                                                          .snapshots(),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot<
                                                                      Map<String,
                                                                          dynamic>>>
                                                              snapshot2) {
                                                        if (snapshot2.hasData) {
                                                          Timestamp time1 =
                                                              snapshot2
                                                                  .data!
                                                                  .docs
                                                                  .last['time'];
                                                          DateTime myDateTime =
                                                              time1
                                                                  .toDate(); // Time

                                                          var time2 =
                                                              DateTime.now();
                                                          var time3 = time2
                                                                      .difference(
                                                                          myDateTime)
                                                                      .inSeconds >
                                                                  60
                                                              ? time2
                                                                          .difference(
                                                                              myDateTime)
                                                                          .inMinutes >
                                                                      60
                                                                  ? time2.difference(myDateTime).inHours >
                                                                          24
                                                                      ? '${time2.difference(myDateTime).inDays}d'
                                                                      : '${time2.difference(myDateTime).inHours}h'
                                                                  : '${time2.difference(myDateTime).inMinutes}m'
                                                              : '${time2.difference(myDateTime).inSeconds}s';

                                                          return Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              SizedBox(
                                                                height: 20,
                                                                width: 200,
                                                                child: ListView
                                                                    .builder(
                                                                  shrinkWrap:
                                                                      true,
                                                                  reverse: true,
                                                                  itemCount: 1,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index3) {
                                                                    return CommonText(
                                                                      text: snapshot2.data!.docs[index3]['sendBy'] ==
                                                                              firebaseAuth.currentUser!.uid
                                                                          ? 'You : ${snapshot2.data!.docs[index3]['message']}'
                                                                          : '${snapshot.data!.docs[index]['name']} : ${snapshot2.data!.docs[index3]['message']}', // '${snapshot2.data!.docs.last['message']}',
                                                                      color: Colors
                                                                          .white,
                                                                      size: 13,
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                              Column(
                                                                children: [
                                                                  CommonText(
                                                                    text:
                                                                        '${time3} ago',
                                                                    color: Colors
                                                                        .white,
                                                                    size: 13,
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          );
                                                        }
                                                        return SizedBox();
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return SizedBox();
                                  },
                                );
                              } else {
                                return CircularProgressIndicator();
                              }
                            },
                          );
                        },
                      );
                    } else {
                      return SizedBox();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
