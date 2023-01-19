import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i77/AppModule/AddFriends/Controller/add_friend_controller.dart';
import 'package:i77/AppModule/AddPrayer/controller/add_prayer_controller.dart';
import 'package:i77/AppModule/BottomNavigation/View/BottomNavigation.dart';
import 'package:i77/AppModule/NotificationScreen/Controller/notification_controller.dart';
import 'package:i77/AppModule/OnboardingScreen/Controller/OnboardingController.dart';
import 'package:i77/AppModule/OnboardingScreen/Controller/UserAddressConroller.dart';
import 'package:i77/AppModule/PrayTogether/View/PrayTogether.dart';
import 'package:i77/Services/FCM/sendPushMessage.dart';
import 'package:i77/Utils/Widgets/AppButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/Fonts/AppDimensions.dart';
import '../../../Utils/Fonts/AppFonts.dart';
import '../../../Utils/Paddings/AppBorderRadius.dart';
import '../../../Utils/Paddings/AppPaddings.dart';
import '../../../Utils/Themes/AppColors.dart';
import '../../../Utils/Widgets/AppBarWidget.dart';
import '../../../Utils/Widgets/AppText.dart';
import '../../AddFriends/View/AddFriends.dart';
import '../../PrayerRequests/View/MyPrayer.dart';

class AddPrayerScreen extends StatefulWidget {
  AddPrayerScreen({Key? key}) : super(key: key);

  @override
  State<AddPrayerScreen> createState() => _AddPrayerScreenState();
}

class _AddPrayerScreenState extends State<AddPrayerScreen> {
  final addPrayerController = Get.put(AddPrayerController());
  final userAddressLatLong = Get.put(UserAddressLatLong());
  final userDetailController = Get.put(OnboardingController());
  final addFriendsController = Get.put(AddFriendsController());
  final pushNotification = Get.put(PushNotification());
  final setNotification = Get.put(NotificationController());
  var latlnglist = [];

  var nearbypeople2 = [];

  int totalpraying = 0;

  @override
  void initState() {
    userDetailController.getUserData();
    userDetailController.getAllUsersLatLong();
    // userAddressLatLong.getLocation();
    nearby();

    super.initState();
  }

  nearby() async {
    for (var i = 0; i < userDetailController.allLatLngIds.length; i++) {
      var dista = addPrayerController
          .calculateDistance(
              double.parse(
                "${userAddressLatLong.latitude2.value}",
              ),
              double.parse(
                "${userAddressLatLong.longitude2.value}",
              ),
              double.parse(userDetailController.allLatLngIds[i]['lat'].isEmpty
                  ? "0.0"
                  : userDetailController.allLatLngIds[i]['lat']),
              double.parse(userDetailController.allLatLngIds[i]['lng'].isEmpty
                  ? "0.0"
                  : userDetailController.allLatLngIds[i]['lng']))
          .toString();
      if (double.parse(dista) < 10.00 &&
          // ignore: unrelated_type_equality_checks
          userDetailController.userUid.value !=
              userDetailController.allLatLngIds[i]) {
        addPrayerController.nearbypeople
            .add(userDetailController.allLatLngIds[i]);
        print("near by length :${addPrayerController.nearbypeople}");
      } else {
        nearbypeople2.add(userDetailController.allLatLngIds[i]);
        // ignore: unnecessary_statements
        "near by length :$nearbypeople2";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: AppPaddings.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryAppBar(
              titleText: 'Add a Prayer',
              isSuffix: true,
              isPrefix: true,
              prefixPadding: 10,
              prefixButtonColor: AppColors.WHITE_COLOR,
              prefixIconImage: 'assets/images/Back.png',
              titleSize: AppDimensions.FONT_SIZE_20,
              prefixOnTap: () {
                Get.offAll(BottomNavigation());
              },
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: [
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
                      // StreamBuilder(
                      //     stream: FirebaseFirestore.instance
                      //         .collection('LatLng')
                      //         .snapshots(),
                      //     builder:
                      //         (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      //       if (snapshot.hasError) {
                      //         return Text('Something went wrong');
                      //       }
                      //       if (snapshot.connectionState ==
                      //           ConnectionState.waiting) {
                      //         return Center(child: Text("Loading"));
                      //       }

                      //       for (var i = 0;
                      //           i < snapshot.data!.docs.length;
                      //           i++) {
                      //         var dista = addPrayerController
                      //             .calculateDistance(
                      //                 double.parse(
                      //                   "${userAddressLatLong.latitude2.value}",
                      //                 ),
                      //                 double.parse(
                      //                   "${userAddressLatLong.longitude2.value}",
                      //                 ),
                      //                 double.parse(
                      //                     snapshot.data!.docs[i]['lat'].isEmpty
                      //                         ? "0.0"
                      //                         : snapshot.data!.docs[i]['lat']),
                      //                 double.parse(
                      //                     snapshot.data!.docs[i]['lng'].isEmpty
                      //                         ? "0.0"
                      //                         : snapshot.data!.docs[i]['lng']))
                      //             .toString();
                      //         if (double.parse(dista) < 10.00 &&
                      //             // ignore: unrelated_type_equality_checks
                      //             userDetailController.userUid.value !=
                      //                 snapshot.data!.docs[i]) {
                      //           addPrayerController.nearbypeople
                      //               .add(snapshot.data!.docs[i]);
                      //           print(
                      //               "near by length :${addPrayerController.nearbypeople}");
                      //         } else {
                      //           nearbypeople2.add(snapshot.data!.docs[i]);
                      //           // ignore: unnecessary_statements
                      //           "near by length :$nearbypeople2";
                      //         }
                      //       }

                      // return
                      Column(
                        children: [
                          AppText(
                            size: AppDimensions.FONT_SIZE_16,
                            fontFamily: Weights.regular,
                            text:
                                "2 prayer warriors near you", // '${addPrayerController.nearbypeople.length} prayer warriors near you',
                          )
                        ],
                      ),
                      // }),
                      // AppText(
                      //     size: AppDimensions.FONT_SIZE_16,
                      //     fontFamily: Weights.regular,
                      //     text:
                      //         '${nearbypeople2.length} prayer warriors near you')
                      // AppText(
                      //     size: AppDimensions.FONT_SIZE_16,
                      //     fontFamily: Weights.regular,
                      //     text: '136 prayer warriors near you'),
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                  TextFormField(
                    controller: addPrayerController.prayerDesController,
                    cursorColor: AppColors.PRIMARY_COLOR,
                    maxLines: 7,
                    onChanged: (value) {
                      setState(() {
                        addPrayerController.prayerdescription.value =
                            addPrayerController.prayerDesController.text;
                      });
                    },
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Type your prayer here',
                      hintStyle: TextStyle(
                          color: AppColors.BLACK_COLOR.withOpacity(.5),
                          fontFamily: Weights.light),
                      focusColor: AppColors.PRIMARY_COLOR,
                      filled: true,
                      fillColor: AppColors.GREY_COLOR.withOpacity(0.1),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.GREY_COLOR.withOpacity(.2),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.BLACK_COLOR.withOpacity(.5),
                      ),
                      SizedBox(
                        width: Get.width * 0.02,
                      ),
                      AppText(
                          text: 'Prayers are publicly visible by default.',
                          color: AppColors.BLACK_COLOR.withOpacity(.5),
                          size: AppDimensions.FONT_SIZE_14),
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  Row(
                    children: [
                      AppText(
                          text: 'Make prayer private',
                          fontFamily: Weights.medium),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          addPrayerController.updateClick();
                        },
                        child: Obx(() {
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: AppBorderRadius.BORDER_RADIUS_30,
                                color: AppColors.WHITE_COLOR,
                                border: Border.all(
                                    color: addPrayerController.isClick.value
                                        ? AppColors.PRIMARY_COLOR
                                        : AppColors.GREY_COLOR)),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: addPrayerController.isClick.value
                                      ? Get.width * 0.04
                                      : Get.width * 0,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: CircleAvatar(
                                    backgroundColor: addPrayerController
                                            .isClick.value
                                        ? AppColors.PRIMARY_COLOR
                                        : AppColors.BLACK_COLOR.withOpacity(.6),
                                    radius: 10,
                                  ),
                                ),
                                SizedBox(
                                  width: addPrayerController.isClick.value
                                      ? Get.width * 0
                                      : Get.width * 0.04,
                                ),
                              ],
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.015,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text("${totalpraying}" + " Friends added"),
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.015,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(AddFriendsScreen());
                    },
                    child: Row(
                      children: [
                        AppText(
                            text: 'Invite Friends to pray',
                            size: AppDimensions.FONT_SIZE_20,
                            fontFamily: Weights.medium),
                        const Spacer(),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  Row(
                    children: [
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('AddFreind')
                              .doc(userDetailController.userUid.value)
                              .collection('AllFriends')
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            totalpraying = snapshot.data!.docs.length;

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
                            return snapshot.data!.docs.length == 0
                                ? SizedBox()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      for (int i = 0;
                                          i < snapshot.data!.docs.length;
                                          i++)
                                        Align(
                                          widthFactor: 0.7,
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundImage: NetworkImage(
                                                snapshot.data!.docs[i]
                                                    ['profile_image']),
                                          ),
                                        ),
                                    ],
                                  );
                          }),
                      GestureDetector(
                        onTap: (() {
                          Get.to(AddFriendsScreen());
                        }),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Align(
                                widthFactor: 0.7,
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: AppColors.PRIMARY_COLOR,
                                  child: Icon(
                                    Icons.add,
                                    color: AppColors.WHITE_COLOR,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
            Obx(() {
              return Row(
                children: [
                  Flexible(
                    child: addPrayerController.isLoading.isTrue
                        ? Center(
                            child: CircularProgressIndicator(
                                color: AppColors.PRIMARY_COLOR),
                          )
                        : StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('AddFreind')
                                .doc(userDetailController.userUid.value)
                                .collection('AllFriends')
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Something went wrong');
                              }
                              return AppButton(
                                  buttonWidth: Get.width,
                                  borderColor: AppColors.PRIMARY_COLOR,
                                  buttonRadius:
                                      AppBorderRadius.BORDER_RADIUS_10,
                                  buttonName: 'Add Prayer',
                                  textSize: AppDimensions.FONT_SIZE_17,
                                  buttonColor: AppColors.PRIMARY_COLOR,
                                  textColor: AppColors.WHITE_COLOR,
                                  onTap: addPrayerController
                                          .prayerDesController.text.isEmpty
                                      ? () {
                                          print(
                                              "text field text: ${addPrayerController.prayerDesController.text}");
                                          showSnackBar(context,
                                              'Did you Forget to type your Prayer in the textBox');
                                        }
                                      : () async {
                                          setState(() {
                                            addPrayerController
                                                    .prayerdescription.value =
                                                addPrayerController
                                                    .prayerDesController.text;

                                            Get.offAll(BottomNavigation());
                                          });
                                          addPrayerController.addPrayer();
                                          showSnackBar(context,
                                              'Prayer Created Successfully!');

                                          for (var index = 0;
                                              index <
                                                  snapshot.data!.docs.length;
                                              index++) {
                                            pushNotification.sendPushMessage(
                                              '${userDetailController.username.value} Added You in a Prayer',
                                              "",
                                              snapshot.data!.docs[index]
                                                  ['token'],
                                              userDetailController
                                                  .userUid.value,
                                              '',
                                              'send',
                                            );
                                            ////////////////
                                            final prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            //////////////set notification////////////
                                            setNotification.setNotification(
                                              snapshot.data!.docs[index]
                                                  ['user_added_id'],
                                              snapshot.data!.docs[index]
                                                  ['name'],
                                              snapshot.data!.docs[index]
                                                  ['profile_image'],
                                              snapshot.data!.docs[index]
                                                  ['token'],
                                              userDetailController
                                                  .userUid.value,
                                              userDetailController
                                                  .username.value,
                                              userDetailController
                                                  .profileimage.value,
                                              userDetailController.token.value,
                                              'As Friend',
                                              false,
                                              addPrayerController
                                                  .prayerDesController.text,
                                              prefs
                                                  .getString('postid')
                                                  .toString(),
                                            );
                                          }
                                        });
                            }),
                  ),
                  SizedBox(
                    width: Get.width * 0.02,
                  ),
                  Flexible(
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('AddFreind')
                            .doc(userDetailController.userUid.value)
                            .collection('AllFriends')
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          }
                          return AppButton(
                              buttonWidth: Get.width,
                              borderColor: AppColors.PRIMARY_COLOR,
                              buttonRadius: AppBorderRadius.BORDER_RADIUS_10,
                              buttonName: 'Pray Together',
                              textSize: AppDimensions.FONT_SIZE_17,
                              buttonColor: AppColors.WHITE_COLOR,
                              textColor: AppColors.PRIMARY_COLOR,
                              onTap: addPrayerController
                                      .prayerDesController.text.isEmpty
                                  ? () {
                                      print(
                                          "text field text: ${addPrayerController.prayerDesController.text}");
                                      showSnackBar(context,
                                          'Did you Forget to type your Prayer in the textBox');
                                    }
                                  : () async {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      setState(() {
                                        addPrayerController
                                                .prayerdescription.value =
                                            addPrayerController
                                                .prayerDesController.text;
                                      });
                                      addPrayerController.addPrayer();
                                      showSnackBar(context,
                                          'Prayer Created Successfully!');

                                      for (var index = 0;
                                          index < snapshot.data!.docs.length;
                                          index++) {
                                        pushNotification.sendPushMessage(
                                          '${userDetailController.username.value} Added You in a Prayer',
                                          "",
                                          snapshot.data!.docs[index]['token'],
                                          userDetailController.userUid.value,
                                          '',
                                          'send',
                                        );

                                        //////////////set notification////////////
                                        ///

                                        log("USer name: " +
                                            snapshot.data!.docs[index]['name']);
                                        log("User added id : " +
                                            snapshot.data!.docs[index]
                                                ['user_added_id']);
                                        log(
                                          "user uid : " +
                                              userDetailController
                                                  .userUid.value,
                                        );
                                        log(
                                          "user controller name: " +
                                              userDetailController
                                                  .username.value,
                                        );

                                        setNotification.setNotification(
                                          snapshot.data!.docs[index]
                                              ['user_added_id'],
                                          snapshot.data!.docs[index]['name'],
                                          snapshot.data!.docs[index]
                                              ['profile_image'],
                                          snapshot.data!.docs[index]['token'],
                                          userDetailController.userUid.value,
                                          userDetailController.username.value,
                                          userDetailController
                                              .profileimage.value,
                                          userDetailController.token.value,
                                          'As Friend',
                                          false,
                                          addPrayerController
                                              .prayerDesController.text,
                                          prefs.getString('postid').toString(),
                                        );
                                      }
                                      FirebaseFirestore.instance
                                          .collection('Prayer_types')
                                          .add({
                                        "prayerid": prefs
                                            .getString('postid')
                                            .toString(),
                                        "prayername": addPrayerController
                                            .prayerDesController.text,
                                        "prayerimage": userDetailController
                                            .profileimage.value,
                                        "Usernamelist":
                                            userDetailController.username.value,
                                        "UserImagelist": userDetailController
                                            .profileimage.value,
                                        "Usertokenlist":
                                            userDetailController.token.value,
                                      });
                                      ///////////////////////prayer togather
                                      await Get.to(PrayTogetherScreen(
                                          id: prefs
                                              .getString('postid')
                                              .toString(),
                                          image: userDetailController
                                              .profileimage.value,
                                          prayer: addPrayerController
                                              .prayerDesController.text));
                                    });
                        }),
                  )
                ],
              );
            }),
            SizedBox(
              height: Get.height * 0.05,
            ),
          ],
        ),
      ),
    );
    // });
  }
}
