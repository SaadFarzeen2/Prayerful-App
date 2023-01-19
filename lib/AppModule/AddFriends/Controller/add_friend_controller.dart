// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:i77/AppModule/OnboardingScreen/Controller/OnboardingController.dart';

class AddFriendsController extends GetxController implements GetxService {
  var time = ''.obs;
  var isLoading = false.obs;
  var isClick = [].obs;
  RxList<dynamic> friendsList2 = [].obs;
  var friendsList3 = [].obs;
  final userDetailController = Get.put(OnboardingController());

  addFreinds(
      String image, String addedusernme, String addeduid, String token) async {
    try {
      isLoading(true);

      await FirebaseFirestore.instance
          .collection('AddFreind')
          .doc(userDetailController.userUid.value)
          .collection("AllFriends")
          .doc(addeduid)
          .set({
        'timestamp': DateTime.now().toString(),
        'profile_image': image,
        "user_added_id": addeduid,
        'name': addedusernme,
        'token': token,
        'current_uid': userDetailController.userUid.value,
      }).then((value) => {});
      isLoading(false);
      // Get.back();
    } catch (e) {
      isLoading(false);
      print("catch error ${e.toString()}");
    }
  }

  removeFreinds(String addeduid) async {
    try {
      isLoading(true);

      await FirebaseFirestore.instance
          .collection('AddFreind')
          .doc(userDetailController.userUid.value)
          .collection('AllFriends')
          .doc(addeduid)
          .delete();
      isLoading(false);
      // Get.back();
    } catch (e) {
      isLoading(false);
      print("catch error ${e.toString()}");
    }
  }

  removefriendafterposting() async {
    await FirebaseFirestore.instance
        .collection("AddFreind")
        .doc(userDetailController.userUid.value)
        .delete();

    FirebaseFirestore.instance
        .collection('AddFreind')
        .doc(userDetailController.userUid.value)
        .collection('AllFriends')
        .get()
        .then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }

  //////get Friend
  getFriendsData() async {
    try {
      isLoading(true);
      print('isLoading $isLoading');

      await FirebaseFirestore.instance
          .collection("Friends")
          .doc("PrayerFriends")
          .get()
          .then((value) {
        time.value = value.data()!["timestamp"];
        friendsList2.value = value.data()!["friends_list"];

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

  //////////

  convertToAgo(String dateTime) {
    DateTime input = DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime);
    Duration diff = DateTime.now().difference(input);

    print("Diffrence: $diff");
    print("Diffrence:: ${diff.inDays}");
    print("Diffrence: ${diff.inHours}");
    print("Diffrence: ${diff.inMinutes}");
    print("Diffrence: ${diff.inSeconds}");
    print("input: $input");
    print("now: ${DateTime.now()}");

    if (diff.inDays == 1) {
      return diff.inDays;
    } else if (diff.inHours >= 1) {
      return diff.inHours;
    } else if (diff.inMinutes >= 1) {
      return diff.inMinutes;
    } else if (diff.inSeconds >= 1) {
      return diff.inSeconds;
    }
  }

  // String convertToAgo(String dateTime) {
  //   DateTime input = DateFormat('yyyy-MM-dd HH:mm:ss').parse(dateTime);
  //   Duration diff = DateTime.now().difference(input);

  //   print("Diffrence: $diff");
  //   print("Diffrence:: ${diff.inDays}");
  //   print("Diffrence: ${diff.inHours}");
  //   print("Diffrence: ${diff.inMinutes}");
  //   print("Diffrence: ${diff.inSeconds}");
  //   print("input: $input");
  //   print("now: ${DateTime.now()}");

  //   if (diff.inDays == 1) {
  //     return '${diff.inDays} day ago';
  //   } else if (diff.inHours >= 1) {
  //     return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
  //   } else if (diff.inMinutes >= 1) {
  //     return '${diff.inMinutes} minute${diff.inMinutes == 1 ? '' : 's'} ago';
  //   } else if (diff.inSeconds >= 1) {
  //     return '${diff.inSeconds} second${diff.inSeconds == 1 ? '' : 's'} ago';
  //   } else {
  //     return 'just now';
  //   }
  // }
}

class AddFriendModel {
  String? image;
  String? uid;
  AddFriendModel({
    this.image,
    this.uid,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'image': image,
      'uid': uid,
    };
  }
}
