import 'dart:math';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class NotificationController extends GetxController {
///////random number gentaor///////

  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
//////////////////////////////////////////////

  Future<void> setNotification(
    // String id,
    String recieverId,
    String recieverName,
    String recieverImage,
    String recieverDeviceToken,
    String senderId,
    String senderName,
    String senderImage,
    String senderDevicetoken,
    String notifcationType,
    bool tapped,
    String prayername,
    String prayerid,
  ) async {
    String random = getRandomString(15);
    print("before");
    await FirebaseFirestore.instance
        .collection('Notification')
        .doc(random)
        .set({
      'timestamp': DateTime.now().toString(),
      'reciever_id': recieverId,
      'reciever_name': recieverName,
      'reciever_image': recieverImage,
      'reciever_mobile_token': recieverDeviceToken,
      'sender_name': senderName,
      'sender_uid': senderId,
      'sender_image': senderImage,
      'sender_mobile_token': senderDevicetoken,
      'notification_tapped': tapped,
      'notification_type': notifcationType,
      'notification_id': random,
      'prayer_name': prayername,
      'prayer_id': prayerid,
    });
    print('Notification');
  }

  String convertToAgo(String dateTime) {
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
      return '${diff.inDays} day ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours} hour${diff.inHours == 1 ? '' : 's'} ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes} minute${diff.inMinutes == 1 ? '' : 's'} ago';
    } else if (diff.inSeconds >= 1) {
      return '${diff.inSeconds} second${diff.inSeconds == 1 ? '' : 's'} ago';
    } else {
      return 'just now';
    }
  }
}
