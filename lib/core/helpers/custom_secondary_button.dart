import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prosto_doc/core/helpers/colors.dart';

class CustomSecondaryButton extends StatelessWidget {
  final Function() onTap;
  final String title;
  // bool accent;
  // Color? color;

  const CustomSecondaryButton({
    super.key,
    required this.onTap,
    required this.title,
    // this.color,
    // this.accent = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 50,
        width: 250,
        margin: const EdgeInsets.only(left: 70, right: 70),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(60.r),
          border: Border.all(
            color: AppColors.textColor,
            width: 2,
          ),
          // color: color ?? (accent ? AppColors.textColor : AppColors.whiteColor),
          // boxShadow: [
          //   if (!accent)
          //     BoxShadow(
          //       color: AppColors.blackColor.withOpacity(0.25),
          //       blurRadius: 4.r,
          //     ),
          // ],
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textColor,
          ),
        ),
      ),
    );
  }
}
