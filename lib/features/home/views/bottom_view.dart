import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prosto_doc/core/helpers/colors.dart';
import 'package:prosto_doc/features/home/views/navigation/main_categories_view.dart';

class BottomView extends StatefulWidget {
  const BottomView({super.key});

  @override
  State<BottomView> createState() => _BottomViewState();
}

class _BottomViewState extends State<BottomView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: PageView(
        children: [
          const MainCategoriesView(),
          Container(color: AppColors.errorColor),
          Container(color: AppColors.textColor),
        ],
      ),
      bottomNavigationBar: Container(
        height: 86.h,
        child: BottomNavigationBar(
          selectedItemColor: AppColors.textColor,
          unselectedItemColor: AppColors.greyColor,
          selectedLabelStyle: GoogleFonts.poppins(
            fontSize: 12.h,
            color: AppColors.textColor,
            fontWeight: FontWeight.w400,
          ),
          unselectedLabelStyle: GoogleFonts.poppins(
            fontSize: 12.h,
            color: AppColors.greyColor,
            fontWeight: FontWeight.w400,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Container(
                height: 24.h,
                width: 24.w,
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                  'assets/icons/Home.svg',
                  height: 20.h,
                  width: 26.w,
                ),
              ),
              label: 'Категории',
            ),
            BottomNavigationBarItem(
              icon: Container(
                height: 24.h,
                width: 24.w,
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                  'assets/icons/Discovery.svg',
                  height: 20.h,
                  width: 20.w,
                ),
              ),
              label: 'Документы',
            ),
            BottomNavigationBarItem(
              icon: Container(
                height: 24.h,
                width: 24.w,
                alignment: Alignment.topCenter,
                child: SvgPicture.asset(
                  'assets/icons/Profile.svg',
                  height: 20.h,
                  width: 26.w,
                ),
              ),
              label: 'Профиль',
            ),
          ],
        ),
      ),
    );
  }
}
