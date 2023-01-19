import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i77/AppModule/AddPrayer/controller/add_prayer_controller.dart';
import 'package:i77/AppModule/OnboardingScreen/Controller/OnboardingController.dart';
import 'package:i77/AppModule/OnboardingScreen/Controller/UserAddressConroller.dart';
import 'package:i77/AppModule/PrayerRequests/View/MyPrayer.dart';
import 'package:i77/Utils/Fonts/AppDimensions.dart';
import 'package:i77/Utils/Fonts/AppFonts.dart';
import 'package:i77/Utils/Paddings/AppBorderRadius.dart';
import 'package:i77/Utils/Paddings/AppPaddings.dart';
import 'package:i77/Utils/Themes/AppColors.dart';
import 'package:i77/Utils/Widgets/AppText.dart';
import '../../BottomNavigation/View/BottomNavigation.dart';
import '../../NotificationScreen/View/NotificationScreen.dart';
import '../../ProfileScreen/View/ProfileScreen.dart';
import '../../SeeAllPrayers/View/SeeAllPrayers.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  final userDetailController = Get.put(OnboardingController());
  final addPrayerController = Get.put(AddPrayerController());

  final userAddressLatLong = Get.put(UserAddressLatLong());

  @override
  void initState() {
    userDetailController.getUserData();
    // addPrayerController.nearBy();
    super.initState();
  }

  var filterData = [];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body:
            //
            // userDetailController.userUid.value == ""
            //     ? Center(
            //         child: CircularProgressIndicator(
            //           color: AppColors.PRIMARY_COLOR,
            //         ),
            //       )
            //     :
            //
            Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: AppColors.PRIMARY_COLOR,
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(15))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Get.height * 0.05,
                  ),
                  Padding(
                    padding: AppPaddings.defaultPadding,
                    child: Row(
                      children: [
                        // Image.asset(
                        //   'assets/images/more.png',
                        //   height: Get.height * 0.02,
                        // ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Get.to(NotificationScreen());
                          },
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('Notification')
                                  .where('reciever_id',
                                      isEqualTo:
                                          userDetailController.userUid.value)

                                  // .orderBy('timestamp', descending: true)
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasError) {
                                  return Text('Something went wrong');
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(child: Text("Loading"));
                                }
                                return Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(1),
                                          child: SizedBox(
                                            height: Get.height * 0.026,
                                            child: Image.asset(
                                              'assets/images/bell.png',
                                              color: AppColors.WHITE_COLOR,
                                              height: Get.height * 0.02,
                                            ),
                                          ),
                                        ),
                                        for (var i = 0;
                                            i < snapshot.data!.docs.length;
                                            i++) ...{
                                          snapshot.data!.docs[i][
                                                      'reciever_mobile_token'] ==
                                                  ''
                                              ? Container()
                                              : Positioned(
                                                  right: 0,
                                                  top: 2,
                                                  child: CircleAvatar(
                                                    radius: 5,
                                                    backgroundColor:
                                                        AppColors.WHITE_COLOR,
                                                  )),
                                        }
                                      ],
                                    ),
                                  ],
                                );
                              }),
                        ),
                        SizedBox(
                          width: Get.width * 0.04,
                        ),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('PrayedFor')
                                .doc(userDetailController.userUid.value)
                                .collection('AllPeople')
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Something went wrong');
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(child: Text("Loading"));
                              }
                              return GestureDetector(
                                onTap: () {
                                  Get.to(ProfileScreen());
                                },
                                child: Stack(
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.all(7),
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(
                                              userDetailController
                                                  .profileimage.value
                                                  .toString()),
                                        )),
                                    snapshot.data!.docs.length >= 100
                                        ? Positioned(
                                            right: 0,
                                            top: 2,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: AppColors.WHITE_COLOR,
                                                  border: Border.all(
                                                      color: AppColors
                                                          .THIRD_PRIMARY_COLOR)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: Image.asset(
                                                  'assets/images/king.png',
                                                  height: Get.height * 0.02,
                                                ),
                                              ),
                                            ))
                                        : SizedBox.shrink(),
                                  ],
                                ),
                              );
                            }),
                      ],
                    ),
                  ),
                  Padding(
                    padding: AppPaddings.horizontal,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                            text: userDetailController.username.value,
                            size: AppDimensions.FONT_SIZE_20,
                            color: AppColors.WHITE_COLOR,
                            fontFamily: Weights.medium),
                        SizedBox(
                          height: Get.height * 0.01,
                        ),
                        AppText(
                            text: greeting(),
                            size: AppDimensions.FONT_SIZE_24,
                            color: AppColors.WHITE_COLOR,
                            fontFamily: Weights.bold),
                        SizedBox(
                          height: Get.height * 0.02,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                  child: Padding(
                padding: AppPaddings.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    AppText(
                        textAlign: TextAlign.center,
                        fontFamily: Weights.bold,
                        text:
                            'But truly God has listened; he has attended to the voice of my prayer. - Ps 66:1-9.'),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: AppColors.PRIMARY_COLOR,
                          size: 18,
                        ),
                        SizedBox(
                          width: Get.width * 0.02,
                        ),
                        Obx(() {
                          return AppText(
                              size: AppDimensions.FONT_SIZE_14,
                              fontFamily: Weights.bold,
                              text: '${userAddressLatLong.country.value}');
                        }),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(SeeAllPrayers());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                              size: AppDimensions.FONT_SIZE_18,
                              fontFamily: Weights.regular,
                              text: 'Prayer Requests'),
                          AppText(
                              size: AppDimensions.FONT_SIZE_14,
                              fontFamily: Weights.bold,
                              text: 'See All'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Center(
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Prayers')
                              .where('uid',
                                  isNotEqualTo:
                                      userDetailController.userUid.value)
                              .where('answered', isEqualTo: false)
                              .where('private_prayer', isEqualTo: false)
                              .orderBy('uid', descending: true)
                              // .limit(4)
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                            if (streamSnapshot.hasError) {
                              return Text('Something went wrong');
                            }
                            if (streamSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: Text("Loading"));
                            }
                            for (var i = 0;
                                i < streamSnapshot.data!.docs.length;
                                i++) {
                              if (streamSnapshot.data!.docs[i]['uid'] !=
                                      userDetailController.userUid.value ||
                                  streamSnapshot.data!.docs[i]
                                          ['private_prayer'] ==
                                      false) {
                                filterData.add(streamSnapshot.data!.docs);
                              } else {}
                            }
                            return streamSnapshot.data!.docs.length == 0
                                ? Container(
                                    width: Get.width * .45,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      // color: AppColors.WHITE_COLOR,
                                      borderRadius:
                                          AppBorderRadius.BORDER_RADIUS_05,
                                    ),
                                    child: Center(
                                        child: AppText(
                                      textAlign: TextAlign.center,
                                      text: "No Prayer Available",
                                      size: AppDimensions.FONT_SIZE_18,
                                      fontFamily: Weights.regular,
                                    )),
                                  )
                                : GridView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 200,
                                            // childAspectRatio: 3 / 1,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10),
                                    itemCount:
                                        streamSnapshot.data!.docs.length <= 4 &&
                                                streamSnapshot
                                                        .data!.docs.length >=
                                                    0
                                            ? streamSnapshot.data!.docs.length
                                            : 4,
                                    itemBuilder: (BuildContext ctx, index) {
                                      return GestureDetector(
                                          onTap: () {
                                            Get.to(SeeAllPrayers());
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: AppBorderRadius
                                                    .BORDER_RADIUS_05,
                                                color: AppColors.WHITE_COLOR,
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: AppColors
                                                          .GREY_COLOR
                                                          .withOpacity(.1),
                                                      spreadRadius: 10,
                                                      offset:
                                                          const Offset(0, 3),
                                                      blurRadius: 10)
                                                ]),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: Get.height * 0.02,
                                                ),
                                                CircleAvatar(
                                                  radius: 30,
                                                  backgroundColor:
                                                      AppColors.PRIMARY_COLOR,
                                                  backgroundImage: NetworkImage(
                                                      streamSnapshot
                                                              .data!.docs[index]
                                                          ['profile_image']),
                                                ),
                                                SizedBox(
                                                  height: Get.height * 0.02,
                                                ),
                                                Container(
                                                  child: Row(
                                                    children: [
                                                      Flexible(
                                                        child: Column(
                                                            children: [
                                                              Container(
                                                                width:
                                                                    Get.width *
                                                                        0.4,
                                                                height:
                                                                    Get.height *
                                                                        0.08,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            10.0),
                                                                child: AppText(
                                                                    // maxline: 3,
                                                                    fontFamily:
                                                                        Weights
                                                                            .light,
                                                                    size: AppDimensions
                                                                        .FONT_SIZE_12,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .fade,
                                                                    text: streamSnapshot
                                                                            .data!
                                                                            .docs[index]['prayer'] ??
                                                                        'Lorem ipsum dolor sit amectetur adipiscing elit. Orem ipsum dolorsit amet, consectetu.'),
                                                              ),
                                                            ]),
                                                      )
                                                    ],
                                                  ),
                                                ),

                                                // Padding(
                                                //   padding: const EdgeInsets.symmetric(
                                                //     horizontal: 10,
                                                //   ),
                                                //   child: AppText(
                                                //       maxline: 3,
                                                //       fontFamily: Weights.light,
                                                //       size: AppDimensions.FONT_SIZE_12,
                                                //       textAlign: TextAlign.center,
                                                //       overflow: TextOverflow.ellipsis,
                                                //       text: streamSnapshot.data!
                                                //               .docs[index]['prayer'] ??
                                                //           'Lorem ipsum dolor sit amectetur adipiscing elit. Orem ipsum dolorsit amet, consectetu.'),
                                                // ),
                                              ],
                                            ),
                                          ));
                                    });
                          }),
                    ),
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(MyPrayer());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                              size: AppDimensions.FONT_SIZE_18,
                              fontFamily: Weights.regular,
                              text: 'My Prayer'),
                          AppText(
                              size: AppDimensions.FONT_SIZE_14,
                              fontFamily: Weights.bold,
                              text: 'See All'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Center(
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Prayers')
                              .where('uid',
                                  isEqualTo: userDetailController.userUid.value)
                              .where('answered', isEqualTo: false)
                              .where('private_prayer', isEqualTo: false)
                              .orderBy('timestamp', descending: true)
                              // .orderBy('timestamp', descending: false)
                              // .limit(4)
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                            if (streamSnapshot.hasError) {
                              return Text('Something went wrong');
                            }
                            if (streamSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: Text("Loading"));
                            }

                            return streamSnapshot.data!.docs.length != 0
                                ? GridView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithMaxCrossAxisExtent(
                                            maxCrossAxisExtent: 200,
                                            // childAspectRatio: 3 / 1,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 10),
                                    itemCount:
                                        streamSnapshot.data!.docs.length <= 4
                                            ? streamSnapshot.data!.docs.length
                                            : 4,
                                    itemBuilder: (BuildContext ctx, index) {
                                      return Obx(() {
                                        return streamSnapshot.data!.docs[index]
                                                    ['uid'] ==
                                                userDetailController
                                                    .userUid.value
                                            ? GestureDetector(
                                                onTap: () {
                                                  Get.to(MyPrayer());
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          AppBorderRadius
                                                              .BORDER_RADIUS_05,
                                                      color:
                                                          AppColors.WHITE_COLOR,
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: AppColors
                                                                .GREY_COLOR
                                                                .withOpacity(
                                                                    .1),
                                                            spreadRadius: 10,
                                                            offset:
                                                                const Offset(
                                                                    0, 3),
                                                            blurRadius: 10)
                                                      ]),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height:
                                                            Get.height * 0.02,
                                                      ),
                                                      CircleAvatar(
                                                        radius: 30,
                                                        backgroundColor:
                                                            AppColors
                                                                .PRIMARY_COLOR,
                                                        backgroundImage: NetworkImage(
                                                            streamSnapshot.data!
                                                                    .docs[index]
                                                                [
                                                                'profile_image']),
                                                      ),
                                                      SizedBox(
                                                        height:
                                                            Get.height * 0.02,
                                                      ),
                                                      Container(
                                                        child: Row(
                                                          children: [
                                                            Flexible(
                                                              child: Column(
                                                                  children: [
                                                                    Container(
                                                                      width: Get
                                                                              .width *
                                                                          0.4,
                                                                      height: Get
                                                                              .height *
                                                                          0.08,
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              10.0),
                                                                      child: AppText(
                                                                          // maxline: 3,
                                                                          fontFamily: Weights.light,
                                                                          size: AppDimensions.FONT_SIZE_12,
                                                                          textAlign: TextAlign.center,
                                                                          overflow: TextOverflow.fade,
                                                                          text: streamSnapshot.data!.docs[index]['prayer']),
                                                                    ),
                                                                  ]),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ))
                                            : Container(
                                                color: AppColors.PRIMARY_COLOR,
                                              );
                                      });
                                    })
                                : Container(
                                    width: Get.width * .55,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      // color: AppColors.WHITE_COLOR,
                                      borderRadius:
                                          AppBorderRadius.BORDER_RADIUS_05,
                                    ),
                                    child: Center(
                                        child: AppText(
                                      textAlign: TextAlign.center,
                                      text: "Add Your Prayer Now",
                                      size: AppDimensions.FONT_SIZE_18,
                                      fontFamily: Weights.regular,
                                    )),
                                  );
                          }),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              )),
            ),
          ],
        ),
      );
    });
  }
}
