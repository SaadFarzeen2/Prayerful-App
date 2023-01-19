import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:i77/AppModule/BottomNavigation/View/BottomNavigation.dart';
import 'package:i77/AppModule/OnboardingScreen/Controller/OnboardingController.dart';
import 'package:i77/AppModule/OnboardingScreen/View/OnboardingScreen.dart';
import 'package:i77/Utils/Themes/AppColors.dart';

final userDetailController = Get.put(OnboardingController());

class AuthService {
  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.PRIMARY_COLOR),
            );
          }
          if (snapshot.hasData) {
            userDetailController.getUserData();
            return BottomNavigation();
          } else {
            return OnboardingScreen();
          }
        });
  }

  final userDetailController = Get.put(OnboardingController());
  GoogleSignInAccount? _user;

  GoogleSignInAccount get user => _user!;

//// signInWithGoogle
  signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser =
        await GoogleSignIn(scopes: <String>["email"]).signIn();

    if (googleUser == null) {
      _user = googleUser;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    Get.offAll(BottomNavigation());
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((value) async {
      //setting user on Firebase
      await userDetailController.setUserData();
      await userDetailController.setPrefs();
      await userDetailController.updataUserLocation();
    });
    // .then((value) => {
    //       onboardingController.setUserData(),
    //     });
  }

  //Sign out
  Future signOutId() async {
    try {
      await FirebaseAuth.instance.signOut().then((value) {
        Get.offAll(OnboardingScreen());
      });
    } catch (e) {}
  }
  // signOut() {
  //   FirebaseAuth.instance.signOut().then((value) {
  //     Get.offAll(SignupWith());
  //   });
  // }
}
