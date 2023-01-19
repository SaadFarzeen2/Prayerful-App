import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:i77/AppModule/AddFriends/Controller/add_friend_controller.dart';
import 'package:i77/AppModule/OnboardingScreen/Controller/OnboardingController.dart';
import 'package:i77/Utils/Paddings/AppPaddings.dart';
import 'package:i77/Utils/Widgets/AppButton.dart';

import '../../../Utils/Fonts/AppDimensions.dart';
import '../../../Utils/Fonts/AppFonts.dart';
import '../../../Utils/Paddings/AppBorderRadius.dart';
import '../../../Utils/Themes/AppColors.dart';
import '../../../Utils/Widgets/AppBarWidget.dart';
import '../../../Utils/Widgets/AppText.dart';

class AddFriendsScreen extends StatefulWidget {
  AddFriendsScreen({Key? key}) : super(key: key);

  @override
  State<AddFriendsScreen> createState() => _AddFriendsScreenState();
}

class _AddFriendsScreenState extends State<AddFriendsScreen> {
  final addFriendsController = Get.put(AddFriendsController());

  final userDetailController = Get.put(OnboardingController());
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  String? _linkMessage;
  String kUriPrefix = 'https://prayrful.page.link';
  bool _isCreatingLink = false;

  @override
  void initState() {
    addFriendsController.getFriendsData();
    userDetailController.getUserData();
    initDynamicLinks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddFriendsController>(builder: (addFriendsController) {
      return Scaffold(
        body: Padding(
          padding: AppPaddings.horizontal,
          child: Column(
            children: [
              PrimaryAppBar(
                titleText: 'Add Friends',
                prefixButtonColor: AppColors.WHITE_COLOR,
                prefixPadding: 10,
                prefixIconImage: 'assets/images/Back.png',
                titleSize: AppDimensions.FONT_SIZE_20,
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              GestureDetector(
                onTap: () {
                  _createDynamicLink(true, '/addFriendsScreen');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.share_rounded,
                      size: 16,
                      color: AppColors.BLACK_COLOR.withOpacity(.7),
                    ),
                    SizedBox(
                      width: Get.width * 0.03,
                    ),
                    AppText(
                        text: 'Share with more friends',
                        color: AppColors.BLACK_COLOR,
                        fontFamily: Weights.medium,
                        size: AppDimensions.FONT_SIZE_14),
                  ],
                ),
              ),
              SizedBox(
                height: Get.height * 0.02,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Text("Loading"));
                    }
                    return ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return snapshot.data!.docs[index]['user_uid'] ==
                                  userDetailController.userUid.value
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 17.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 25,
                                        backgroundColor:
                                            AppColors.PRIMARY_COLOR,
                                        backgroundImage: NetworkImage(snapshot
                                            .data!
                                            .docs[index]['profile_image']),
                                      ),
                                      SizedBox(
                                        width: Get.width * 0.03,
                                      ),
                                      AppText(
                                          text: snapshot.data!.docs[index]
                                              ['user_name'],
                                          size: AppDimensions.FONT_SIZE_16,
                                          fontFamily: Weights.bold),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          if (addFriendsController.isClick
                                              .contains(index)) {
                                            addFriendsController.isClick
                                                .remove(index);
                                            addFriendsController.removeFreinds(
                                                snapshot.data!.docs[index]
                                                    ['user_uid']);
                                          } else {
                                            addFriendsController.isClick
                                                .add(index);
                                            addFriendsController.addFreinds(
                                              snapshot.data!.docs[index]
                                                  ['profile_image'],
                                              snapshot.data!.docs[index]
                                                  ['user_name'],
                                              snapshot.data!.docs[index]
                                                  ['user_uid'],
                                              snapshot.data!.docs[index]
                                                  ['token'],
                                            );
                                          }
                                        },
                                        child: Obx(() {
                                          return Container(
                                            width: Get.width * 0.25,
                                            decoration: BoxDecoration(
                                                borderRadius: AppBorderRadius
                                                    .BORDER_RADIUS_30,
                                                color: addFriendsController
                                                        .isClick
                                                        .contains(index)
                                                    ? AppColors.PRIMARY_COLOR
                                                    : AppColors.WHITE_COLOR,
                                                border: Border.all(
                                                    color: AppColors
                                                        .PRIMARY_COLOR)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Center(
                                                child: AppText(
                                                    text: addFriendsController
                                                            .isClick
                                                            .contains(index)
                                                        ? 'Remove'
                                                        : 'Add',
                                                    color: addFriendsController
                                                            .isClick
                                                            .contains(index)
                                                        ? AppColors.WHITE_COLOR
                                                        : AppColors
                                                            .PRIMARY_COLOR,
                                                    size: AppDimensions
                                                        .FONT_SIZE_14,
                                                    fontFamily: Weights.medium),
                                              ),
                                            ),
                                          );
                                        }),
                                      )
                                    ],
                                  ),
                                );
                        });
                  }),
            ],
          ),
        ),
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

void showSnackBar(BuildContext context, String text) {
  final snackbar = SnackBar(
    content: AppText(
      text: text,
      color: AppColors.WHITE_COLOR,
    ),
    margin: EdgeInsets.all(10),
    behavior: SnackBarBehavior.floating,
    backgroundColor: AppColors.PRIMARY_COLOR,
    duration: Duration(seconds: 3),
    shape: RoundedRectangleBorder(
      borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
    ),
  );

  ScaffoldMessenger.of(context)..showSnackBar(snackbar);
}
