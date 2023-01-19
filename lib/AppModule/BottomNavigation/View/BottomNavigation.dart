// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:i77/AppModule/AddFriends/View/AddFriends.dart';

import 'package:i77/Services/FCM/sendPushMessage.dart';

import '../../../Utils/Fonts/AppDimensions.dart';
import '../../../Utils/Fonts/AppFonts.dart';
import '../../../Utils/Themes/AppColors.dart';
import '../../../Utils/Widgets/AppText.dart';
import '../../AddPrayer/View/AddPrayer.dart';
import '../../HomeScreen/View/HomeScreen.dart';
import '../../PrayerRequests/View/MyPrayer.dart';

class BottomNavigation extends StatefulWidget {
  // int? currentTab=0;
  BottomNavigation({
    Key? key,
    // required this.currentTab,
  }) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  late bool keyboardIsOpened;

  int currentTab = 0;
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const HomeScreenController();
  final pushNotification = Get.put(PushNotification());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: Scaffold(
        body: PageStorage(
          bucket: bucket,
          child: currentScreen,
        ),
        floatingActionButton: keyboardIsOpened
            ? null
            : GestureDetector(
                onTap: () {
                  setState(() {
                    currentScreen =
                        AddPrayerScreen(); // if user taps on this dashboard tab will be active
                    currentTab = 1;
                  });
                },
                child: Container(
                    height: Get.height / 6,
                    width: Get.width / 6,
                    decoration: BoxDecoration(
                        color: AppColors.WHITE_COLOR,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.GREY_COLOR.withOpacity(.2),
                            spreadRadius: 3,
                            blurRadius: 4,
                            offset: const Offset(1, 1),
                          )
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/prayLogo.png',
                            height: Get.height * 0.035,
                            width: Get.height * 0.035,
                            color: currentTab == 1
                                ? AppColors.PRIMARY_COLOR
                                : AppColors.BLACK_COLOR),
                      ],
                    )),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 0,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: Get.width * 0.04,
                    ),
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          currentScreen =
                              HomeScreen(); // if user taps on this dashboard tab will be active
                          currentTab = 0;
                        });
                      },
                      //  Column(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: <Widget>[
                      //     Image.asset(
                      //       'assets/images/home.png',
                      //       color: currentTab == 0
                      //           ? AppColors.PRIMARY_COLOR
                      //           : AppColors.BLACK_COLOR,
                      //       height: Get.height * 0.02,
                      //     ),
                      //     SizedBox(
                      //       height: Get.height * 0.008,
                      //     ),
                      //     AppText(
                      //         text: 'Home',
                      //         size: AppDimensions.FONT_SIZE_12,
                      //         fontFamily: Weights.regular,
                      //         color: currentTab == 0
                      //             ? AppColors.PRIMARY_COLOR
                      //             : AppColors.BLACK_COLOR)
                      //   ],
                      // ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/home.png',
                            color: currentTab == 0
                                ? AppColors.PRIMARY_COLOR
                                : AppColors.BLACK_COLOR,
                            height: Get.height * 0.02,
                          ),
                          SizedBox(
                            height: Get.height * 0.008,
                          ),
                          AppText(
                              text: 'Home',
                              size: AppDimensions.FONT_SIZE_12,
                              fontFamily: Weights.regular,
                              color: currentTab == 0
                                  ? AppColors.PRIMARY_COLOR
                                  : AppColors.BLACK_COLOR)
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    SizedBox(
                      width: Get.width * 0.04,
                    ),
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          currentScreen =
                              AddPrayerScreen(); // if user taps on this dashboard tab will be active
                          currentTab = 1;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: Get.height * 0.04,
                          ),
                          AppText(
                              text: 'Add Prayer',
                              size: AppDimensions.FONT_SIZE_12,
                              fontFamily: Weights.regular,
                              color: currentTab == 1
                                  ? AppColors.PRIMARY_COLOR
                                  : AppColors.BLACK_COLOR)
                        ],
                      ),
                    ),
                  ],
                ),

                // Right Tab bar icons

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    MaterialButton(
                      minWidth: 40,
                      onPressed: () {
                        setState(() {
                          currentScreen =
                              MyPrayer(); // if user taps on this dashboard tab will be active
                          currentTab = 2;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/myPray.png',
                            color: currentTab == 2
                                ? AppColors.PRIMARY_COLOR
                                : AppColors.BLACK_COLOR,
                            height: Get.height * 0.022,
                          ),
                          SizedBox(
                            height: Get.height * 0.008,
                          ),
                          AppText(
                              text: 'My Prayers',
                              size: AppDimensions.FONT_SIZE_12,
                              fontFamily: Weights.regular,
                              color: currentTab == 2
                                  ? AppColors.PRIMARY_COLOR
                                  : AppColors.BLACK_COLOR)
                        ],
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.02,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreenController extends StatelessWidget {
  const HomeScreenController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: HomeScreen(),
    );
  }
}

DateTime? currentBackPressTime;

Future<bool> onWillPop(BuildContext context) {
  DateTime now = DateTime.now();
  if (currentBackPressTime == null ||
      now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
    currentBackPressTime = now;
    showSnackBar(context, 'Double Tap to Exit');
    // Get.snackbar(
    //   "",
    //   '',
    //   colorText: AppColors.WHITE_COLOR,
    //   messageText:
    //       AppText(text: "Double Tap to Exit", size: AppDimensions.FONT_SIZE_18),
    //   duration: const Duration(seconds: 2),
    //   backgroundColor: AppColors.PRIMARY_COLOR,
    //   snackPosition: SnackPosition.BOTTOM,
    // );
    return Future.value(false);
  }
  SystemNavigator.pop();
  return Future.value(true);
}
