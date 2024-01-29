import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prosto_doc/core/helpers/colors.dart';

class CustomButton extends StatelessWidget {
  final Function() onTap;
  final String title;
  bool accent;
  Color? color;

  CustomButton({
    super.key,
    required this.onTap,
    required this.title,
    this.color,
    this.accent = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 50.h,
        width: 250.w,
        margin: EdgeInsets.only(
            left: 70.w, right: 70.w, bottom: title == 'Даллее' ? 71.h : 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60.r),
          color: color ?? (accent ? AppColors.textColor : AppColors.whiteColor),
          boxShadow: [
            if (!accent)
              BoxShadow(
                color: AppColors.blackColor.withOpacity(0.25),
                blurRadius: 4.r,
              ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18.h,
            fontWeight: FontWeight.w600,
            color: accent ? AppColors.whiteColor : AppColors.greyColor,
          ),
        ),
      ),
    );
  }
}
