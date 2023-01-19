import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:i77/AppModule/AddFriends/View/AddFriends.dart';
import 'package:i77/AppModule/NotificationScreen/Controller/notification_controller.dart';
import 'package:i77/Services/FCM/sendPushMessage.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:i77/AppModule/AddPrayer/controller/add_prayer_controller.dart';
import 'package:i77/AppModule/OnboardingScreen/Controller/OnboardingController.dart';
import 'package:i77/Utils/Fonts/AppFonts.dart';
import 'package:i77/Utils/Paddings/AppPaddings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Utils/Fonts/AppDimensions.dart';
import '../../../Utils/Paddings/AppBorderRadius.dart';
import '../../../Utils/Themes/AppColors.dart';
import '../../../Utils/Widgets/AppBarWidget.dart';
import '../../../Utils/Widgets/AppText.dart';
import '../../BottomNavigation/View/BottomNavigation.dart';

final userDetailController = Get.put(OnboardingController());
final addPrayerController = Get.put(AddPrayerController());

class MyPrayer extends StatefulWidget {
  MyPrayer({Key? key}) : super(key: key);

  @override
  State<MyPrayer> createState() => _MyPrayerState();
}

class _MyPrayerState extends State<MyPrayer> {
  final myPrayersController = Get.put(MyPrayersController());

  @override
  void initState() {
    userDetailController.getUserData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: AppPaddings.horizontal,
        child: Column(
          children: [
            PrimaryAppBar(
              titleText: 'My Prayer',
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
            Container(
              decoration: BoxDecoration(
                  color: AppColors.PRIMARY_COLOR.withOpacity(0.2),
                  borderRadius: AppBorderRadius.BORDER_RADIUS_25),
              child: Obx(() {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          myPrayersController.updateTab(0);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: !(myPrayersController.tab.value == 0)
                                  ? AppColors.TRANSPARENT_COLOR
                                  : AppColors.PRIMARY_COLOR,
                              borderRadius: AppBorderRadius.BORDER_RADIUS_25),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Get.height * 0.016,
                                horizontal: Get.width * 0.06),
                            child: AppText(
                                fontFamily: Weights.medium,
                                textAlign: TextAlign.center,
                                text: 'Prayer\nRequests',
                                size: AppDimensions.FONT_SIZE_16,
                                color: !(myPrayersController.tab.value == 0)
                                    ? AppColors.BLACK_COLOR
                                    : AppColors.WHITE_COLOR),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          myPrayersController.updateTab(1);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: !(myPrayersController.tab.value == 1)
                                  ? AppColors.TRANSPARENT_COLOR
                                  : AppColors.PRIMARY_COLOR,
                              borderRadius: AppBorderRadius.BORDER_RADIUS_25),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: Get.height * 0.016,
                                horizontal: Get.width * 0.05),
                            child: AppText(
                                fontFamily: Weights.medium,
                                textAlign: TextAlign.center,
                                text: 'Answered Prayers',
                                size: AppDimensions.FONT_SIZE_16,
                                color: !(myPrayersController.tab.value == 1)
                                    ? AppColors.BLACK_COLOR
                                    : AppColors.WHITE_COLOR),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Obx(() {
              return myPrayersController.tab.value == 0
                  ? Column(
                      children: [PrayerWidget()],
                    )
                  : Column(
                      children: [MyAnswerPrayerWidget()],
                    );
            }),
          ],
        ),
      ),
    );
  }
}

class MyPrayersController extends GetxController {
  var tab = 0.obs;

  updateTab(val) {
    tab.value = val;
    update();
  }
}

class PrayerWidget extends StatefulWidget {
  PrayerWidget({super.key});

  @override
  State<PrayerWidget> createState() => _PrayerWidgetState();
}

class _PrayerWidgetState extends State<PrayerWidget> {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  String? _linkMessage;
  String kUriPrefix = 'https://prayrful.page.link';
  bool _isCreatingLink = false;
  final pushNotification = Get.put(PushNotification());
  final setNotification = Get.put(NotificationController());
  @override
  void initState() {
    initDynamicLinks();
    super.initState();
  }

  List pPrayed = [];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Prayers')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasError) {
            return Text('Something went wrong');
          }
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Loading"));
          }
          return Container(
            width: Get.width,
            height: Get.height * .68,
            child: ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                SlidableAction(
                                  spacing: 8,
                                  onPressed: ((context) {
                                    addPrayerController.prayedOnPrayers(
                                        streamSnapshot.data!.docs[index]['id']);
                                  }),
                                  icon: FontAwesomeIcons.handsPraying,
                                  label: 'Prayed',
                                  backgroundColor: AppColors.PRIMARY_COLOR,
                                ),
                                SlidableAction(
                                  spacing: 8,
                                  onPressed: ((context) async {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    addPrayerController.updateAnswerStatus(
                                        streamSnapshot.data!.docs[index]['id']);

                                    for (var i = 0; i < pPrayed.length; i++) {
                                      print("pPrayed :${pPrayed.length}");
                                      if (pPrayed[i]['token'].isNotEmpty &&
                                          pPrayed[i]['uid'] !=
                                              userDetailController
                                                  .userUid.value) {
                                        pushNotification.sendPushMessage(
                                          '${userDetailController.username.value} Prayer was Answered',
                                          "",
                                          pPrayed[i]['token'],
                                          userDetailController.userUid.value,
                                          '',
                                          'send',
                                        );
                                        //////////////set notification////////////
                                        setNotification.setNotification(
                                          pPrayed[i]['uid'],
                                          pPrayed[i]['name'],
                                          pPrayed[i]['profile_image'],
                                          pPrayed[i]['token'],
                                          userDetailController.userUid.value,
                                          userDetailController.username.value,
                                          userDetailController
                                              .profileimage.value,
                                          userDetailController.token.value,
                                          'Answered',
                                          false,
                                          addPrayerController
                                              .prayerDesController.text,
                                          prefs.getString('postid').toString(),
                                        );
                                      }
                                    }
                                  }),
                                  icon: FontAwesomeIcons.rainbow,
                                  label: 'Answered',
                                  backgroundColor: AppColors.BLACK_COLOR,
                                ),
                                SlidableAction(
                                  spacing: 8,
                                  onPressed: ((context) {
                                    addPrayerController.deleteprayer(
                                        streamSnapshot.data!.docs[index]['id']);
                                    showSnackBar(context, 'Prayer Deleted');
                                  }),
                                  icon: Icons.delete,
                                  label: 'Delete',
                                  backgroundColor: AppColors.RED_COLOR,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      child: streamSnapshot.data!.docs[index]['answered'] ==
                                  false &&
                              streamSnapshot.data!.docs[index]['uid'] ==
                                  userDetailController.userUid.value
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius:
                                        AppBorderRadius.BORDER_RADIUS_10,
                                    color: AppColors.WHITE_COLOR,
                                    boxShadow: [
                                      BoxShadow(
                                          color: AppColors.GREY_COLOR
                                              .withOpacity(.2),
                                          spreadRadius: 10,
                                          blurRadius: 10)
                                    ]),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            radius: 25,
                                            backgroundColor:
                                                AppColors.PRIMARY_COLOR,
                                            backgroundImage: NetworkImage(
                                                streamSnapshot.data!.docs[index]
                                                        ['profile_image'] ??
                                                    'https://images.pexels.com/photos/7594466/pexels-photo-7594466.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load'),
                                          ),
                                          SizedBox(width: Get.width * 0.03),
                                          Flexible(
                                            child: AppText(
                                                size:
                                                    AppDimensions.FONT_SIZE_14,
                                                color: AppColors.BLACK_COLOR,
                                                text: streamSnapshot
                                                            .data!.docs[index]
                                                        ['prayer'] ??
                                                    'teLorem ipsum dolor sit amectetur adipiscing elit. Orem ipsum dolorsit amet, consectetu'),
                                          )
                                        ],
                                      ),
                                      // SizedBox(
                                      //   height: Get.height * 0.02,
                                      // ),
                                      StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('Prayer_types')
                                              .where("prayername",
                                                  isEqualTo: streamSnapshot
                                                      .data!
                                                      .docs[index]['prayer'])
                                              .where("prayerimage",
                                                  isEqualTo: streamSnapshot
                                                          .data!.docs[index]
                                                      ['profile_image'])
                                              .snapshots(),
                                          // stream: FirebaseFirestore.instance
                                          //     .collection('AddFreind')
                                          //     .doc(userDetailController.userUid.value)
                                          //     .collection('AllFriends')
                                          //     .snapshots(),
                                          builder: (context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (snapshot.hasError) {
                                              return Text(
                                                  'Something went wrong');
                                            }
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                  child: Text("Loading.."));
                                            }
                                            // setState(() {
                                            //   totalpraying = snapshot.data!.docs.length;
                                            // });
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                for (int i = 0;
                                                    i <
                                                        snapshot
                                                            .data!.docs.length;
                                                    i++) ...{
                                                  Align(
                                                      widthFactor: 0.6,
                                                      child: snapshot.data!
                                                                      .docs[i][
                                                                  'UserImagelist'] !=
                                                              ''
                                                          ? CircleAvatar(
                                                              radius: 18,
                                                              backgroundImage:
                                                                  NetworkImage(snapshot
                                                                          .data!
                                                                          .docs[i]
                                                                      [
                                                                      'UserImagelist']),
                                                            )
                                                          : null),
                                                },
                                                SizedBox(
                                                  width: Get.width * 0.03,
                                                ),
                                                snapshot.data!.docs.length == 0
                                                    ? Container()
                                                    : Text(
                                                        "${snapshot.data!.docs.length}" +
                                                            " praying",
                                                        style: TextStyle(
                                                            color: AppColors
                                                                .BLACK_COLOR,
                                                            fontFamily:
                                                                Weights.bold,
                                                            fontSize: 14),
                                                      )
                                              ],
                                            );
                                          }),
                                      SizedBox(
                                        height: Get.height * 0.02,
                                      ),
                                      StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('Prayers')
                                              .doc(streamSnapshot
                                                  .data!.docs[index]['id'])
                                              .collection('Prayed')
                                              .orderBy('timestamp',
                                                  descending: true)
                                              .snapshots(),
                                          builder: (context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snap) {
                                            if (snap.hasError) {
                                              return Text(
                                                  'Something went wrong');
                                            }
                                            if (snap.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                  child: Text("Loading"));
                                            }
                                            for (var i = 0;
                                                i < snap.data!.docs.length;
                                                i++) {
                                              pPrayed.add(
                                                snap.data!.docs[i],
                                              );
                                            }
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                for (int i = 0;
                                                    i < snap.data!.docs.length;
                                                    i++) ...{
                                                  Align(
                                                    widthFactor: 0.6,
                                                    child: snap.data!.docs[i][
                                                                'profile_image'] !=
                                                            ''
                                                        ? CircleAvatar(
                                                            backgroundColor:
                                                                AppColors
                                                                    .TRANSPARENT_COLOR,
                                                            radius: 18,
                                                            backgroundImage:
                                                                NetworkImage(snap
                                                                            .data!
                                                                            .docs[i]
                                                                        [
                                                                        'profile_image'] ??
                                                                    ''),
                                                          )
                                                        : null,
                                                  ),
                                                },

                                                SizedBox(
                                                  width: Get.width * 0.03,
                                                ),
                                                snap.data!.docs.length > 0
                                                    ? AppText(
                                                        text:
                                                            '${snap.data!.docs.length} Prayed',
                                                        color: AppColors
                                                            .BLACK_COLOR,
                                                        fontFamily:
                                                            Weights.bold,
                                                        size: AppDimensions
                                                            .FONT_SIZE_14)
                                                    : AppText(
                                                        text: '',
                                                        color: AppColors
                                                            .BLACK_COLOR,
                                                        fontFamily:
                                                            Weights.bold,
                                                        size: AppDimensions
                                                            .FONT_SIZE_14),
                                                // Row(
                                                //   mainAxisAlignment:
                                                //       MainAxisAlignment.end,
                                                //   children: [
                                                //     Text(
                                                //         "${snap.data!.docs.length + 1} Praying"),
                                                //   ],
                                                // ),
                                              ],
                                            );
                                          }),
                                      SizedBox(
                                        height: Get.height * 0.02,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          AppText(
                                              text:
                                                  "${streamSnapshot.data!.docs[index]['timestamp'].substring(0, 10)} | ${DateFormat('hh:mm a').format(DateTime.parse(streamSnapshot.data!.docs[index]['timestamp']))}",
                                              color: AppColors.BLACK_COLOR,
                                              fontFamily: Weights.medium,
                                              size: AppDimensions.FONT_SIZE_12),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                color: AppColors.PRIMARY_COLOR,
                                                size: 14,
                                              ),
                                              SizedBox(
                                                width: Get.width * 0.01,
                                              ),
                                              AppText(
                                                  text: streamSnapshot
                                                              .data!.docs[index]
                                                          ['location'] ??
                                                      ' bakistan',
                                                  color: AppColors.BLACK_COLOR,
                                                  fontFamily: Weights.medium,
                                                  size: AppDimensions
                                                      .FONT_SIZE_12),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.share_rounded,
                                                size: 14,
                                                color: AppColors.PRIMARY_COLOR,
                                              ),
                                              SizedBox(
                                                width: Get.width * 0.01,
                                              ),
                                              GestureDetector(
                                                onTap: () => _createDynamicLink(
                                                    true, '/myPrayer'),
                                                child: AppText(
                                                    text: 'Share',
                                                    color:
                                                        AppColors.BLACK_COLOR,
                                                    fontFamily: Weights.medium,
                                                    size: AppDimensions
                                                        .FONT_SIZE_12),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container());
                }),
          );
        });
  }

  Future<void> share() async {
    await FlutterShare.share(
      title: 'i77 Prayer ',
      text: 'Pray for me',
      linkUrl: _linkMessage,
    );
  }

  Future<void> initDynamicLinks() async {
    print("initlization");
    dynamicLinks.onLink.listen((dynamicLinkData) {
      print("dyna,ic link");
      final Uri uri = dynamicLinkData.link;

      print('dynamic link path: ${dynamicLinkData.link.path}');
      print('dynamic link path: ${dynamicLinkData.link}');
      Navigator.pushNamed(context, dynamicLinkData.link.path);
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });
    try {
      PendingDynamicLinkData? data =
          await FirebaseDynamicLinks.instance.getInitialLink();

      Uri deeplink = data!.link;
      if (deeplink != null) {
        Navigator.pushNamed(context, data.link.path);
      }
    } catch (e) {}
  }

  Future<void> _createDynamicLink(bool short, String link) async {
    setState(() {
      _isCreatingLink = true;
    });

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: kUriPrefix,
      link: Uri.parse(kUriPrefix + link),
      androidParameters: AndroidParameters(
        fallbackUrl: Uri.tryParse('your app store link'),
        packageName: 'com.example.prayrful',
        minimumVersion: 0,
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink =
          await dynamicLinks.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      url = await dynamicLinks.buildLink(parameters);
    }

    setState(() {
      _linkMessage = url.toString();
      _isCreatingLink = false;
    });
    share();
  }
}

//////////////////////////////////////////////
class MyAnswerPrayerWidget extends StatefulWidget {
  MyAnswerPrayerWidget({super.key});

  @override
  State<MyAnswerPrayerWidget> createState() => _MyAnswerPrayerWidgetState();
}

class _MyAnswerPrayerWidgetState extends State<MyAnswerPrayerWidget> {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  String? _linkMessage;
  String kUriPrefix = 'https://prayrful.page.link';
  bool _isCreatingLink = false;

  @override
  void initState() {
    initDynamicLinks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Prayers')
            // .where('answered', isEqualTo: true)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasError) {
            return Text('Something went wrong');
          }
          if (streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Loading"));
          }
          return Container(
            width: Get.width,
            height: Get.height * .68,
            child: ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Slidable(
                    child: streamSnapshot.data!.docs[index]['uid'] ==
                                userDetailController.userUid.value &&
                            streamSnapshot.data!.docs[index]['answered'] == true
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius:
                                      AppBorderRadius.BORDER_RADIUS_10,
                                  color: AppColors.PRIMARY_COLOR,
                                  boxShadow: [
                                    BoxShadow(
                                        color: AppColors.GREY_COLOR
                                            .withOpacity(.2),
                                        spreadRadius: 10,
                                        blurRadius: 10)
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 25,
                                          backgroundColor:
                                              AppColors.PRIMARY_COLOR,
                                          backgroundImage: NetworkImage(
                                              streamSnapshot.data!.docs[index]
                                                      ['profile_image'] ??
                                                  'https://images.pexels.com/photos/7594466/pexels-photo-7594466.jpeg?auto=compress&cs=tinysrgb&w=1600&lazy=load'),
                                        ),
                                        SizedBox(width: Get.width * 0.03),
                                        Flexible(
                                          child: AppText(
                                              size: AppDimensions.FONT_SIZE_14,
                                              color: AppColors.WHITE_COLOR,
                                              text: streamSnapshot.data!
                                                      .docs[index]['prayer'] ??
                                                  'teLorem ipsum dolor sit amectetur adipiscing elit. Orem ipsum dolorsit amet, consectetu'),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: Get.height * 0.02,
                                    ),
                                    StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('Prayers')
                                            .doc(streamSnapshot
                                                .data!.docs[index]['id'])
                                            .collection('Prayed')
                                            .orderBy('timestamp',
                                                descending: true)
                                            .snapshots(),
                                        builder: (context,
                                            AsyncSnapshot<QuerySnapshot> snap) {
                                          if (snap.hasError) {
                                            return Text('Something went wrong');
                                          }
                                          if (snap.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                                child: Text("Loading"));
                                          }
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              for (int i = 0;
                                                  i < snap.data!.docs.length;
                                                  i++) ...{
                                                Align(
                                                  widthFactor: 0.6,
                                                  child: snap.data!.docs[i][
                                                              'profile_image'] !=
                                                          ''
                                                      ? CircleAvatar(
                                                          backgroundColor: AppColors
                                                              .TRANSPARENT_COLOR,
                                                          radius: 18,
                                                          backgroundImage:
                                                              NetworkImage(snap
                                                                          .data!
                                                                          .docs[i]
                                                                      [
                                                                      'profile_image'] ??
                                                                  ''),
                                                        )
                                                      : null,
                                                ),
                                              },
                                              SizedBox(
                                                width: Get.width * 0.03,
                                              ),
                                              snap.data!.docs.length > 0
                                                  ? AppText(
                                                      text:
                                                          '${snap.data!.docs.length} Prayed',
                                                      color:
                                                          AppColors.WHITE_COLOR,
                                                      fontFamily: Weights.bold,
                                                      size: AppDimensions
                                                          .FONT_SIZE_14)
                                                  : AppText(
                                                      text: '',
                                                      color:
                                                          AppColors.BLACK_COLOR,
                                                      fontFamily: Weights.bold,
                                                      size: AppDimensions
                                                          .FONT_SIZE_14),
                                            ],
                                          );
                                        }),
                                    SizedBox(
                                      height: Get.height * 0.02,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        AppText(
                                            text:
                                                "${streamSnapshot.data!.docs[index]['timestamp'].substring(0, 10)} | ${DateFormat('hh:mm a').format(DateTime.parse(streamSnapshot.data!.docs[index]['timestamp']))}",
                                            color: AppColors.WHITE_COLOR,
                                            fontFamily: Weights.medium,
                                            size: AppDimensions.FONT_SIZE_12),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              color: AppColors.WHITE_COLOR,
                                              size: 14,
                                            ),
                                            SizedBox(
                                              width: Get.width * 0.01,
                                            ),
                                            AppText(
                                                text: streamSnapshot
                                                            .data!.docs[index]
                                                        ['location'] ??
                                                    ' indo',
                                                color: AppColors.WHITE_COLOR,
                                                fontFamily: Weights.medium,
                                                size:
                                                    AppDimensions.FONT_SIZE_12),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.share_rounded,
                                              size: 14,
                                              color: AppColors.WHITE_COLOR,
                                            ),
                                            SizedBox(
                                              width: Get.width * 0.01,
                                            ),
                                            GestureDetector(
                                              onTap: () => _createDynamicLink(
                                                  true, '/seeAllPrayers'),
                                              child: AppText(
                                                  text: 'Share',
                                                  color: AppColors.WHITE_COLOR,
                                                  fontFamily: Weights.medium,
                                                  size: AppDimensions
                                                      .FONT_SIZE_12),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  );
                }),
          );
        });
  }

  Future<void> share() async {
    await FlutterShare.share(
      title: 'i77 Prayer ',
      text: 'My Answered Prayers',
      linkUrl: _linkMessage,
    );
  }

  Future<void> initDynamicLinks() async {
    print("initlization");
    dynamicLinks.onLink.listen((dynamicLinkData) {
      print("dyna,ic link");
      final Uri uri = dynamicLinkData.link;

      print('dynamic link path: ${dynamicLinkData.link.path}');
      print('dynamic link path: ${dynamicLinkData.link}');
      Navigator.pushNamed(context, dynamicLinkData.link.path);
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });
    try {
      PendingDynamicLinkData? data =
          await FirebaseDynamicLinks.instance.getInitialLink();

      Uri deeplink = data!.link;
      if (deeplink != null) {
        Navigator.pushNamed(context, data.link.path);
      }
    } catch (e) {}
  }

  Future<void> _createDynamicLink(bool short, String link) async {
    setState(() {
      _isCreatingLink = true;
    });

    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: kUriPrefix,
      link: Uri.parse(kUriPrefix + link),
      androidParameters: AndroidParameters(
        fallbackUrl: Uri.tryParse('your app store link'),
        packageName: 'com.example.prayrful',
        minimumVersion: 0,
      ),
    );

    Uri url;
    if (short) {
      final ShortDynamicLink shortLink =
          await dynamicLinks.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      url = await dynamicLinks.buildLink(parameters);
    }

    setState(() {
      _linkMessage = url.toString();
      _isCreatingLink = false;
    });
    share();
  }
}
