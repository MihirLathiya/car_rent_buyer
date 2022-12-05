import 'package:car_buyer/Common/color.dart';
import 'package:car_buyer/Common/common_text.dart';
import 'package:car_buyer/Common/common_textfield.dart';
import 'package:car_buyer/Controller/email_controller.dart';
import 'package:car_buyer/Controller/search_controller.dart';
import 'package:car_buyer/View/detail_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  TextEditingController search = TextEditingController();
  SearchController _searchController = Get.put(SearchController());
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
      child: GetBuilder<SearchController>(
        builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: PreferredSize(
              child: Container(
                margin: EdgeInsets.only(bottom: 5, right: 10, left: 10),
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
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CommonText(
                                text: 'Favourite',
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
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: CommonTextField(
                          onChanged: (val) {
                            controller.onChanged(val);
                          },
                          prefixIcon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/images/Search.svg',
                                height: 20,
                                width: 20,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          controller: search,
                          fillColor: AppColors.white,
                          validator: (val) {},
                          obScureText: false,
                          textInputAction: TextInputAction.search,
                          hintText: 'Search Cars',
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ),
              preferredSize: Size(width, 120),
            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('favourite')
                          .doc(firebaseAuth.currentUser!.uid)
                          .collection('fav')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          List<DocumentSnapshot> carData = snapshot.data!.docs;
                          print("length======>${carData.length}");
                          if (controller.searchCars.isNotEmpty) {
                            carData = carData.where((element) {
                              return element
                                  .get('CarBrand')
                                  .toString()
                                  .toLowerCase()
                                  .contains(
                                      controller.searchCars.toLowerCase());
                            }).toList();
                          }

                          return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: carData.length,
                            itemBuilder: (BuildContext context, int index) {
                              List x = carData[index]['CarImage'];
                              List favourite =
                                  snapshot.data!.docs[index]['isFavourite'];

                              return GestureDetector(
                                onTap: () {
                                  Get.to(
                                    () => DetailScreen(
                                      favouriteList: favourite,
                                      id: carData[index].id,
                                      company: carData[index]['CarBrand'],
                                      carName: carData[index]['CarName'],
                                      carImage: x,
                                      color: carData[index]['CarColor'],
                                      driver: carData[index]['CarDriverName'],
                                      fuelType: carData[index]['CarFuelType'],
                                      rentType: carData[index]['CarRentType'],
                                      seat: carData[index]['CarSeat'],
                                      transmission: carData[index]
                                          ['CarTransmission'],
                                      type: carData[index]['CarType'],
                                      price: carData[index]['CarPrice'],
                                      sellerId: carData[index]['CarSellerId'],
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 224,
                                  width: width,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  margin: EdgeInsets.only(
                                      left: 5, right: 5, bottom: 10, top: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white12,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: Offset(0, 0),
                                        blurRadius: 5,
                                        color: AppColors.grey.withAlpha(50),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        height: 160,
                                        width: width,
                                        child: PageView.builder(
                                          physics: BouncingScrollPhysics(),
                                          itemCount: x.length,
                                          itemBuilder: (context, index1) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 10, top: 10),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: ImageLoading(
                                                  url:
                                                      '${carData[index]['CarImage'][index1]}',
                                                  height: 160,
                                                  width: width,
                                                  // width: 110,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10, bottom: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                CommonText(
                                                  text:
                                                      "${carData[index]['CarName']}",
                                                  size: 16,
                                                  weight: FontWeight.w600,
                                                  color: Colors.white70,
                                                ),
                                                Spacer(),
                                                CommonText(
                                                  text:
                                                      '\$${carData[index]['CarPrice']}',
                                                  size: 16,
                                                  weight: FontWeight.w700,
                                                  color: Colors.white70,
                                                ),
                                                CommonText(
                                                  text: '/Per Day',
                                                  size: 14,
                                                  color: Colors.white70,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 2),
                                            Row(
                                              children: [
                                                CommonText(
                                                  text: 'Type :',
                                                  size: 12,
                                                  weight: FontWeight.w500,
                                                  color: Colors.white70,
                                                ),
                                                SizedBox(width: 5),
                                                CommonText(
                                                  text:
                                                      "${carData[index]['CarType']}",
                                                  size: 12,
                                                  weight: FontWeight.w500,
                                                  color: Colors.white70,
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        } else {
                          return loading();
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
