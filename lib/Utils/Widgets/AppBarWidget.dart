// ignore_for_file: prefer_const_constructors, must_be_immutable, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Fonts/AppDimensions.dart';
import '../Paddings/AppBorderRadius.dart';
import '../Paddings/AppPaddings.dart';
import '../Themes/AppColors.dart';
import 'AppText.dart';

class SecondaryAppBar extends StatelessWidget {
  double height;
  Color bgColor;
  bool? border;
  Widget? leading;
  Widget? title;
  Widget? subtitle;
  List<Widget> actions;

  SecondaryAppBar({
    Key? key,
    this.height = 100,
    this.bgColor = Colors.transparent,
    this.leading,
    this.title,
    this.subtitle,
    this.actions = const [],
    this.border = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.bottomOnly,
      alignment: Alignment.bottomCenter,
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: bgColor,
        border: border == true
            ? Border(
                bottom: BorderSide(
                  width: 0.5,
                  color: AppColors.GREY_COLOR.withOpacity(0.5),
                ),
              )
            : null,
      ),
      child: Row(
        children: [
          ListTile(
            leading: leading,
            dense: true,
            title: title,
            subtitle: subtitle,
            trailing: SizedBox(
              width: Get.width * 0.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PrimaryAppBar extends StatelessWidget {
  final bool isSubTitle;
  final bool isPrefix;
  final String titleFontFamily;
  final String subTitleFontFamily;
  final bool isDrop;
  final bool isOnSubTitle;
  final bool isSuffix;
  final String subTitle;
  final VoidCallback? dropOnTap;
  final Color prefixIconColor;
  final Color suffixIconColor;
  final Color prefixButtonColor;
  final Color suffixButtonColor;
  final Color dropDownIconColor;
  final String suffixIconImage;
  final String prefixIconImage;
  final String titleText;
  final bool isCenter;
  final double titleSize;
  final double suffixPadding;
  final double prefixPadding;
  double subtitleSize;
  final Color titleColor;
  final Color subtitleColor;
  List<Widget> actions;
  final bool isActions;
  final FontWeight titleFontWeight;
  final FontWeight subtitleFontWeight;
  final VoidCallback? prefixOnTap;
  final VoidCallback? suffixOnTap;
  final bool isDivider;
  final textAlign;

  PrimaryAppBar(
      {Key? key,
      this.suffixIconImage = "",
      this.prefixIconImage = "",
      required this.titleText,
      this.textAlign,
      this.prefixOnTap,
      this.suffixOnTap,
      this.prefixIconColor = Colors.black,
      this.suffixIconColor = Colors.black,
      this.isSubTitle = false,
      this.isDrop = false,
      this.subTitle = "",
      this.actions = const [],
      this.isActions = false,
      this.dropOnTap,
      this.isSuffix = true,
      this.isPrefix = true,
      this.titleSize = 18,
      this.subtitleSize = 18,
      this.titleColor = Colors.black,
      this.subtitleColor = Colors.grey,
      this.titleFontWeight = FontWeight.w400,
      this.subtitleFontWeight = FontWeight.w400,
      this.prefixButtonColor = const Color(0xffE5E5E5),
      this.suffixButtonColor = const Color(0xffE5E5E5),
      this.dropDownIconColor = const Color(0xffE5E5E5),
      this.isDivider = false,
      this.isCenter = true,
      this.titleFontFamily = "Poppins",
      this.subTitleFontFamily = "Poppins",
      this.isOnSubTitle = false,
      this.suffixPadding = 5,
      this.prefixPadding = 5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height / 8.12,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: AppPaddings.vertical,
            child: Row(
              children: [
                isPrefix
                    ? Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.GREY_COLOR.withOpacity(0.8),
                                  spreadRadius: 2,
                                  blurRadius: 7,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              color: AppColors.WHITE_COLOR,
                              shape: BoxShape.circle,
                            ),
                            child: AppCircleImageButton(
                              imageUrl: prefixIconImage,
                              onTap: prefixOnTap ??
                                  () {
                                    Get.back();
                                  },
                              iconColor: prefixIconColor,
                              padding: prefixPadding,
                              buttonColor: prefixButtonColor,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      )
                    : Container(),
                isCenter ? Spacer() : Container(),
                isSubTitle
                    ? GestureDetector(
                        onTap: dropOnTap ?? () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: dropOnTap ?? () {},
                              child: Row(
                                children: [
                                  AppText(
                                      fontFamily: titleFontFamily,
                                      text: titleText,
                                      size: titleSize,
                                      color: titleColor,
                                      fontWeight: titleFontWeight),
                                  isOnSubTitle
                                      ? Container()
                                      : Row(
                                          children: [
                                            SizedBox(width: 100),
                                            Image(
                                              height:
                                                  AppDimensions.FONT_SIZE_15,
                                              color: dropDownIconColor,
                                              image: AssetImage(
                                                'assets/images/back.png',
                                              ),
                                            ),
                                          ],
                                        )
                                ],
                              ),
                            ),
                            // verticalSizedBox(context: context, height: 200),
                            Row(
                              children: [
                                AppText(
                                    fontFamily: subTitleFontFamily,
                                    text: subTitle,
                                    size: subtitleSize,
                                    color: subtitleColor,
                                    fontWeight: subtitleFontWeight),
                                isOnSubTitle
                                    ? Row(
                                        children: [
                                          SizedBox(width: 100),
                                          Image(
                                            height: AppDimensions.FONT_SIZE_15,
                                            color: dropDownIconColor,
                                            image: AssetImage(
                                              'assets/icons/down_arrow.png',
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container()
                              ],
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: AppText(
                            fontFamily: titleFontFamily,
                            text: titleText,
                            size: titleSize,
                            color: titleColor,
                            fontWeight: titleFontWeight),
                      ),
                const Spacer(),
                isSuffix
                    ? CircleAvatar(
                        backgroundColor: AppColors.TRANSPARENT_COLOR,
                      )
                    : isActions
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: actions,
                          )
                        : Container(),
              ],
            ),
          ),
          isDivider
              ? const Divider(
                  height: 0,
                )
              : Container()
        ],
      ),
    );
  }
}

class AppCircleImageButton extends StatelessWidget {
  final Color iconColor;
  final Color buttonColor;
  final double height;
  final double width;
  final double padding;
  final String imageUrl;
  final VoidCallback onTap;

  const AppCircleImageButton(
      {Key? key,
      this.buttonColor = const Color(0xffE5E5E5),
      this.height = 36,
      this.width = 36,
      required this.imageUrl,
      required this.onTap,
      required this.iconColor,
      this.padding = 5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(color: buttonColor, shape: BoxShape.circle),
        child: Padding(
            padding: EdgeInsets.all(padding),
            child: Image(
              image: AssetImage(imageUrl),
              color: iconColor,
            )),
      ),
    );
  }
}
