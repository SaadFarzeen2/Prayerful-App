// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:i77/AppModule/AddFriends/View/AddFriends.dart';

import 'package:i77/AppModule/OnboardingScreen/Controller/OnboardingController.dart';
import 'package:i77/AppModule/OnboardingScreen/View/OnboardingScreen.dart';
import 'package:i77/Services/FCM/sendPushMessage.dart';
import 'package:i77/Utils/Fonts/AppFonts.dart';
import 'package:i77/Utils/Paddings/AppBorderRadius.dart';
import 'package:i77/Utils/Paddings/AppPaddings.dart';
import 'package:i77/Utils/Widgets/AppButton.dart';
import 'package:i77/Utils/Widgets/AppText.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Utils/Fonts/AppDimensions.dart';
import '../../../Utils/Themes/AppColors.dart';
import '../../../Utils/Widgets/AppBarWidget.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // final profileController = Get.put(ProfileController());

  final userDetailController = Get.put(OnboardingController());

  final pushNotification = Get.put(PushNotification());

  var people = 1234;

  @override
  void initState() {
    userDetailController.getUserData();
    userDetailController.getPrefs();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Padding(
        padding: AppPaddings.defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PrimaryAppBar(
              titleText: 'Profile',
              prefixButtonColor: AppColors.WHITE_COLOR,
              prefixPadding: 10,
              prefixIconImage: 'assets/images/Back.png',
              titleSize: AppDimensions.FONT_SIZE_20,
            ),
            Expanded(
              child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Obx(() {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Get.height * 0.02,
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: AppText(
                                text: user!.displayName!,
                                size: AppDimensions.FONT_SIZE_22)),
                        SizedBox(
                          height: Get.height * 0.02,
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
                              return Column(
                                children: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Stack(
                                      children: [
                                        Padding(
                                            padding: EdgeInsets.all(7),
                                            child: CircleAvatar(
                                              radius: 50,
                                              backgroundImage:
                                                  NetworkImage(user.photoURL!),
                                            )),
                                        snapshot.data!.docs.length >= 100
                                            ? Positioned(
                                                right: 10,
                                                top: 2,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color:
                                                          AppColors.WHITE_COLOR,
                                                      border: Border.all(
                                                          color: AppColors
                                                              .THIRD_PRIMARY_COLOR)),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: Image.asset(
                                                      'assets/images/king.png',
                                                      height: Get.height * 0.02,
                                                    ),
                                                  ),
                                                ))
                                            : SizedBox.shrink(),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: Get.height * 0.02,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AppText(
                                          text: 'Prayed for ',
                                          size: AppDimensions.FONT_SIZE_16),

                                      AppText(
                                          text: snapshot.data!.docs.length
                                              .toString(),
                                          size: AppDimensions.FONT_SIZE_16,
                                          color: AppColors.PRIMARY_COLOR,
                                          fontFamily: Weights.bold),
                                      // }),
                                      AppText(
                                          text: ' people',
                                          size: AppDimensions.FONT_SIZE_16),
                                    ],
                                  ),
                                ],
                              );
                            }),
                        SizedBox(
                          height: Get.height * 0.02,
                        ),
                        AppText(
                            textAlign: TextAlign.center,
                            text:
                                '“And this is the confidence that we have toward him, that if we ask anything according to his will he hears us. - 1 John 5:14”',
                            size: AppDimensions.FONT_SIZE_18,
                            fontFamily: Weights.medium),
                        SizedBox(
                          height: Get.height * 0.02,
                        ),
                        Row(
                          children: [
                            AppText(
                                text: 'App Settings',
                                size: AppDimensions.FONT_SIZE_20,
                                fontFamily: Weights.medium),
                            Spacer(),
                            GestureDetector(
                              onTap:
                                  userDetailController.dropDown.value == false
                                      ? () {
                                          userDetailController.onclick(true);
                                        }
                                      : () {
                                          userDetailController.onclick(false);
                                        },
                              child:
                                  userDetailController.dropDown.value == false
                                      ? Image.asset(
                                          "assets/images/drop_down.png",
                                          scale: 30,
                                          color: AppColors.BLACK_COLOR
                                              .withOpacity(0.6),
                                        )
                                      : Image.asset(
                                          "assets/images/drop_up.png",
                                          scale: 30,
                                          color: AppColors.BLACK_COLOR
                                              .withOpacity(0.6),
                                        ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Get.height * 0.02,
                        ),
                        userDetailController.dropDown.value != false
                            ? SizedBox.shrink()
                            : Builder(builder: (context) {
                                return StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('Preference')
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
                                      return Container(
                                        height: Get.height * 0.3,
                                        child: ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount:
                                                snapshot.data!.docs.length,
                                            itemBuilder: (context, index) {
                                              return snapshot.data!.docs[index]
                                                          ['uid'] ==
                                                      userDetailController
                                                          .userUid.value
                                                  ? Column(
                                                      children: [
                                                        ToggleRow(
                                                          title:
                                                              'Prioritize prayers of people near me.',
                                                          profileController:
                                                              snapshot.data!
                                                                          .docs[
                                                                      index][
                                                                  'near_by_people'],
                                                          ontap: () async {
                                                            if (snapshot.data!
                                                                            .docs[
                                                                        index][
                                                                    'near_by_people'] ==
                                                                false) {
                                                              userDetailController
                                                                  .updatePrefsNearBy(
                                                                      true);
                                                            } else {
                                                              userDetailController
                                                                  .updatePrefsNearBy(
                                                                      false);
                                                            }
                                                          },
                                                        ),
                                                        ToggleRow(
                                                          title:
                                                              "Prioritize prayers no one prayed for yet",
                                                          profileController:
                                                              snapshot.data!
                                                                          .docs[
                                                                      index][
                                                                  'no_one_prayed_for'],
                                                          ontap: () async {
                                                            if (snapshot.data!
                                                                            .docs[
                                                                        index][
                                                                    'no_one_prayed_for'] ==
                                                                false) {
                                                              userDetailController
                                                                  .updatePrefsNoOne(
                                                                      true);
                                                            } else {
                                                              userDetailController
                                                                  .updatePrefsNoOne(
                                                                      false);
                                                            }
                                                          },
                                                        ),
                                                        ToggleRow(
                                                          title:
                                                              "Notify when someone prays or me.",
                                                          profileController:
                                                              snapshot.data!
                                                                          .docs[
                                                                      index]
                                                                  ['token'],
                                                          ontap: () async {
                                                            if (snapshot.data!
                                                                            .docs[
                                                                        index]
                                                                    ['token'] ==
                                                                false) {
                                                              FirebaseMessaging
                                                                  .onMessage
                                                                  .listen(
                                                                      (event) {
                                                                print(
                                                                    'FCM Message Recevie');
                                                              });
                                                              storeNotification();
                                                              pushNotification
                                                                  .requestPermission();
                                                              pushNotification
                                                                  .loadFCM();
                                                              pushNotification
                                                                  .listenFCM();
                                                            } else {
                                                              removeNotificationToken();
                                                            }
                                                          },
                                                        ),
                                                        ToggleRow(
                                                          title:
                                                              "Notify when someone's prayer whom I prayed is answered",
                                                          profileController:
                                                              snapshot.data!
                                                                          .docs[
                                                                      index]
                                                                  ['token3'],
                                                          ontap: () {
                                                            if (snapshot.data!
                                                                            .docs[
                                                                        index][
                                                                    'token3'] ==
                                                                false) {
                                                              FirebaseMessaging
                                                                  .onMessage
                                                                  .listen(
                                                                      (event) {
                                                                print(
                                                                    'FCM Message Recevie');
                                                              });
                                                              storeNotification2();
                                                              pushNotification
                                                                  .requestPermission();
                                                              pushNotification
                                                                  .loadFCM();
                                                              pushNotification
                                                                  .listenFCM();
                                                              userDetailController
                                                                  .tokens3
                                                                  .value = true;
                                                            } else {
                                                              removeNotificationToken2();
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    )
                                                  : Container();
                                            }),
                                      );
                                    });
                              })
                      ],
                    );
                  })),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            AppButton(
                buttonRadius: AppBorderRadius.BORDER_RADIUS_10,
                buttonWidth: Get.width,
                textSize: AppDimensions.FONT_SIZE_18,
                buttonName: 'Save',
                buttonColor: AppColors.PRIMARY_COLOR,
                textColor: AppColors.WHITE_COLOR,
                onTap: () {
                  showSnackBar(context, 'Your Preferances are saved');
                }),
            SizedBox(
              height: Get.height * 0.02,
            ),
            AppButton(
                buttonRadius: AppBorderRadius.BORDER_RADIUS_10,
                buttonWidth: Get.width,
                textSize: AppDimensions.FONT_SIZE_18,
                buttonName: 'LogOut',
                buttonColor: AppColors.PRIMARY_COLOR,
                textColor: AppColors.WHITE_COLOR,
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) {
                        return AlertDialog(
                          title: Text('Are You Sure You Want to Logout'),
                          // content: /* Here add your custom widget  */
                          actions: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Prefss.clearPrefs();
                                Get.offAll(OnboardingScreen());
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      AppBorderRadius.BORDER_RADIUS_10,
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 8),
                                child: AppText(text: 'Yes'),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                color: AppColors.PRIMARY_COLOR,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 8),
                                child: AppText(text: 'No'),
                              ),
                            ),
                          ],
                        );
                      });
                }),
            SizedBox(
              height: Get.height * 0.02,
            ),
          ],
        ),
      ),
    );
  }

  storeNotification() async {
    String? token = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(
      {'token': token},
    ).then((value) async {
      await FirebaseFirestore.instance
          .collection('Preference')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(
        {'token1': token, 'token': true},
      );
    });

    print("device token : $token");
  }

  storeNotification2() async {
    String? token = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(
      {'token': token},
    ).then((value) async {
      await FirebaseFirestore.instance
          .collection('Preference')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(
        {'token2': token, 'token3': true},
      );
    });

    print("device token : $token");
  }

  removeNotificationToken() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(
      {'token': ''},
    ).then((value) async {
      await FirebaseFirestore.instance
          .collection('Preference')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(
        {'token1': '', 'token': false},
      );
    });

    print("device token removed:");
  }

  removeNotificationToken2() async {
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(
      {'token': ''},
    ).then((value) async {
      await FirebaseFirestore.instance
          .collection('Preference')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(
        {'token2': '', 'token3': false},
      );
    });

    print("device token removed:");
  }
}

class ToggleRow extends StatefulWidget {
  String title;
  VoidCallback ontap;
  bool? profileController;
  String token;
  ToggleRow({
    Key? key,
    required this.title,
    required this.ontap,
    this.token = '',
    this.profileController,
  }) : super(key: key);

  @override
  State<ToggleRow> createState() => _ToggleRowState();
}

class _ToggleRowState extends State<ToggleRow> {
  // final profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17.0),
      child: Row(
        children: [
          SizedBox(
              width: Get.width / 2,
              child: AppText(
                  text: widget.title,
                  size: AppDimensions.FONT_SIZE_16,
                  fontFamily: Weights.medium)),
          const Spacer(),
          GestureDetector(
            onTap: widget.ontap,

            // () {
            //   if (profileController
            //           .isClick1.value ==
            //       false) {
            //     profileController.ontapp(true);
            //   } else {
            //     storeNotification();
            //     profileController.ontapp(false);
            //   }
            // },
            child:
                // Obx(() {
                //   return

                Container(
              decoration: BoxDecoration(
                  borderRadius: AppBorderRadius.BORDER_RADIUS_30,
                  color: AppColors.WHITE_COLOR,
                  border: Border.all(
                      color: widget.profileController == true
                          ? AppColors.PRIMARY_COLOR
                          : AppColors.GREY_COLOR)),
              child: Row(
                children: [
                  SizedBox(
                    width: widget.profileController == true
                        ? Get.width * 0.04
                        : Get.width * 0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: CircleAvatar(
                      backgroundColor: widget.profileController == true
                          ? AppColors.PRIMARY_COLOR
                          : AppColors.BLACK_COLOR.withOpacity(.6),
                      radius: 10,
                    ),
                  ),
                  SizedBox(
                    width: widget.profileController == true
                        ? Get.width * 0
                        : Get.width * 0.04,
                  ),
                ],
              ),
            ),

            // }),
          )
        ],
      ),
    );
  }
}
