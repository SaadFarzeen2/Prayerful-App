// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i77/AppModule/AddFriends/Controller/add_friend_controller.dart';

import 'package:i77/Utils/Paddings/AppPaddings.dart';

import '../../../Utils/Fonts/AppDimensions.dart';
import '../../../Utils/Fonts/AppFonts.dart';
import '../../../Utils/Paddings/AppBorderRadius.dart';
import '../../../Utils/Themes/AppColors.dart';
import '../../../Utils/Widgets/AppBarWidget.dart';
import '../../../Utils/Widgets/AppButton.dart';
import '../../../Utils/Widgets/AppText.dart';
import '../../BottomNavigation/View/BottomNavigation.dart';
import '../../PrayerRequests/View/MyPrayer.dart';

class PrayTogetherScreen extends StatelessWidget {
  String? id;
  String? image;
  String? prayer;
  PrayTogetherScreen({
    Key? key,
    this.id,
    this.image,
    this.prayer,
  }) : super(key: key);
  final addFriendsController = Get.put(AddFriendsController());
  bool _willpop = true;
  @override
  Widget build(BuildContext context) {
    print('postid $id');
    return WillPopScope(
      onWillPop: () async {
        await FirebaseFirestore.instance
            .collection('Prayer_types')
            .where("prayername", isEqualTo: prayer)
            .where("prayerimage", isEqualTo: image)
            .where("Usernamelist",
                isEqualTo: userDetailController.username.value)
            .where("UserImagelist",
                isEqualTo: userDetailController.profileimage.value)
            .snapshots()
            .first
            .then((value) {
          value.docs.first.reference.delete();
        });
        return _willpop;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: AppPaddings.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PrimaryAppBar(
                  titleText: 'Pray Together',
                  isSuffix: true,
                  isPrefix: false,
                  prefixIconImage: 'assets/images/Back.png',
                  prefixButtonColor: AppColors.WHITE_COLOR,
                  prefixPadding: 10,
                  titleSize: AppDimensions.FONT_SIZE_20,
                ),
                SizedBox(
                  height: Get.height * 0.02,
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Prayers')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: Text("Loading"));
                      }
                      return Container(
                          height: Get.height * 0.7,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 30.0, left: 10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: AppColors.WHITE_COLOR,
                                            borderRadius: AppBorderRadius
                                                .BORDER_RADIUS_10,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: AppColors.GREY_COLOR
                                                      .withOpacity(.1),
                                                  spreadRadius: 10,
                                                  blurRadius: 10)
                                            ]),
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              cursorColor:
                                                  AppColors.PRIMARY_COLOR,
                                              maxLines: 10,
                                              readOnly: false,
                                              decoration: InputDecoration(
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 10, top: 50),
                                                focusedBorder: InputBorder.none,
                                                enabledBorder: InputBorder.none,
                                                errorBorder: InputBorder.none,
                                                disabledBorder:
                                                    InputBorder.none,
                                                hintText: prayer,
                                                hintStyle: TextStyle(
                                                    color:
                                                        AppColors.BLACK_COLOR,
                                                    fontSize: AppDimensions
                                                        .FONT_SIZE_18,
                                                    fontFamily: Weights.light),
                                                focusColor:
                                                    AppColors.PRIMARY_COLOR,
                                                filled: false,
                                                fillColor:
                                                    AppColors.TRANSPARENT_COLOR,
                                                // focusedBorder: OutlineInputBorder(
                                                //   borderRadius: BorderRadius.circular(10),
                                                //   borderSide: BorderSide(
                                                //     color: AppColors.TRANSPARENT_COLOR,
                                                //   ),
                                                // ),
                                                border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: AppColors
                                                        .TRANSPARENT_COLOR,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  StreamBuilder(
                                                      stream: FirebaseFirestore
                                                          .instance
                                                          .collection('Prayers')
                                                          .doc(id)
                                                          .collection('Prayed')
                                                          .orderBy('timestamp',
                                                              descending: true)
                                                          .snapshots(),
                                                      builder: (context,
                                                          AsyncSnapshot<
                                                                  QuerySnapshot>
                                                              snap) {
                                                        if (snap.hasError) {
                                                          return Text(
                                                              'Something went wrong');
                                                        }
                                                        if (snap.connectionState ==
                                                            ConnectionState
                                                                .waiting) {
                                                          return Center(
                                                              child: Text(
                                                                  "Loading"));
                                                        }
                                                        return Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            for (int i = 0;
                                                                i <
                                                                    snap
                                                                        .data!
                                                                        .docs
                                                                        .length;
                                                                i++) ...{
                                                              // Align(
                                                              //   widthFactor: 0.6,
                                                              //   child: snap.data!.docs[
                                                              //                   i][
                                                              //               'profile_image'] !=
                                                              //           ''
                                                              //       ? CircleAvatar(
                                                              //           backgroundColor:
                                                              //               AppColors
                                                              //                   .TRANSPARENT_COLOR,
                                                              //           radius: 18,
                                                              //           backgroundImage:
                                                              //               NetworkImage(snap.data!.docs[i]['profile_image'] ??
                                                              //                   ''),
                                                              //         )
                                                              //       : null,
                                                              // ),
                                                            },
                                                            SizedBox(
                                                              width: Get.width *
                                                                  0.03,
                                                            ),
                                                            addPrayerController
                                                                        .peoplePrayed
                                                                        .length !=
                                                                    0
                                                                ? AppText(
                                                                    text:
                                                                        '${snap.data!.docs.length} Prayed',
                                                                    color: AppColors
                                                                        .BLACK_COLOR,
                                                                    fontFamily:
                                                                        Weights
                                                                            .bold,
                                                                    size: AppDimensions
                                                                        .FONT_SIZE_14)
                                                                : AppText(
                                                                    text: ' ',
                                                                    color: AppColors
                                                                        .BLACK_COLOR,
                                                                    fontFamily:
                                                                        Weights
                                                                            .bold,
                                                                    size: AppDimensions
                                                                        .FONT_SIZE_14),
                                                          ],
                                                        );
                                                      }),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        child: CircleAvatar(
                                      radius: 35,
                                      backgroundColor: AppColors.PRIMARY_COLOR,
                                      backgroundImage: NetworkImage(image!),
                                    )),
                                  ],
                                ),
                                SizedBox(
                                  height: Get.height * 0.02,
                                ),
                                // AppText(
                                //     text: 'Waiting for others to join..',
                                //     size: AppDimensions.FONT_SIZE_18,
                                //     fontFamily: Weights.medium),
                                // SizedBox(
                                //   height: Get.height * 0.06,
                                // ),
                                StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('Prayer_types')
                                        .where("prayername", isEqualTo: prayer)
                                        .where("prayerimage", isEqualTo: image)
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasError) {
                                        return Text('Something went wrong');
                                      }
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(child: Text("Loading.."));
                                      }
                                      // setState(() {
                                      //   totalpraying = snapshot.data!.docs.length;
                                      // });
                                      return Column(
                                        children: [
                                          snapshot.data!.docs.length == 1
                                              ? Text(
                                                  "You Praying only, waiting for others to join")
                                              : Text(
                                                  "${snapshot.data!.docs.length}" +
                                                      " Praying"),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              for (int i = 0;
                                                  i <
                                                      snapshot
                                                          .data!.docs.length;
                                                  i++)
                                                Align(
                                                  widthFactor: 0.7,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 15),
                                                    child: Column(
                                                      children: [
                                                        CircleAvatar(
                                                          radius: 18,
                                                          backgroundImage:
                                                              NetworkImage(snapshot
                                                                      .data!
                                                                      .docs[i][
                                                                  'UserImagelist']),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      );
                                    }),
                                SizedBox(
                                  height: Get.height * 0.02,
                                ),
                                StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('Prayers')
                                        .doc(id)
                                        .collection('Prayed')
                                        .orderBy('timestamp', descending: true)
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> snap) {
                                      if (snap.hasError) {
                                        return Text('Something went wrong');
                                      }
                                      if (snap.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(child: Text("Loading"));
                                      }
                                      return Column(
                                        children: [
                                          snap.data!.docs.length == 0
                                              ? SizedBox()
                                              : Text(
                                                  "${snap.data!.docs.length}" +
                                                      " Prayed"),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              for (int i = 0;
                                                  i < snap.data!.docs.length;
                                                  i++) ...{
                                                Align(
                                                  widthFactor: 0.7,
                                                  child: snap.data!.docs[i][
                                                                  'profile_image'] !=
                                                              '' &&
                                                          addFriendsController
                                                                  .convertToAgo(snap
                                                                          .data!
                                                                          .docs[i]
                                                                      [
                                                                      'timestamp']) <=
                                                              30
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      15),
                                                          child: Column(
                                                            children: [
                                                              CircleAvatar(
                                                                backgroundColor:
                                                                    AppColors
                                                                        .TRANSPARENT_COLOR,
                                                                radius: 18,
                                                                backgroundImage:
                                                                    NetworkImage(
                                                                        snap.data!.docs[i]['profile_image'] ??
                                                                            ''),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      : CircleAvatar(
                                                          backgroundColor: AppColors
                                                              .TRANSPARENT_COLOR,
                                                          radius: 18,
                                                          backgroundImage:
                                                              NetworkImage(''),
                                                        ),
                                                ),
                                              },
                                            ],
                                          ),
                                        ],
                                      );
                                    }),
                              ],
                            ),
                          ));
                    }),
                AppButton(
                    buttonWidth: Get.width,
                    buttonRadius: AppBorderRadius.BORDER_RADIUS_10,
                    buttonName: 'End Session',
                    textSize: AppDimensions.FONT_SIZE_17,
                    buttonColor: AppColors.PRIMARY_COLOR,
                    textColor: AppColors.WHITE_COLOR,
                    onTap: () async {
                      log(userDetailController.username.value.toString());
                      log(userDetailController.profileimage.value.toString());
                      log(image.toString());
                      log(prayer.toString());
                      log("/////////////////////////////");
                      FirebaseFirestore.instance
                          .collection('Prayer_types')
                          .where("prayername", isEqualTo: prayer)
                          .where("prayerimage", isEqualTo: image)
                          .where("Usernamelist",
                              isEqualTo: userDetailController.username.value)
                          .where("UserImagelist",
                              isEqualTo:
                                  userDetailController.profileimage.value)
                          .snapshots()
                          .first
                          .then((value) {
                        value.docs.first.reference.delete();
                      });

                      // final QuerySnapshot result = await FirebaseFirestore
                      //     .instance
                      //     .collection('Prayers')
                      //     .orderBy('timestamp', descending: true)
                      //     .get();

                      // for (int i = 0; i < result.docs.length; i++) {
                      //   result.docs[i]['uid'] !=
                      //           userDetailController.userUid.value
                      //       ? ((context) {
                      //           addPrayerController
                      //               .prayedfor(result.docs[i]['uid']);
                      //           addPrayerController
                      //               .prayedOnPrayers(result.docs[i]['id']);
                      //         })
                      //       : ((context) {
                      //           addPrayerController
                      //               .prayedOnPrayers(result.docs[i]['id']);
                      //         });
                      // }
                      if (image == userDetailController.profileimage.value) {
                        log("Its hereeee");
                        FirebaseFirestore.instance
                            .collection('prayer_status')
                            .add({
                          "prayerid": id,
                          "prayername": prayer,
                          "prayerimage": image,
                          "prayerstatus": "prayed"
                        });
                      }

                      // FirebaseFirestore.instance
                      //     .collection("Prayer_types")
                      //     .doc("Prayerwithid")
                      //     .collection("prayersid")
                      //     .doc(id)
                      //     .delete();
                      Get.offAll(BottomNavigation());
                    }),
                SizedBox(
                  height: Get.height * 0.05,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
