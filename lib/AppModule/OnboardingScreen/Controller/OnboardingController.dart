import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:i77/AppModule/OnboardingScreen/Controller/UserAddressConroller.dart';
import 'package:i77/AppModule/SeeAllPrayers/View/SeeAllPrayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userAddressLatLong = Get.put(UserAddressLatLong());

class OnboardingController extends GetxController {
  var isClick = false.obs;
  var isLoading = false.obs;
  var prioritize = false.obs;
  var profileimage = ''.obs;
  var username = ''.obs;
  var token = ''.obs;
  var useremal = ''.obs;
  var userUid = ''.obs;
  var userslatitude = ''.obs;
  var userslongitude = ''.obs;
  var userscountry = ''.obs;
  var time = ''.obs;
  var user = FirebaseAuth.instance.currentUser;
  var dropDown = false.obs;

  onclick(bool i) {
    dropDown.value = i;
    update();
  }

  @override
  void onInit() {
    getUserData();

    // getmatchDatawithmodel();
    // getsinglematcheduser();
    super.onInit();
  }

  changeStatus() {
    if (isClick.value == true) {
      isClick.value = false;
      update();
    } else if (isClick.value == false) {
      isClick.value = true;
      update();
    }
  }

//
// /////// Set user on firebase
  Future setUserData() async {
//it will check if user is logged in or not
    final user = FirebaseAuth.instance.currentUser;

    try {
      isLoading(true);
      final prefs = await SharedPreferences.getInstance();

      //adding user detials
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'timestamp': DateTime.now().toString(),
        'user_name': user!.displayName!,
        'user_email': user.email,
        'latitude': '',
        'longitude': '',
        'country': '',
        'token': '',
        'profile_image': user.photoURL,
        'user_uid': FirebaseAuth.instance.currentUser!.uid,
        // 'prioritize': false,

        // 'token': devicetoken.value,
      }).then((value) {
        FirebaseMessaging.onMessage.listen((event) {
          print('FCM Message Recevie');
        });
        storeNotification();
        pushNotification.requestPermission();
        pushNotification.loadFCM();
        pushNotification.listenFCM();
        // Get.to(() => AllowNotificationScreen());
        prefs.setString('uid', FirebaseAuth.instance.currentUser!.uid);
        prefs.setBool('login', true);
        prefs.setString('userName', user.displayName!);
        getUserData();
      });
      isLoading(false);
    } catch (e) {
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }

  ///update location
  updataUserLocation() async {
    // print('hello ${FirebaseAuth.instance.currentUser!.uid}');
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'latitude': userslatitude.value,
      'longitude': userslongitude.value,
      'country': userscountry.value,
      // 'user_uid': FirebaseAuth.instance.currentUser?.uid,
    });
  }

  ///update prioritize
  updatepriority(bool val) async {
    // print('hello ${FirebaseAuth.instance.currentUser!.uid}');
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'prioritize': val,

      // 'user_uid': FirebaseAuth.instance.currentUser?.uid,
    });
  }

  ///////////  getSingleUser From Firebase ////////////////
  getUserData() async {
    try {
      isLoading(true);
      print('isLoading $isLoading');

      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        profileimage.value = value.data()!["profile_image"];
        username.value = value.data()!["user_name"];
        token.value = value.data()!["token"];
        useremal.value = value.data()!["user_email"];
        userUid.value = value.data()!["user_uid"];
        time.value = value.data()!["timestamp"];
        userslatitude.value = value.data()!["latitude"];
        userslongitude.value = value.data()!["longitude"];
        userscountry.value = value.data()!["country"];
        prioritize.value = value.data()!["prioritize"];

        // print("dataaa");
        // print(" users list ${value.data()!["users_pictures_gallery"]} ");
        // print(value.data()!["user_name"]);
        isLoading(false);
        update();
        // print('isLoading after update $isLoading');
      });
    } catch (e) {
      print(e.toString());
    }
  }

  //////////////////////
  storeNotification() async {
    String? token = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(
      {'token': token},
    );

    print("device token : $token");
  }

  ////////////////////
  var tokenForAnswered = ''.obs;
  var tokenforReciveing = ''.obs;
  var tokens = false.obs;
  var tokens3 = false.obs;
  var nearByPrefs = false.obs;
  var noOnePrayedFor = false.obs;

  setPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance
        .collection('Preference')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(
      {
        'token1': token,
        'token2': token,
        'token': true,
        'token3': true,
        'near_by_people': true,
        'no_one_prayed_for': true,
        'uid': prefs.getString('uid').toString()
      },
    );
  }

  updatePrefsNearBy(
    bool nearby,
  ) async {
    FirebaseFirestore.instance
        .collection('Preference')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(
      {
        'near_by_people': nearby,
      },
    );
  }

  updatePrefsNoOne(
    bool noOnePrayed,
  ) async {
    FirebaseFirestore.instance
        .collection('Preference')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(
      {
        'no_one_prayed_for': noOnePrayed,
      },
    );
  }

  updateToken(bool tokenVal) async {
    String? token = await FirebaseMessaging.instance.getToken();
    FirebaseFirestore.instance
        .collection('Preference')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(
      {
        'token': tokenVal,
        'token1': token,
        'token2': token,
      },
    );
  }

  ////////////////////////////
  getPrefs() async {
    try {
      isLoading(true);
      print('isLoading $isLoading');

      await FirebaseFirestore.instance
          .collection("Preference")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        tokenForAnswered.value = value.data()!["token1"];
        tokenforReciveing.value = value.data()!["token2"];
        nearByPrefs.value = value.data()!["near_by_people"];
        noOnePrayedFor.value = value.data()!["no_one_prayed_for"];

        isLoading(false);
        update();
      });
    } catch (e) {
      print(e.toString());
    }
  }

  ////////////
  List allLatLngIds = [].obs;
  getAllUsersLatLong() async {
    isLoading(true);
    print('isLoading $isLoading');
    try {
      CollectionReference temp =
          FirebaseFirestore.instance.collection('LatLng');

      QuerySnapshot querySnapshot = await temp.get();
//Swiped user saved in a list
      allLatLngIds =
          querySnapshot.docs.map((doc) => doc.id.toString()).toList();

      print('Matched uids $allLatLngIds');
    } catch (e) {
      print(e.toString());
    }
  }
}

class Prefss {
  static clearPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }
}
