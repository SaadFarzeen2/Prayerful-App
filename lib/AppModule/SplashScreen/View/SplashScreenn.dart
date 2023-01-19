import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i77/AppModule/BottomNavigation/View/BottomNavigation.dart';
import 'package:i77/AppModule/OnboardingScreen/Controller/OnboardingController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Utils/Themes/AppColors.dart';
import '../../OnboardingScreen/View/OnboardingScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

final userDetailController = Get.put(OnboardingController());

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var duration = const Duration(seconds: 3);
    return Timer(duration, () async {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool("login") == true) {
        final user = FirebaseAuth.instance.currentUser;
        Get.offAll(BottomNavigation());
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OnboardingScreen(),
          ),
        );
      }
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => OnboardingScreen(),
      //   ),
      // );
    });
  }

  @override
  void initState() {
    userDetailController.getUserData();
    // TODO: implement initState
    startTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.PRIMARY_COLOR,
              AppColors.SECOND_PRIMARY_COLOR,
            ],
          ),
        ),
        height: Get.height,
        width: Get.width,
        child: Center(
          child: Image.asset(
            'assets/images/prayrful.png',
            color: AppColors.WHITE_COLOR,
            fit: BoxFit.fill,
            scale: 2.5,
          ),
        ),
      ),
    );
  }
}
