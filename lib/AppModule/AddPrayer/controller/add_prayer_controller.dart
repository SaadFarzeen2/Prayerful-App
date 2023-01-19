import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i77/AppModule/AddFriends/Controller/add_friend_controller.dart';
import 'package:i77/AppModule/OnboardingScreen/Controller/OnboardingController.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPrayerController extends GetxController {
  TextEditingController prayerDesController = TextEditingController();

  var isClick = false.obs;
  var isLoading = false.obs;
  var prayerdescription = ''.obs;
  var prayerId = ''.obs;
  var prayedId = ''.obs;
  var whoprayedUid = ''.obs;
  var id = ''.obs;
  var uid = ''.obs;
  var usertoken = ''.obs;
  var shareWithFriesnds = [].obs;
  final userDetailController = Get.put(OnboardingController());
  final addFriendsController = Get.put(AddFriendsController());
  var peoplePrayed = [].obs;
  var nearbypeople = [].obs;

  updateClick() {
    isClick.toggle();
    update();
  }
///////random number gentaor///////

  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
//////////////////////////////////////////////
  Future addPrayer() async {
    try {
      isLoading(true);
      final prefs = await SharedPreferences.getInstance();
      String random = getRandomString(15);
      await FirebaseFirestore.instance.collection('Prayers').doc(random).set({
        'timestamp': DateTime.now().toString(),
        'profile_image': userDetailController.profileimage.value.toString(),
        'prayer': prayerdescription.value.toString(),
        'name': userDetailController.username.value.toString(),
        'token': userDetailController.token.value.toString(),
        'uid': userDetailController.userUid.toString(),
        'private_prayer': isClick.value,
        'location': userDetailController.userscountry.toString(),
        'answered': false,
        'id': random.toString(),
        'status': '',
      }).then((value) => {
            isClick.value = false,
            prayerDesController.clear(),
            prayerdescription.value = '',
            addFriendsController.removefriendafterposting(),
            prefs.setString('postid', random.toString()),
          });
      isLoading(false);
      // Get.back();
    } catch (e) {
      isLoading(false);
      print("catch error ${e.toString()}");
    }
  }

/////GetSinglePraayer////
  getSinglePrayer(String docid) async {
    try {
      isLoading(true);
      print('isLoading $isLoading');

      await FirebaseFirestore.instance
          .collection("Prayers")
          .doc(docid)
          .get()
          .then((value) {
        uid.value = value.data()!["uid"];

        isLoading(false);
        update();
        // print('isLoading after update $isLoading');
      });
    } catch (e) {
      print(e.toString());
    }
  }

  updateAnswerStatus(String prayerid) async {
    await FirebaseFirestore.instance
        .collection("Prayers")
        .doc(prayerid)
        .update({'answered': true});
  }

  updatePrayerStatus(String prayerid) async {
    await FirebaseFirestore.instance
        .collection("Prayers")
        .doc(prayerid)
        .update({'status': true});
  }

  Future prayedOnPrayers(String prayerid) async {
    try {
      isLoading(true);
      String random = getRandomString(15);
      await FirebaseFirestore.instance
          .collection('Prayers')
          .doc(prayerid)
          .collection('Prayed')
          .doc(userDetailController.userUid.value)
          .set({
        'timestamp': DateTime.now().toString(),
        'profile_image': userDetailController.profileimage.value.toString(),
        'prayer_id': prayerid.toString(),
        'name': userDetailController.username.value.toString(),
        'uid': userDetailController.userUid.value.toString(),
        'token': userDetailController.token.value,
      });
      isLoading(false);
      // Get.back();
    } catch (e) {
      isLoading(false);
      print("catch error ${e.toString()}");
    }
  }

  getUserPrayed(String prayerid, String prayedid) async {
    try {
      isLoading(true);
      print('isLoading $isLoading');

      await FirebaseFirestore.instance
          .collection("Prayers")
          .doc(prayerid)
          .collection("Prayed")
          .doc(prayedid)
          .get()
          .then((value) {
        prayerId.value = value.data()!["prayer_id"];
        prayedId.value = value.data()!["prayed_id"];
        whoprayedUid.value = value.data()!["uid"];
        usertoken.value = value.data()!["token"];

        isLoading(false);
        update();
        // print('isLoading after update $isLoading');
      });
    } catch (e) {
      print(e.toString());
    }
  }

///////////////////////answeredprayers
  Future addAnsweredPrayer(
    String prayerid,
    String prayer,
    String time,
    String location,
  ) async {
    try {
      isLoading(true);
      String random = getRandomString(15);
      await FirebaseFirestore.instance
          .collection('AnsweredPrayers')
          .doc(random)
          .set({
        'timestamp': time,
        'profile_image': userDetailController.profileimage.value,
        'prayer': prayer,
        'prayer_id': prayerid.toString(),
        'name': userDetailController.username.value,
        'uid': userDetailController.userUid.value,
        'location': location,
        'id': random,
      }).then((value) => {
                updatePrayerAnswerStatus(prayerid),
              });
      isLoading(false);
      // Get.back();
    } catch (e) {
      isLoading(false);
      print("catch error ${e.toString()}");
    }
  }

////////////people prayed for
  Future prayedfor(
    String prayedfor,
  ) async {
    try {
      isLoading(true);

      await FirebaseFirestore.instance
          .collection('PrayedFor')
          .doc(userDetailController.userUid.value)
          .collection('AllPeople')
          .doc(prayedfor)
          .set({
        'timestamp': DateTime.now().toString(),
        'prayed_for': prayedfor,
      });
      isLoading(false);
      // Get.back();
    } catch (e) {
      isLoading(false);
      print("catch error ${e.toString()}");
    }
  }

//////////update prayer statu

  updatePrayerAnswerStatus(String prayerid) async {
    await FirebaseFirestore.instance
        .collection("Prayers")
        .doc(prayerid)
        .update({
      'answered': true,
    });
  }

////deleteprayer
  deleteprayer(
    String pryaerId,
  ) async {
    await FirebaseFirestore.instance
        .collection("Prayers")
        .doc(pryaerId)
        .delete();

    FirebaseFirestore.instance
        .collection('posts')
        .doc(pryaerId)
        .collection('Prayed')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
    // });
  }

  var distance = 0.0.obs;
///////////calculate distance between 2 points
  calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    print('latilong ${lat1}, ${lon1}, ${lat2}, ${lon2}');
    print('Distance between users ${12742 * asin(sqrt(a))}');
    // distance = 12742 * asin(sqrt(a)) as RxDouble;
    return 12742 * asin(sqrt(a));
  }

/////////////////////nearby
  nearBy() async {
    try {
      isLoading(true);

      await FirebaseFirestore.instance
          .collection('LatLng')
          .doc(userDetailController.userUid.value)
          .set({
        'lat': userDetailController.userslatitude.value,
        'lng': userDetailController.userslongitude.value,
      });
      isLoading(false);
      // Get.back();
    } catch (e) {
      isLoading(false);
      print("catch error ${e.toString()}");
    }
  }
}
