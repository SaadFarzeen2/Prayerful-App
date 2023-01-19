import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'Utils/Routes/Routes.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //onclicklistner
}
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // LocalNotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    if (message.notification != null) {
      print('Message data: ${message.data}');
      // notificaationConroller.getsingleUserFromNotification(
      //     message.data['notification_id'].toString());
      print("notification id ${message.data['notification_id'].toString()}");
      // message.data['request_type'].toString() == 'send'

      // ? Get.to(
      //     NotificationSceen(swiperid: message.data['swiper_id'].toString()))
      // : Get.defaultDialog(
      //     title: 'Great News',
      //     content: Obx(() => Container(
      //           child: Column(
      //             children: [
      //               Stack(
      //                 children: [
      //                   Column(
      //                     children: [
      //                       Image.asset(
      //                         AppImages.ANIMATION,
      //                         fit: BoxFit.cover,
      //                       ),
      //                       SizedBox(
      //                         height: Get.height * 0.06,
      //                       )
      //                     ],
      //                   ),
      //                   Positioned(
      //                     bottom: 40,
      //                     left: 10,
      //                     child: Container(
      //                       height: Get.height * 0.20,
      //                       width: Get.width * 0.35,
      //                       decoration: BoxDecoration(
      //                           borderRadius:
      //                               AppBorderRadius.BORDER_RADIUS_15,
      //                           image: DecorationImage(
      //                               image: NetworkImage(connecteduser
      //                                       .senderImage.value ??
      //                                   'https://images.pexels.com/photos/2340978/pexels-photo-2340978.jpeg?auto=compress&cs=tinysrgb&w=1600'),
      //                               fit: BoxFit.cover)),
      //                     ),
      //                   ),
      //                   Positioned(
      //                     bottom: 0,
      //                     left: 170,
      //                     right: 10,
      //                     child: Container(
      //                       height: Get.height * 0.3,
      //                       width: Get.width * 0.4,
      //                       decoration: BoxDecoration(
      //                           borderRadius:
      //                               AppBorderRadius.BORDER_RADIUS_15,
      //                           image: DecorationImage(
      //                               image: NetworkImage(connecteduser
      //                                       .profileimage.value ??
      //                                   'https://images.pexels.com/photos/2773977/pexels-photo-2773977.jpeg?auto=compress&cs=tinysrgb&w=1600'),
      //                               fit: BoxFit.cover)),
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //               SizedBox(
      //                 height: Get.height * 0.01,
      //               ),
      //               AppText(
      //                   text: 'Matched!',
      //                   size: AppDimensions.FONT_SIZE_30,
      //                   color: AppColors.PRIMARY_COLOR,
      //                   fontFamily: Weights.medium),
      //               AppText(
      //                 text: 'You and John are a match',
      //                 size: AppDimensions.FONT_SIZE_18,
      //               ),
      //               SizedBox(
      //                 height: Get.height * 0.02,
      //               ),
      //               AppButton(
      //                   buttonWidth: Get.width,
      //                   buttonRadius: AppBorderRadius.BORDER_RADIUS_15,
      //                   buttonName: 'Say Hello! ',
      //                   buttonColor: AppColors.PRIMARY_COLOR,
      //                   textColor: AppColors.WHITE_COLOR,
      //                   onTap: () {
      //                     chatController.chatroom(
      //                       connecteduser.swipeduseruid.value,
      //                       connecteduser.swipedbyuseruid.value,
      //                       "",
      //                       connecteduser.targetName.value,
      //                       connecteduser.targetImage.value,
      //                       connecteduser.senderName.value,
      //                       connecteduser.senderImage.value,
      //                     );
      //                   }),
      //               SizedBox(
      //                 height: Get.height * 0.01,
      //               ),
      //               AppButton(
      //                   borderColor: AppColors.PRIMARY_COLOR,
      //                   buttonWidth: Get.width,
      //                   buttonRadius: AppBorderRadius.BORDER_RADIUS_15,
      //                   buttonName: 'Keep Exploring ',
      //                   buttonColor: AppColors.TRANSPARENT_COLOR,
      //                   textColor: AppColors.PRIMARY_COLOR,
      //                   onTap: () {
      //                     Get.to(BottomNavBar());
      //                   }),
      //               SizedBox(
      //                 height: Get.height * 0.02,
      //               ),
      //             ],
      //           ),
      //         )),
      //     // matchedPopUp(),
      //   );

      // print(
      //     'Message also contained a notification: ${message.notification.body}');
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'i77',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      getPages: Routes.routes,
    );
  }
}
