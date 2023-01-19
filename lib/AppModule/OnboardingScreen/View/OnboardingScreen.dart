import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:i77/AppModule/OnboardingScreen/View/AuthServices.dart';
import 'package:i77/Utils/Fonts/AppDimensions.dart';
import 'package:i77/Utils/Fonts/AppFonts.dart';
import 'package:i77/Utils/Paddings/AppBorderRadius.dart';
import 'package:i77/Utils/Paddings/AppPaddings.dart';
import 'package:i77/Utils/Themes/AppColors.dart';
import 'package:i77/Utils/Widgets/AppText.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Controller/OnboardingController.dart';
import 'package:http/http.dart' as http;

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final userDetailController = Get.put(OnboardingController());

  @override
  void initState() {
    userDetailController.getUserData();
    requestLocationPremission();
    super.initState();
  }

  Future<void> launchUrlStart({required String url}) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: AppPaddings.defaultPadding,
          child:
              // Obx(() {
              //   return

              Column(
            children: [
              SizedBox(
                height: Get.height * 0.07,
              ),
              // Row(
              //   children: [
              //     Flexible(
              //       child: Container(
              //         height: Get.height * 0.005,
              //         width: Get.width,
              //         decoration: BoxDecoration(
              //             color: AppColors.PRIMARY_COLOR,
              //             borderRadius: AppBorderRadius.BORDER_RADIUS_05),
              //       ),
              //     ),
              //     SizedBox(
              //       width: Get.width * 0.03,
              //     ),
              //     Flexible(
              //       child: Container(
              //         height: Get.height * 0.005,
              //         width: Get.width,
              //         decoration: BoxDecoration(
              //             color: onboardingController.isClick.value
              //                 ? AppColors.PRIMARY_COLOR
              //                 : AppColors.GREY_COLOR,
              //             borderRadius: AppBorderRadius.BORDER_RADIUS_05),
              //       ),
              //     ),
              //   ],
              // ),
              // onboardingController.isClick.isTrue
              //     ?
              Column(
                children: [
                  SizedBox(
                    height: Get.height * 0.2,
                  ),
                  Image.asset(
                    'assets/images/prayrful.png',
                    color: AppColors.PRIMARY_COLOR,
                    scale: 2.5,
                  ),
                  SizedBox(
                    height: Get.height * 0.2,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Get.to(BottomNavigation());
                      AuthService().signInWithGoogle();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: AppColors.PRIMARY_COLOR,
                          borderRadius: AppBorderRadius.BORDER_RADIUS_10),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: AppColors.WHITE_COLOR,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Image.asset('assets/images/go.png'),
                              ),
                            ),
                            SizedBox(
                              width: Get.width * 0.02,
                            ),
                            AppText(
                                text: 'Login with Google',
                                color: AppColors.WHITE_COLOR,
                                size: AppDimensions.FONT_SIZE_18),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  AppText(
                      textAlign: TextAlign.center,
                      text: 'By using this app, you agree to the ',
                      size: AppDimensions.FONT_SIZE_16,
                      fontFamily: Weights.light),
                  GestureDetector(
                    onTap: () {
                      launchUrlStart(
                          url:
                              "https://prayrful.notion.site/Terms-and-Conditions-66588ee7f6f04848ad4fda2939651d06");
                    },
                    child: AppText(
                      textAlign: TextAlign.center,
                      text: 'terms and conditions.',
                      size: AppDimensions.FONT_SIZE_16,
                      color: AppColors.PRIMARY_COLOR,
                      fontFamily: Weights.light,
                      underLine: TextDecoration.underline,
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.04,
                  ),
                ],
              )
              // : Column(
              //     children: [
              //       SizedBox(
              //         height: Get.height * 0.6,
              //       ),
              //       SizedBox(
              //         width: Get.width / 2,
              //         child: AppText(
              //           textAlign: TextAlign.center,
              //           text: 'Get you to pray with other people',
              //           size: AppDimensions.FONT_SIZE_22,
              //         ),
              //       ),
              //       SizedBox(
              //         height: Get.height * 0.04,
              //       ),
              //       AppText(
              //           textAlign: TextAlign.center,
              //           text:
              //               'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla magna semper.',
              //           size: AppDimensions.FONT_SIZE_18,
              //           fontFamily: Weights.light),
              //       SizedBox(
              //         height: Get.height * 0.04,
              //       ),
              //       AppButton(
              //           buttonWidth: Get.width,
              //           buttonRadius: AppBorderRadius.BORDER_RADIUS_10,
              //           buttonName: 'Next',
              //           textSize: AppDimensions.FONT_SIZE_18,
              //           buttonColor: AppColors.PRIMARY_COLOR,
              //           textColor: AppColors.WHITE_COLOR,
              //           onTap: () {
              //             onboardingController.changeStatus();
              //           }),
              //     ],
              //   ),
            ],
          )

          // }),
          ),
    );
  }

  void requestLocationPremission() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      print('Premission is Granted');
    } else if (status.isDenied) {
      if (await Permission.location.request().isGranted) {
        print('Premission is Granted');
      }
    }
  }
}
