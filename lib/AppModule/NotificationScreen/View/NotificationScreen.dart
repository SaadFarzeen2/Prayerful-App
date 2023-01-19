import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i77/AppModule/PrayTogether/View/PrayTogether.dart';
import 'package:i77/AppModule/SeeAllPrayers/View/SeeAllPrayers.dart';
import 'package:i77/Utils/Fonts/AppDimensions.dart';
import 'package:i77/Utils/Fonts/AppFonts.dart';
import 'package:i77/Utils/Paddings/AppBorderRadius.dart';
import 'package:i77/Utils/Paddings/AppPaddings.dart';
import 'package:i77/Utils/Themes/AppColors.dart';
import 'package:i77/Utils/Widgets/AppBarWidget.dart';
import 'package:i77/Utils/Widgets/AppText.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 16, right: 16, left: 16, bottom: 5),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PrimaryAppBar(
                titleText: 'Notifications',
                prefixButtonColor: AppColors.WHITE_COLOR,
                prefixPadding: 10,
                prefixIconImage: 'assets/images/Back.png',
                titleSize: AppDimensions.FONT_SIZE_20,
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Notification')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Text("Loading"));
                    }
                    if (!snapshot.hasData) {
                      return Container(
                        height: Get.height * 0.6,
                        width: Get.width,
                        child: Center(
                          child: Image.asset(
                            'assets/images/noNotification.png',
                            scale: 10,
                          ),
                        ),
                      );
                    }
                    return Container(
                      height: Get.height * 0.8,
                      child: Column(
                        children: [
                          // Row(
                          //   children: [
                          //     AppText(
                          //         text: 'Today',
                          //         size: AppDimensions.FONT_SIZE_20,
                          //         fontFamily: Weights.medium),
                          //     // const Spacer(),
                          //   ],
                          // ),
                          Container(
                            height: Get.height * 0.77,
                            child: ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return snapshot.data!.docs[index]
                                                  ['sender_uid'] !=
                                              userDetailController
                                                  .userUid.value &&
                                          snapshot
                                              .data!
                                              .docs[index]
                                                  ['sender_mobile_token']
                                              .isNotEmpty &&
                                          snapshot
                                              .data!
                                              .docs[index]
                                                  ['reciever_mobile_token']
                                              .isNotEmpty &&
                                          snapshot.data!.docs[index]
                                                  ['reciever_id'] ==
                                              userDetailController.userUid.value
                                      ? Container(
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 7.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      color:
                                                          AppColors.WHITE_COLOR,
                                                      borderRadius:
                                                          AppBorderRadius
                                                              .BORDER_RADIUS_10,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: AppColors
                                                              .GREY_COLOR
                                                              .withOpacity(.1),
                                                          spreadRadius: 10,
                                                          blurRadius: 10,
                                                        ),
                                                      ]),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child: Row(
                                                      children: [
                                                        CircleAvatar(
                                                          backgroundColor:
                                                              AppColors
                                                                  .WHITE_COLOR,
                                                          backgroundImage:
                                                              NetworkImage(snapshot
                                                                          .data!
                                                                          .docs[
                                                                      index][
                                                                  'sender_image']),
                                                          radius: 30,
                                                        ),
                                                        SizedBox(
                                                          width:
                                                              Get.width * 0.03,
                                                        ),
                                                        if (snapshot.data!
                                                                    .docs[index]
                                                                [
                                                                'notification_type'] ==
                                                            'prayed') ...{
                                                          Flexible(
                                                            child: AppText(
                                                                text:
                                                                    '${snapshot.data!.docs[index]['sender_name']} Prayed For You!',
                                                                size: AppDimensions
                                                                    .FONT_SIZE_16),
                                                          )
                                                        } else if (snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                [
                                                                'notification_type'] ==
                                                            'As Friend') ...{
                                                          Flexible(
                                                            child: InkWell(
                                                              onTap: () async {
                                                                final QuerySnapshot result = await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'Prayer_types')
                                                                    .where(
                                                                        "prayername",
                                                                        isEqualTo: snapshot.data!.docs[index][
                                                                            'prayer_name'])
                                                                    .where(
                                                                        "prayerimage",
                                                                        isEqualTo: snapshot.data!.docs[index][
                                                                            'sender_image'])
                                                                    .where(
                                                                        "Usernamelist",
                                                                        isEqualTo: userDetailController
                                                                            .username
                                                                            .value)
                                                                    .get();

                                                                if (result
                                                                        .size <=
                                                                    0) {
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'Prayer_types')
                                                                      .add({
                                                                    "prayerid": snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                        [
                                                                        'prayer_id'],
                                                                    "prayername":
                                                                        snapshot
                                                                            .data!
                                                                            .docs[index]['prayer_name'],
                                                                    "prayerimage":
                                                                        snapshot
                                                                            .data!
                                                                            .docs[index]['sender_image'],
                                                                    "Usernamelist":
                                                                        userDetailController
                                                                            .username
                                                                            .value,
                                                                    "UserImagelist":
                                                                        userDetailController
                                                                            .profileimage
                                                                            .value,
                                                                    "Usertokenlist":
                                                                        userDetailController
                                                                            .token
                                                                            .value,
                                                                  }).then((value) =>
                                                                          {});
                                                                }

                                                                Get.to(
                                                                    PrayTogetherScreen(
                                                                  id: snapshot
                                                                          .data!
                                                                          .docs[index]
                                                                      [
                                                                      'prayer_id'],
                                                                  image: snapshot
                                                                          .data!
                                                                          .docs[index]
                                                                      [
                                                                      'sender_image'],
                                                                  prayer: snapshot
                                                                          .data!
                                                                          .docs[index]
                                                                      [
                                                                      'prayer_name'],
                                                                ));
                                                              },
                                                              child: AppText(
                                                                  text: '${snapshot.data!.docs[index]['sender_name']} Added you in prayer "' +
                                                                      '${snapshot.data!.docs[index]['prayer_name']}"',
                                                                  size: AppDimensions
                                                                      .FONT_SIZE_16),
                                                            ),
                                                          )
                                                        }
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : SizedBox.shrink();
                                }),
                          ),

                          // Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: 16.0),
                          //   child: Row(
                          //     children: [
                          //       AppText(
                          //           text: 'Older',
                          //           size: AppDimensions.FONT_SIZE_20,
                          //           fontFamily: Weights.medium),
                          //       const Spacer(),
                          //     ],
                          //   ),
                          // ),
                          // Container(
                          //     child: ListView.builder(
                          //         shrinkWrap: true,
                          //         padding: EdgeInsets.zero,
                          //         itemCount: snapshot.data!.docs.length,
                          //         itemBuilder:
                          //             (BuildContext context, int index) {
                          //           return snapshot.data!.docs[index]
                          //                           ['sender_uid'] !=
                          //                       userDetailController
                          //                           .userUid.value ||
                          //                   snapshot.data!.docs[index]
                          //                           ['sender_mobile_token'] !=
                          //                       ''
                          //               ? Column(
                          //                   children: [
                          //                     Padding(
                          //                       padding: const EdgeInsets.only(
                          //                           bottom: 7.0),
                          //                       child: Container(
                          //                         decoration: BoxDecoration(
                          //                             color:
                          //                                 AppColors.WHITE_COLOR,
                          //                             borderRadius:
                          //                                 AppBorderRadius
                          //                                     .BORDER_RADIUS_10,
                          //                             boxShadow: [
                          //                               BoxShadow(
                          //                                 color: AppColors
                          //                                     .GREY_COLOR
                          //                                     .withOpacity(.1),
                          //                                 spreadRadius: 10,
                          //                                 blurRadius: 10,
                          //                               ),
                          //                             ]),
                          //                         child: Padding(
                          //                           padding:
                          //                               const EdgeInsets.all(
                          //                                   12.0),
                          //                           child: Row(
                          //                             children: [
                          //                               CircleAvatar(
                          //                                 backgroundColor:
                          //                                     AppColors
                          //                                         .WHITE_COLOR,
                          //                                 backgroundImage:
                          //                                     NetworkImage(snapshot
                          //                                                 .data!
                          //                                                 .docs[
                          //                                             index][
                          //                                         'sender_image']),
                          //                                 radius: 30,
                          //                               ),
                          //                               SizedBox(
                          //                                 width:
                          //                                     Get.width * 0.03,
                          //                               ),
                          //                               if (snapshot.data!
                          //                                           .docs[index]
                          //                                       [
                          //                                       'notification_type'] ==
                          //                                   'prayed') ...{
                          //                                 Flexible(
                          //                                   child: AppText(
                          //                                       text:
                          //                                           '${snapshot.data!.docs[index]['sender_name']} Prayed You!',
                          //                                       size: AppDimensions
                          //                                           .FONT_SIZE_16),
                          //                                 )
                          //                               } else if (snapshot
                          //                                           .data!
                          //                                           .docs[index]
                          //                                       [
                          //                                       'notification_type'] ==
                          //                                   'As Friend') ...{
                          //                                 Flexible(
                          //                                   child: AppText(
                          //                                       text:
                          //                                           '${snapshot.data!.docs[index]['sender_name']} Added you in prayer!',
                          //                                       size: AppDimensions
                          //                                           .FONT_SIZE_16),
                          //                                 )
                          //                               }
                          //                             ],
                          //                           ),
                          //                         ),
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 )
                          //               : SizedBox.shrink();
                          //         })),
                        ],
                      ),
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
