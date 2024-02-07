import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prosto_doc/core/helpers/colors.dart';
import 'package:prosto_doc/core/helpers/custom_button.dart';
import 'package:prosto_doc/core/helpers/images.dart';

class CustomScaffoldCategories extends StatelessWidget {
  final Widget body;
  Color? backgroundColor;
  final Widget? secondBody;
  final Function()? onPressDone;
  bool small;
  bool main;
  bool isScroll;
  CustomScaffoldCategories({
    super.key,
    required this.body,
    this.onPressDone,
    this.backgroundColor = const Color.fromRGBO(78, 130, 234, 1),
    this.secondBody,
    this.main = false,
    this.small = false,
    this.isScroll = false,
  });

  @override
  Widget build(BuildContext context) {
    return mainBody(context);
  }

  Widget mainBody(BuildContext context) {
    // print(backgroundColor);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: small ? -150.w : -50.w,
            left: -10,
            right: -10,
            child: SvgPicture.asset(
              'assets/icons/background_beranda.svg',
              // height: 397.52.h,
              fit: BoxFit.fitHeight,
              color: backgroundColor ?? const Color.fromRGBO(78, 130, 234, 1),
              width: MediaQuery.of(context).size.width,
            ),
          ),
          Image.asset(
            'assets/images/background_berand.png',
            height: 397.52.h,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          Padding(
            padding: EdgeInsets.only(
                top: main ? 76.h : 132.h, left: main ? 139.w : 101.w),
            child: AppImages(
              height: main ? 88.h : 157.81.h,
              width: main ? 78.w : 143.w,
            ).assetImage(
              'assets/images/logo.png',
            ),
          ),
          if (secondBody != null)
            Container(
              height: MediaQuery.of(context).size.height,
              margin: EdgeInsets.only(top: 200.h),
              child: secondBody!,
            ),
          Column(
            children: [
              Flexible(
                child: Container(
                  margin: EdgeInsets.only(
                    top: main ? 143.h : 266.h,
                    left: 21.w,
                    right: 21.w,
                    bottom: kBottomNavigationBarHeight + 40,
                  ),
                  // padding: EdgeInsets.symmetric(horizontal: 21),
                  // width: 348.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(48, 48, 48, 0.05),
                        offset: const Offset(0, 8),
                        blurRadius: 16.r,
                      )
                    ],
                  ),
                  child: body,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(
                top: main ? 121.h : 212.5.h, left: main ? 178.6.w : 168.w),
            child:
                AppImages(height: main ? 40.h : 71.h, width: main ? 12.w : 21.w)
                    .assetImage(
              'assets/images/dino_blue.png',
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: main ? 112.h : 205.h,
              left: main ? 196.w : 205.w,
              right: 100.w,
            ),
            child: SvgPicture.asset(
              'assets/icons/logo_text.svg',
              width: main ? 52.w : 92.w,
              height: main ? 28.h : 49.h,
            ),
          ),
          if (onPressDone != null)
            Padding(
              padding: EdgeInsets.only(bottom: 71.h),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CustomButton(
                  onTap: () {
                    onPressDone!();
                  },
                  title: 'Далее',
                ),
              ),
            ),
        ],
      ),
    );
  }
}
